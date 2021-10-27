-- Raise3D Pro2, by BAT - 06/05/2019

-- tool 0 is left extruder, tool 1 is right extruder
-- inside iceSL when associating an extruder to a brush: extruder 0 = left; extruder 1 = right

-- extruder_swap_retract_length_mm is not used. A custom variable is instead used to guarantee different settings
-- for both materials in case different retraction length are necessary

-- extruder swap retraction at startup is implemented to compensate the missing swap retraction on startup

-- beaware that extruder_swap is called by iceSL engine on swaps and only needs to address the swap retraction:
-- subsequent extruder heating and swap priming are already called automatically by iceSL engine

-- An E-value reset is implemented on each layer change and on each extruder swap

-- The power failure recovery in the footer is not implemented

-- The output GCODE has a decent amount of comments, if no comments are needed verbose can be turned off from the custom setting "verbose_ON"


version = 2


function comment(text)
  if verbose_ON then
    output('; ' .. text)
  end
end

-- variable initialization
swapping = false
header_retraction_multi = 1
first_select_call = 0

current_z = 0
current_extruder = -1

extruder_e = {}
extruder_e_restart = {}
retractlen = {}
primelen = {}
total_retracted_length= {}

extruder_e[0] = 0
extruder_e[1] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0
retractlen[0] = 0
retractlen[1] = 0
primelen[0] = 0
primelen[1] = 0
total_retracted_length[0] = 0
total_retracted_length[1] = 0

traveling = 0

-- disabling smart retraction if retract_after_z <= 0
if retract_after_z > 0 then
  smart_retraction = true
else
  smart_retraction = false
end

-- extruders will be retracted of the filament_priming_mm length at the end of the header
-- even if E = 0 due to G92 E0 command
function header() 
  -- heating up: bed before extruders

  set_bed_temperature(bed_temp_degree_c)
  set_and_wait_bed_temperature(bed_temp_degree_c)

  for _, extruder in pairs(extruders) do
    set_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end
  for _, extruder in pairs(extruders) do
    set_and_wait_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end

  output('M107')

  -- homing
  output('G28 X0 Y0')
  output('G28 Z0')

  -- settings
  output('M82 ; use absolute distances for extrusion')
  output('G21 ; set units to millimeters')
  output('G90 ; use absolute coordinates')

  output('G21 ; set units to millimeters')
  output('M82 ; use absolute distances for extrusion')
  
  if low_motor_current then -- sets lower motor current (useful for heat creep issues)
  	output('M906 E400 ; forces motor current to 400mA to avoid heat creep')
  end

  -- purging
  output('G1 Z15.0 F9000.00') -- bed moves away 15mm

  header_purging_length = 25
  for _, extruder in pairs(extruders) do
    retractlen[extruder] = filament_priming_mm[extruder]*header_retraction_multi
    output('T' .. extruder)
    output('G92 E0')
    output('G1 F140 E' .. header_purging_length)
    output('G1 F2400 E' .. ff(header_purging_length - retractlen[extruder])) -- fast retraction after purging
    output('G92 E0')
    current_extruder = extruder
  end

  output('G1 X40 Y0 F70') -- slow movement to let oozing end
  output('G1 F9000.0 X150 Y0 Z2') -- fast acceleration to stop oozing after purging has ended and bed moves closer
  output('G1 F12000.0 X300 Y0') -- finish moving to get to the other end of the X axis
  output('G1 F500.0 X155 Y0') -- gets back to the center slowly to allow removing eventual oozed material manually
  output('G1 F10.0 X150 Y0') -- gets back to the center slowly to allow removing eventual oozed material manually
  output('M117 Printing...')
  output('M1001 ; start counting lines (power failure)')
end

function footer()
  output('G92 E0') -- reset E-value
  output('M1002 ; stop counting lines')
  for _, extruder in pairs(extruders) do -- shut down extruders
    set_extruder_temperature(extruder,0)
  end
  output('M140 S0') -- shut down heated bed
  output('G91')
  output('G1 E-1 F300') -- small retraction to avoid oozing on the finished print
  output('G1 Z+75 E-5 X-20 Y-20 F6000.0') -- relative displacement to avoid oozing on the finished print
  output('G28 X0 Y0') -- homing
  output('M221 T0 S100') -- reset flow to 100% for left extruder
  output('M221 T1 S100') -- reset flow to 100% for right extruder
  output('M107') -- shut down fan
  output('M84')
  output('G90') 

  local nb_extr = 0
  for _, extruder in pairs(extruders) do
    nb_extr = nb_extr + 1
  end
  local nb_line_recover = 20 + nb_extr * 8

  -- Recover from power failure
  output(';Recover start:'..nb_line_recover)
  output(';G21')
  output(';G90')
  output(';G28 X0 Y0')
  output(';G92 X0 Y0 Z{z}')
  output(';G21')
  output(';G90')
  output(';M82')
  output(';M106 S0')

  for _, extruder in pairs(extruders) do
    len = filament_priming_mm[extruder]
    output(';T' .. extruder)
    output(';G92 E0')
    output(';G1 F200 E10')
    output(';G92 E0')
    output(';G1 F200 E' .. ff(-len))
    current_extruder = extruder
  end

  output(';T{current_extruder}')
  output(';M106{current_fan_speed}')
  output(';G92 E{current_extrusion}')
  output(';G0 F6000 X{x} Y{y} Z{z}')
  output(';G0 F{current_travel_speed}')
  output(';G1 F{current_extrude_speed} E{current_extrusion}')
  output(';{current_unit}')
  output(';{current_pos_abs}')
  output(';{current_extrude_abs}')
  output(';M117 Printing...')
  output(';Recover end')
end

function retract(extruder,e)
  if swapping then -- setting the right retraction length for each case
    comment('still swapping, now retracting extruder that will go idle')
    retractlen[extruder] = filament_priming_mm[extruder]*swap_length_multi - total_retracted_length[extruder]
    speed = extruder_swap_retract_speed_mm_per_sec * 60
  else
    if smart_retraction and current_z < retract_after_z * (0.01 * (100 + z_extra_height)) then
      comment('bypassing retraction due to smart retraction: ' .. z .. ' < ' .. retract_after_z * (0.01 * (100 + z_extra_height)))
      retractlen[extruder] = 0
    else
      comment('retract')
      retractlen[extruder] = filament_priming_mm[extruder]
    end
    speed = retract_mm_per_sec[extruder] * 60
  end
  extruder_e[extruder] = e - retractlen[extruder]
  output('G0 F' .. speed .. ' E' .. ff(extruder_e[extruder] - extruder_e_restart[extruder]))
  total_retracted_length[extruder] = total_retracted_length[extruder] + retractlen[extruder] -- needed if consecutive retractions happen
  -- THE ONES BELOW ARE ONLY FOR DEBUGGING
  --[[
  output(';e =' .. e)
  output(';extruder = ' .. extruder)
  output(';retractlen[extruder] = ' .. retractlen[extruder])
  output(';extruder_e[extruder] = ' .. extruder_e[extruder])
  output(';extruder_e_restart[extruder] = ' .. extruder_e_restart[extruder])
  output(';total_retracted_length[extruder] = ' .. total_retracted_length[extruder])
  --]]
  return extruder_e[extruder]
end

function prime(extruder,e)
  if swapping then -- setting the right retraction length for each case
    comment('still swapping, now priming active extruder')
    primelen[extruder] = filament_priming_mm[extruder]*swap_length_multi
    extra_priming = extra_extruder_e_swap_restart
    speed = extruder_swap_retract_speed_mm_per_sec * 60
  else
    if smart_retraction and current_z < retract_after_z * (0.01 * (100 + z_extra_height)) then
      comment('bypassing priming due to smart retraction: ' .. z .. ' < ' .. retract_after_z * (0.01 * (100 + z_extra_height)))
      primelen[extruder] = 0
    else
      comment('priming')
      primelen[extruder] = filament_priming_mm[extruder]
    end
    extra_priming = extra_extruder_e_restart
    speed = priming_mm_per_sec[extruder] * 60
  end
  extruder_e[extruder] = e + primelen[extruder]
  output('G0 F' .. speed .. ' E' .. ff(extruder_e[extruder] + extra_priming - extruder_e_restart[extruder]))
  total_retracted_length[extruder] = total_retracted_length[extruder] - primelen[extruder] -- needed if consecutive retractions happen
  -- THE ONES BELOW ARE ONLY FOR DEBUGGING
  --[[
  output(';e =' .. e)
  output(';extruder = ' .. extruder)
  output(';retractlen[extruder] = ' .. retractlen[extruder])
  output(';extruder_e[extruder] = ' .. extruder_e[extruder])
  output(';extruder_e_restart[extruder] = ' .. extruder_e_restart[extruder])
  output(';total_retracted_length[extruder] = ' .. total_retracted_length[extruder])
  --]]
  swapping = false -- set to default value
  return extruder_e[extruder]
end

function select_extruder(extruder) -- this is called once for each used extruder at startup
  first_select_call = first_select_call + 1
  output('T' .. extruder)
  current_extruder = extruder
  if first_select_call <= 2 then -- resetting E value on startup
    output('G92 E0')
  end
end

function swap_extruder(from,to,x,y,z)
  swapping = true -- set to non-default value
  traveling = 0 -- resetting travel identification variable
  comment('swap_extruder')  
  retract(from, extruder_e[from])
  extruder_e[from] = extruder_e[from] + retractlen[from] -- adding back retractlen because the next retraction is not updating the e value of ice-sl enging 
  extruder_e_restart[from] = extruder_e[from] 
  output('G92 E0')
  select_extruder(to)
  -- no set and wait temperature and priming because these function are called automatically by icesl
end

function e_reset()
  for _, extruder in pairs(extruders) do
    extruder_e_restart[extruder] = extruder_e[extruder]
  end
  output('G92 E0')
end

function swapretraction_header_compensation()
  comment('force the swap retraction on idle extruder to be finished after header and extruder initialization')
  if current_extruder == 0 then -- selecting the idle extruder
    output('T1')
    forcing_swap_on_extr = 1
  elseif current_extruder == 1 then
    output('T0')
    forcing_swap_on_extr = 0
  end
  -- forcing a swap retraction on the idle extruder since swap function is not called at startup
  extruder_e[forcing_swap_on_extr] = 0 - filament_priming_mm[forcing_swap_on_extr] * (swap_length_multi - 2 * header_retraction_multi)
  output('G0 F' .. speed .. ' E' .. ff(extruder_e[forcing_swap_on_extr])) -- one retraction already done during header and one on extruder initialization
  extruder_e_restart[forcing_swap_on_extr] = extruder_e[forcing_swap_on_extr]
  total_retracted_length[forcing_swap_on_extr] = filament_priming_mm[forcing_swap_on_extr] * swap_length_multi
  output('G92 E0')
  -- restoring correct extruder (the active one) and priming it to compensate header retraction
  output('T' .. current_extruder)
  set_and_wait_extruder_temperature(current_extruder, extruder_temp_degree_c[current_extruder])
  if CompHeaderActiveExtRectraction then
    output('; force a priming on the active extruder to compensate header retraction')
    output('G0 F' .. speed .. ' E' .. ff(filament_priming_mm[current_extruder] * header_retraction_multi + extra_extruder_e_restart))
    output('G92 E0')
  end
end

function layer_start(zheight)
  traveling = 0 -- resetting travel identification variable
  if layer_id == 0 then
    -- forcing a swap retraction on the idle extruder since swap function is not called at startup
    if number_of_extruders == 2 then
      swapretraction_header_compensation()
    end
    -- applying z movement
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  comment('(<layer ' .. layer_id .. '>)')
  current_z = zheight
end

function layer_stop()
  traveling = 0 -- resetting travel identification variable
  e_reset()
  comment('(</layer>)')
end

function move_xyz(x,y,z)
  if traveling == 0 then
    traveling = 1 -- start traveling
    comment('travel')
  end

  if x == current_x and xy_caching then
    x_string = ''
  else
    current_x = x
    x_string = (' X' .. f(x))
  end

  if y == current_y and xy_caching then
    y_string = ''
  else
    current_y = y
    y_string = (' Y' .. f(y))
  end

  if z == current_z and z_caching then
    z_string = ''
  else
    current_z = z
    z_string = (' Z' .. ff(z * (0.01 * (100 + z_extra_height)) + z_offset))
  end

  output('G0 F' .. f(current_frate) .. x_string .. y_string .. z_string)
end

function move_xyze(x,y,z,e)
  if traveling == 1 then
    traveling = 0 -- start path
    if path_is_perimeter then
      comment('TYPE:WALL-OUTER')
    else
      if      path_is_shell   then comment('TYPE:WALL-INNER')
      elseif  path_is_infill  then comment('TYPE:FILL')
      elseif  path_is_raft    then comment('TYPE:RAFT')
      elseif  path_is_brim    then comment('TYPE:SKIRT')
      elseif  path_is_shield  then comment('TYPE:SHIELD')
      elseif  path_is_support then comment('TYPE:SUPPORT')
      elseif  path_is_tower   then comment('TYPE:TOWER')
      end
    end
  end

  extruder_e[current_extruder] = e
  letter = 'E'

  if x == current_x and xy_caching then
    x_string = ''
  else
    current_x = x
    x_string = (' X' .. f(x))
  end

  if y == current_y and xy_caching then
    y_string = ''
  else
    current_y = y
    y_string = (' Y' .. f(y))
  end

  if z == current_z and z_caching then
    z_string = ''
  else
    current_z = z
    z_string = (' Z' .. ff(z * (0.01 * (100 + z_extra_height)) + z_offset))
  end

  output('G1 F' .. f(current_frate) .. x_string .. y_string .. z_string .. ' ' .. letter .. ff(e-extruder_e_restart[current_extruder]))
end

function move_e(e)
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G0 ' .. letter .. ff(e-extruder_e_restart[current_extruder]))
end

function set_feedrate(feedrate)
  current_frate = feedrate
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
end

function set_bed_temperature(temperature)
  output('M140 S' .. f(temperature))
end

function set_and_wait_bed_temperature(temperature)
  output('M140 S' .. f(temperature))
end

function set_extruder_temperature(extruder,temperature)
  output('M104 T' .. extruder .. ' S' .. f(temperature))
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G0 F" .. travel_speed_mm_per_sec .. " X10 Y10")
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
  output("G0 F" .. travel_speed_mm_per_sec .. " X" .. f(x) .. " Y" .. f(y) .. " Z" .. ff(z))
end
