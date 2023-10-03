-- QIDI Tech X-PRO, by BAT - 30/10/2018
-- modified from Generic RepRap and from Qidi Avatar IV profile by mm1980
-- both single and dual extrusion should be OK
-- this version uses only E command to extrude so it is always necessary to toolchange before extruding
-- A & B letters in place of E for G0 or G1 commands would allow simultaneous extrusion on both extruders

function comment(text)
  output('; ' .. text)
end

--variables initialization
current_x = 0       --X cache, produce shorter G-code (emit X only if changed)
current_y = 0       --Y cache, produce shorter G-code (emit Y only if changed)
current_z = 0       --Z cache, produce shorter G-code (emit Z only if changed)
current_frate = 100 --F cache, produce shorter G-code (emit F only if changed)
current_extruder = 0
disabled_extruder = 0
extruder_e = 0
last_e = 0
swapping = false -- global variable to handle extruder swaps and their retractions/primings

-- if using both extruders, retracts the idle one after purging since both are being preheated with the header
-- and can't handle iceSL calls to extruder swap or similar during header
if number_of_extruders == 1 then
  startingretraction = false
else
  startingretraction = true
end

-- disabling smart retraction if qidi_retract_after_z <= 0
if qidi_retract_after_z > 0 then
  smart_retraction = true
else
  smart_retraction = false
end

filament_priming_mm = {}                        -- retraction/priming lengths
filament_priming_mm[0] = filament_priming_mm_0  -- extruder 0 (right) retraction length
filament_priming_mm[1] = filament_priming_mm_1  -- extruder 1 (left) retraction length

idle_extruder_temp_degree_c = {}                        -- idle extruder temperatures lengths
idle_extruder_temp_degree_c[0] = idle_extruder_temp_degree_c_0  -- extruder 0 (right) idle temp
idle_extruder_temp_degree_c[1] = idle_extruder_temp_degree_c_1  -- extruder 1 (left) idle temp

if use_different_height_first_layer then
  header_priming_height = z_layer_height_first_layer_mm + qidi_z_offset
  header_priming_length = (225-35) * nozzle_diameter_mm * z_layer_height_first_layer_mm / (1.75^2*3.14/4)
else
  header_priming_height = z_layer_height_mm + qidi_z_offset
  header_priming_length = (225-35) * nozzle_diameter_mm * z_layer_height_mm / (1.75^2*3.14/4)
end

function header()

  h = file('header.gcode')

  if number_of_extruders == 1 then
    current_extruder = extruders[0]
    h = h:gsub( '<TOOLTEMP0>', 'M104 S' .. extruder_temp_degree_c[current_extruder] .. ' T' .. current_extruder )
    h = h:gsub( '<WAITTEMP0>', 'M133 T' .. current_extruder )
    h = h:gsub( '<TOOLCHOICE>', 'T' ..  current_extruder .. '; ensuring the right extruder is active')
    h = h:gsub( '<PRIMINGTOOL0>', 'G1 X220 E' .. header_priming_length .. ' F2400' .. '; purging and priming some mm on first move')
    h = h:gsub( '<PRIMINGTOOL1>', 'G1 X35 E' .. header_priming_length .. ' F2400' .. '; purging and priming some mm on second move')

    if extruders[0] == 0 then
      disabled_extruder = 1
      h = h:gsub( '<TOOLTEMP1>', 'M104 S' .. 0 .. ' T' .. disabled_extruder  .. '; extruder ' .. disabled_extruder .. ' is disabled' )
      h = h:gsub( '<WAITTEMP1>', 'M133 T' .. 1 )
    else
      disabledextruder = 0
      h = h:gsub( '<TOOLTEMP1>', 'M104 S' .. 0 .. ' T' .. disabled_extruder  .. '; extruder ' .. disabled_extruder .. ' is disabled' )
      h = h:gsub( '<WAITTEMP1>', 'M133 T' .. 0 )
    end

  elseif number_of_extruders == 2 then
      h = h:gsub( '<TOOLTEMP0>', 'M104 S' .. extruder_temp_degree_c[extruders[0]] .. ' T' .. extruders[0] )
      h = h:gsub( '<TOOLTEMP1>', 'M104 S' .. extruder_temp_degree_c[extruders[1]] .. ' T' .. extruders[1] )
      h = h:gsub( '<WAITTEMP0>', 'M133 T' .. extruders[0] )
      h = h:gsub( '<WAITTEMP1>', 'M133 T' .. extruders[1] )
      h = h:gsub( '<TOOLCHOICE>', '; dual printing is active')
      current_extruder = 0
      h = h:gsub( '<PRIMINGTOOL0>', 'G1 X220 E' .. header_priming_length .. ' F2400 T1' .. '; purging and priming some mm on the left extruder')
      current_extruder = 1
      h = h:gsub( '<PRIMINGTOOL1>', 'G1 X35 E' .. header_priming_length .. ' F2400 T0' .. '; purging and priming some mm on the right extruder')
  else

    error('wrong number of extruders' .. extruders .. ' ' .. number_of_extruders .. ' ' .. asd)
  end

  h = h:gsub( '<PRIMINGHEIGHT>', header_priming_height)
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer>')
  current_z = zheight
  if not layer_spiralized then
    output('G1 Z' .. f(zheight * (0.01 * (100 + qidi_z_extra_height)) + qidi_z_offset))
  end
end

function layer_stop()
  last_e = extruder_e
  output('G92 E0') -- resetting extrusion length value on layer change
  comment('</layer>')
end

function select_extruder(extruder)
  if startingretraction then
    output('T' .. extruder .. ' ; select_extruder tool(' .. disabled_extruder .. ')')
    speed = priming_mm_per_sec * 60
    len = filament_priming_mm[disabled_extruder]
    Qretract(speed,len,true)
    speed = extruder_swap_retract_speed_mm_per_sec * 60
    len = extruder_swap_retract_length_mm
    Qretract(speed,len,true)
    set_extruder_temperature(disabled_extruder,idle_extruder_temp_degree_c[disabled_extruder])
    startingretraction = false
  end
current_extruder = extruder
output('T' .. extruder .. ';select_extruder tool(' .. current_extruder .. ')')
end

function swap_extruder(from,to,x,y,z)
   output('; swap_extruder')
   current_extruder = from
   set_extruder_temperature(current_extruder,idle_extruder_temp_degree_c[current_extruder])
   swapping = true
   speed = extruder_swap_retract_speed_mm_per_sec * 60
   len = extruder_swap_retract_length_mm
   Qretract(speed,len,swapping)
   current_extruder = to
   last_e = extruder_e
   output('G92 E0') -- resetting extrusion length value on extruder swap
end

function Qretract(speed,len,swapping)
  if smart_retraction then
    if current_z >= qidi_retract_after_z * (0.01 * (100 + qidi_z_extra_height)) or swapping then -- correcting qidi_retract_after_z with (0.01 * (100 + qidi_z_extra_height))
      extruder_e = extruder_e - len
      output('G1 F' .. speed .. ' E' .. ff(extruder_e - last_e))
    end
  else
    extruder_e = extruder_e - len
    output('G1 F' .. speed .. ' E' .. ff(extruder_e - last_e))
  end
   return extruder_e
end

function Qrestore(speed,len,swapping)
  if smart_retraction then
    if current_z >= qidi_retract_after_z * (0.01 * (100 + qidi_z_extra_height)) or swapping then -- correcting qidi_retract_after_z with (0.01 * (100 + qidi_z_extra_height))
      extruder_e = extruder_e + len  + extruder_e_restart
      output('G1 F' .. speed .. ' E' .. ff(extruder_e - last_e))
    end
  else
      extruder_e = extruder_e + len  + extruder_e_restart
      output('G1 F' .. speed .. ' E' .. ff(extruder_e - last_e))
  end
   return extruder_e
end

function retract(extruder,e)
  swapping = false
  speed = retract_mm_per_sec[extruder] * 60
  len = filament_priming_mm[current_extruder]
  return Qretract(speed,len,swapping)
end

function prime(extruder,e)
  swapping = false
  speed = priming_mm_per_sec[extruder] * 60
  len   = filament_priming_mm[current_extruder]
  return Qrestore(speed,len,swapping)
end

function move_xyz(x,y,z)

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
    z_string = (' Z' .. f(z * (0.01 * (100 + qidi_z_extra_height)) + qidi_z_offset))
  end

  output('G1' .. x_string .. y_string .. z_string)

end

function move_xyze(x,y,z,e)

  extruder_e = e

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
    z_string = (' Z' .. f(z * (0.01 * (100 + qidi_z_extra_height)) + qidi_z_offset))
  end

  output('G1' .. x_string .. y_string .. z_string .. ' E' .. ff(extruder_e - last_e))

end

function move_e(e)
  extruder_e = e
  output('G1 E' .. ff(extruder_e - last_e))
end

function set_feedrate(feedrate)
  if current_frate == feedrate then
    --do nothing
  else
    output('G1 F' .. feedrate)
    current_frate = feedrate
  end
end

function extruder_start()
  -- not implemented
end

function extruder_stop()
  -- not implemented
end

function progress(percent)
  output('M73 P' .. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
  if swapping then -- if extruders were just swapped then restore the one that has to work
    speed = extruder_swap_retract_speed_mm_per_sec * 60
    len = extruder_swap_retract_length_mm
    Qrestore(speed,len,swapping)
    swapping = false
  end
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
  output('M133 ' .. 'T' .. extruder)
  if swapping then -- if extruders were just swapped then restore the one that has to work
    speed = extruder_swap_retract_speed_mm_per_sec * 60
    len = extruder_swap_retract_length_mm
    Qrestore(speed,len,swapping)
    swapping = false
  end
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
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
end
