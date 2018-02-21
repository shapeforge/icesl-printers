-- Prusa i3 MK2 MultiMaterial
-- 2017-11-21

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
extruder_e[2] = 0
extruder_e[3] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0
extruder_e_restart[2] = 0
extruder_e_restart[3] = 0

traveling = 0

function header()
  output('M107')

  output('M115 U3.0.12 ;latest firmware version')

  output('M104 S' .. extruder_temp_degree_c[extruders[0]] )
  output('M140 S' .. bed_temp_degree_c )
  output('M109 S' .. extruder_temp_degree_c[extruders[0]] )
  output('M190 S' .. bed_temp_degree_c )

  -- Z calibration + homing
  output('G28 W')
  output('G80')

  output('M82 ; use absolute distances for extrusion')
  output('G21 ;set units to millimeters')
  output('G90 ;use absolute coordinates')

  output('G21 ; set units to millimeters')
  output('M82 ; use absolute distances for extrusion')
  output('G92 E0')
end

function footer()
  output('M107')
  output('M104 S0')
  output('M140 S0')
  output('G1 X0')
  output('M84')
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
  if layer_id == 1 then
    output('M106 S255') -- fan ON
  end
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  current_z = zheight
end

function layer_stop()
  extruder_e_restart[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  output(';(</layer>)')
end


swap_dist_mm = 60

function load_extruder(extruder)
  local tower_u = extruder_swap_location_y_mm - swap_dist_mm/2
  local tower_d = extruder_swap_location_y_mm + swap_dist_mm/2

  -- load filament
  output(';load extruder ' .. extruder)
  output('T' .. extruder)
  output('G92 E0')
  output('G1 E20.0000 Y' .. f(tower_d) .. ' F1400')
  output('G1 E60.0000 Y' .. f(tower_u) .. ' F3000')
  output('G1 E80.0000 Y' .. f(tower_d) .. ' F1600')
  output('G1 E90.0000 Y' .. f(tower_u) .. ' F1000')

  output('G4 S0')

  output('G92 E0')

  current_extruder = extruder
end

function unload_extruder(extruder)
  local tower_u = extruder_swap_location_y_mm - swap_dist_mm/2
  local tower_d = extruder_swap_location_y_mm + swap_dist_mm/2

  output(';unload extruder ' .. extruder)
  output('G92 E0')
  output('G1 E-15.0000 Y' .. f(tower_u) .. ' F5000')
  output('G1 E-65.0000 Y' .. f(tower_d) .. ' F5400')
  output('G1 E-80.0000 Y' .. f(tower_u) .. ' F3000')
  output('G1 E-92.0000 Y' .. f(tower_d) .. ' F2000')

  output('G1 E-89.0000 Y' .. f(tower_u) .. ' F1600')
  output('G1 E-94.0000 Y' .. f(tower_d))
  output('G1 E-89.0000 Y' .. f(tower_u) .. ' F2000')
  output('G1 E-94.0000 Y' .. f(tower_d))
  output('G1 E-89.0000 Y' .. f(tower_u) .. ' F2400')
  output('G1 E-94.0000 Y' .. f(tower_d))
  output('G1 E-94.0000 Y' .. f(tower_u))
  output('G1 E-89.0000 Y' .. f(tower_d))
  output('G1 E-92.0000 Y' .. f(tower_u))
  output('G4 S0')
end

-- this is called once for each used extruder at startup
function select_extruder(extruder)
  local tower_u = swap_dist_mm
  local tower_d = 0

  output('G1 Z1.5 X0.0000 Y' .. (-3 + f(extruder)*2.5) .. ' F3000.0')

  if current_extruder > -1 then
    output(';unload extruder ' .. current_extruder)
    output('G92 E0')
    output('G1 E-15.0000 X' .. f(tower_u) .. ' F5000')
    output('G1 E-65.0000 X' .. f(tower_d) .. ' F5400')
    output('G1 E-80.0000 X' .. f(tower_u) .. ' F3000')
    output('G1 E-92.0000 X' .. f(tower_d) .. ' F2000')

    output('G1 E-89.0000 X' .. f(tower_u) .. ' F1600')
    output('G1 E-94.0000 X' .. f(tower_d))
    output('G1 E-89.0000 X' .. f(tower_u) .. ' F2000')
    output('G1 E-94.0000 X' .. f(tower_d))
    output('G1 E-89.0000 X' .. f(tower_u) .. ' F2400')
    output('G1 E-94.0000 X' .. f(tower_d))
    output('G1 E-94.0000 X' .. f(tower_u))
    output('G1 E-89.0000 X' .. f(tower_d))
    output('G1 E-92.0000 X' .. f(tower_u))
  end

  -- load filament
  output(';load extruder ' .. extruder)
  output('T' .. extruder)
  output('G92 E0')

  output('G1 E20.0000 X' .. f(tower_d) .. ' F1400')
  output('G1 E60.0000 X' .. f(tower_u) .. ' F3000')
  output('G1 E80.0000 X' .. f(tower_d) .. ' F1600')
  output('G1 E90.0000 X' .. f(tower_u) .. ' F1000')

  output('G4 S0')

  output('G92 E0')

  -- prime outside print area
  output('G1 Z0.5 X100.0 E5.00 F1000.0')
  output('G1 Z0.5 X200.0 E20.0 F1000.0')

  -- prime done, reset E
  output('G92 E0')
  current_extruder = extruder
end

function swap_extruder(from,to,x,y,z)
  extruder_e_restart[current_extruder] = extruder_e[current_extruder]

  local len   = extruder_swap_retract_length_mm
  local speed = extruder_swap_retract_speed_mm_per_sec * 60

  output(';swap_extruder')
  unload_extruder(from)
  load_extruder(to)
end

function move_xyz(x,y,z)
  if traveling == 0 then
    traveling = 1 -- start traveling
    output(';travel')
    output('M204 S3000')
    output('M205 X20')
  end

  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

coeff = 1
function move_xyze(x,y,z,e)
  if traveling == 1 then
    traveling = 0 -- start path
    if path_is_perimeter then
      output(';perimeter')
      output('M204 S500')
      output('M205 X5')
    else
      if      path_is_shell   then output(';shell')   coeff = 1
      elseif  path_is_infill  then output(';infill')  coeff = 1
      elseif  path_is_raft    then output(';raft')    coeff = 1
      elseif  path_is_brim    then output(';brim')    coeff = 1
      elseif  path_is_shield  then output(';shield')  coeff = 1
      elseif  path_is_support then output(';support') coeff = 1
      elseif  path_is_tower   then output(';tower')   coeff = 2
      end
      output('M204 S1000')
      output('M205 X10')
    end
  end

  extruder_e[current_extruder] = e
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate * coeff) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
  else
    output('G1 F' .. f(current_frate * coeff) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
    current_z = z
  end
end

function move_e(e)
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G0 ' .. letter .. f(e-extruder_e_restart[current_extruder]))
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

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_fan_speed(speed)
  output('M106 S'.. math.floor(255 * speed/100))
end
