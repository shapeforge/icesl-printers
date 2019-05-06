-- Ultimaker 2
-- Sylvain Lefebvre  2014-03-08

function comment(text)
  output('; ' .. text)
end

function to_mm_cube(e)
  local r = filament_diameter_mm[extruders[0]] / 2
  return math.pi * r * r * e
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function header()
  output(';FLAVOR:UltiGCode')
  output(';TIME:' .. time_sec)
  output(';MATERIAL:' .. to_mm_cube( filament_tot_length_mm[extruders[0]]) )
  output(';MATERIAL2:0')
  output(';NOZZLE_DIAMETER:' .. round(nozzle_diameter_mm,2))
  output('M107')
  --output('M207 F' .. priming_mm_per_sec * 60 .. ' S' .. filament_priming_mm_0)
  --output('M208 F' .. priming_mm_per_sec * 60 .. ' S' .. filament_priming_mm_0)
  output('M82')
  output('G92 E0')
end

function footer()
  output('G10')
  output('M107')
end

reset_e_on_next_prime = false
extruder_e = 0
extruder_e_reset = 0

function retract(extruder,e)
  extruder_e = e
  output('G10')
  return e
end

function prime(extruder,e)
  extruder_e = e
  output('G11')
  if reset_e_on_next_prime == true then
    output('G92 E0')
    extruder_e_reset = extruder_e
    reset_e_on_next_prime = false
  end
  return e
end

current_z = 0
current_extruder = 0
current_frate = 600

function layer_start(zheight)
  output(';<layer ' .. layer_id .. '>')
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  current_z = zheight
end

function layer_stop()
  reset_e_on_next_prime = true
  output(';</layer ' .. layer_id .. '>')
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
  letter = 'E'
  extruder_e = e
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff(to_mm_cube(e - extruder_e_reset)) )
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff(to_mm_cube(e - extruder_e_reset)) )
    current_z = z
  end
end

function move_e(e)
  letter = 'E'
  extruder_e = e
  output('G1 ' .. letter .. ff(to_mm_cube(e - extruder_e_reset)))
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
