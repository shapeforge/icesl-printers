-- Raise3D N2 plus
-- 2018-01-24

version = 2

function comment(text)
  output('; ' .. text)
end

current_z = 0
current_extruder = -1

extruder_e = {}
extruder_e_restart = {}

extruder_e[0] = 0
extruder_e[1] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0

traveling = 0


function header()
  -- heating up
  set_bed_temperature(bed_temp_degree_c)
  for _, extruder in pairs(extruders) do
    set_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end
  for _, extruder in pairs(extruders) do
    set_and_wait_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end
  for _, extruder in pairs(extruders) do
    output('T'..extruder)
  end
  set_and_wait_bed_temperature(bed_temp_degree_c)

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

  -- cleaning
  output('G1 Z15.0 F9000.00')

  for _, extruder in pairs(extruders) do
    len = filament_priming_mm[extruder]

    output(';T' .. extruder)
    output(';G92 E0')
    output(';G1 F200 E10')
    output(';G92 E0')
    output(';G1 F200 E' .. ff(-len))

    current_extruder = extruder
  end

  output('M1001 ; start counting lines (power failure)')
end

function footer()
  output('M1002 ; stop counting lines')

  for _, extruder in pairs(extruders) do
    output('M104 T' .. extruder .. ' S0')
  end
  output('M140 S0')
  output('G91')
  output('G28 X0 Y0')
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

  set_bed_temperature(bed_temp_degree_c)

  -- 3 lines per extruder
  for _, extruder in pairs(extruders) do
    set_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end
  for _, extruder in pairs(extruders) do
    set_and_wait_extruder_temperature(extruder, extruder_temp_degree_c[extruder])
  end
  for _, extruder in pairs(extruders) do
    output('T'..extruder)
  end


  set_and_wait_bed_temperature(bed_temp_degree_c)
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
  output(';retract')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  current_z = zheight
end

function layer_stop()
  for _, extruder in pairs(extruders) do
    extruder_e_restart[extruder] = extruder_e[extruder]
  end
  output('G92 E0')
  output(';(</layer>)')
end


function unload_extruder(extruder)
  output('G92 E0')
  retract(extruder, 3)
  current_extruder = -1
end

function load_extruder(extruder)
  output('T' .. extruder)
  prime(extruder, 3)
  current_extruder = extruder
end


-- this is called once for each used extruder at startup
function select_extruder(extruder)
  output('T' .. extruder)
  current_extruder = extruder
end

function swap_extruder(from,to,x,y,z)
  extruder_e_restart[current_extruder] = extruder_e[current_extruder]

  output(';swap_extruder')
  unload_extruder(from)
  load_extruder(to)
  extruder_e_restart[current_extruder] = extruder_e[current_extruder]
end

function move_xyz(x,y,z)
  if traveling == 0 then
    traveling = 1 -- start traveling
    output(';travel')
  end

  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  if traveling == 1 then
    traveling = 0 -- start path
    if path_is_perimeter then
      output(';TYPE:WALL-OUTER')
    else
      if      path_is_shell   then output(';TYPE:WALL-INNER')
      elseif  path_is_infill  then output(';TYPE:FILL')
      elseif  path_is_raft    then output(';TYPE:RAFT')
      elseif  path_is_brim    then output(';TYPE:SKIRT')
      elseif  path_is_shield  then output(';TYPE:SHIELD')
      elseif  path_is_support then output(';TYPE:SUPPORT')
      elseif  path_is_tower   then output(';TYPE:TOWER')
      end
    end
  end

  extruder_e[current_extruder] = e
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
    current_z = z
  end
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