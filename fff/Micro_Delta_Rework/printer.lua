-- EmotionTech Micro Delta Rework
-- Pierre Bedell 05/06/2018

extruder_e = 0
extruder_e_restart = 0

current_z = 0.0

bed_origin_x = bed_size_x_mm/2
bed_origin_y = bed_size_y_mm/2

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  output(';retract')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  output(';(</layer>)')
end

current_extruder = 0
current_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  output(';travel')
  output('G0 F' .. f(current_frate) .. ' X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. ff(z))
end

function move_xyze(x,y,z,e)
  extruder_e = e
  if z == current_z then 
    output('G1 F' .. current_frate .. ' X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. ff(z) .. ' E' .. ff((e-extruder_e_restart)))
  else
    output('G1 F' .. current_frate .. ' X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' E' .. ff((e-extruder_e_restart)))
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  output('G1 E' .. ff(e-extruder_e_restart))
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
  output('M104 S' .. temperature)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature)
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
