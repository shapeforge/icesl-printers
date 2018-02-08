-- IeC 9-12 veloce
-- 2018-02-08

version = 1

function comment(text)
  output('; ' .. text)
end

current_z = 0
current_extruder = 0

traveling = 0

extruder_e = {}
extruder_e_restart = {}
extruder_stored = {}

for i = 0, extruder_count-1 do
  extruder_e[i] = 0
  extruder_e_restart[i] = 0

  print(i)
end

function header()
  output('G90 ; absolute mode')
  output('G21 ; metric values')
  output('M82 ; Extruder in absolute mode')

  output('M106 S0 ; fan off')

  output('M104 T0 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; heat extruder')
  -- output('M140 S' .. bed_temp_degree_c .. ' ; heat bed')

  output('; set density extrude factor percentage for purge')
  output('M222 T0 S135')
  output('M222 T1 S155')
  output('M222 T2 S155')
  output('M222 T3 S135')
  output('M222 T4 S150')
  output('M222 T5 S155')
  output('M222 T6 S140')
  output('M222 T7 S135')
  output('M222 T8 S160')

  output('M109 T0 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; wait extruder temp')
  -- output('M190 S' .. bed_temp_degree_c .. ' ; wait bed')

  output('G28 ; home all axes')

  output('G1 F12000 X360 Y320')
  output('G1 F100 E50')
  output('G1 Z0')
  output('G1 F3000 X330 Y320')
  output('G1 F3000 X360 Y320')
  output('G1 F3000 X330 Y320')
  output('G92 Z0.0')
  output('G92 E0')

  output('T0')
  current_extruder = 0
end

function footer()
  output('; end GCode')
  output('M106 S0 ; fan off')

  -- unload current filament and set extruder 0
  output('G1 F10800 X360 Y320')
  output('G92 E0')
  output('G1 F10000 E-85')
  output('T0')
  output('G92 E0')
  output('G1 F8000 E83')
  output('G92 E0')
  output('G1 F100 E30')

  for i = 0, extruder_count-1 do
    output('M104 T'.. i ..' S0')
  end
  -- output('M140 S0 ; heated bed heater off (if you have it)')

  output('G1 Z320 F1000')

  output('M84 ; steppers off')
  output('G90 ; absolute positioning')
end

function retract(extruder,e)
  output(';retract')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. f(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. f(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 1 then
    output('M106 S' .. math.floor(255 * fan_speed_multiplier)) -- fan ON
  end
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  current_z = zheight
end

function layer_stop()
  output(';(</layer>)')
end

-- this is called once for each used extruder at startup
function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
  output(';swap_extruder')
  output('M117 Switching color')

  -- reset E axis of previous
  output('G92 E0')
  extruder_e_restart[from] = extruder_e[from]
  -- go to purge area
  output('G1 F12000 X360 Y320')

  -- store filament (large retract)
  if not extruder_stored[from] then
    extruder_stored[from] = true

    output('G1 F8000 E-80')
  end

  -- swap extruder
  output('T' .. to)
  current_extruder = to

  -- unstore filament
  if extruder_stored[to] then
    extruder_stored[to] = false

    output('G92 E0')
    output('G1 F8000 E80')
    output('G92 E0')
    output('G1 F120 P52')
  end
  -- done

  -- clean nozzle
  output('G92 E0')
  retract(current_extruder,0)
  output('G1 F3000 X330 Y320')
  output('G1 F3000 X360 Y320')
  output('G1 F3000 X330 Y320')
  output('G92 E0')
  output('M117 printing...')
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
    if      path_is_perimeter then output(';perimeter')
    elseif  path_is_shell     then output(';shell')
    elseif  path_is_infill    then output(';infill')
    elseif  path_is_raft      then output(';raft')
    elseif  path_is_brim      then output(';brim')
    elseif  path_is_shield    then output(';shield')
    elseif  path_is_support   then output(';support')
    elseif  path_is_tower     then output(';tower')
    end
  end

  extruder_e[current_extruder] = e
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff((e-extruder_e_restart[current_extruder])))
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff((e-extruder_e_restart[current_extruder])))
    current_z = z
  end
end

function move_e(e)
  output('G0 E' .. ff((e-extruder_e_restart[current_extruder])))
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
  output('M104 T' .. extruder .. ' S' .. f(temperature))
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
end
