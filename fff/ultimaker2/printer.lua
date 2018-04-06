-- Ultimaker 2
-- Sylvain Lefebvre  2014-03-08

version = 2

function comment(text)
  output('; ' .. text)
end

to_cubic_mm = 1

function header()
  r = filament_diameter_mm[extruders[0]] / 2
  to_mm_cube = 3.14159 * r * r
  output(';FLAVOR:UltiGCode')
  output(';TIME:' .. time_sec)
  output(';MATERIAL:' .. to_mm_cube*filament_tot_length_mm[extruders[0]])
  output(';MATERIAL2:0')
  output('M107')
end

function footer()
  output('M107')
  output('G10')
end

function retract(extruder,e)
  output('G10')
  return e
end

function prime(extruder,e)
  output('G11')
  return e
end

current_z = 0
current_extruder = 0
current_frate = 600

function layer_start(zheight)
  output(';(<layer>)')
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

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  r = filament_diameter_mm[extruders[0]] / 2
  to_mm_cube = 3.14159 * r * r
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff(e*to_mm_cube))
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff(e*to_mm_cube))
    current_z = z
  end
end

function move_e(e)
  letter = 'E'
  r = filament_diameter_mm[extruders[0]] / 2
  to_mm_cube = 3.14159 * r * r
  output('G1 ' .. letter .. ff(e*to_mm_cube))
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
  output('M104 S' .. f(temperature) .. ' T' .. extruder)
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
