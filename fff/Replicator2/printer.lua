-- Replicator 2 Makerbot

bed_origin_x = bed_size_x_mm / 2.0
bed_origin_y = bed_size_y_mm / 2.0

function comment(text)
  output('(' .. text .. ')')
end

function header()
  if number_of_extruders > 1 then
    error('The Replicator 2 has a single extruder!')
  end
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer>')
  output('G1 Z' .. f(zheight))
end

function layer_stop()
  comment('</layer>')
end

current_extruder = 0
current_frate = 0

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60;
  if extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len))
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  if extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len))
  return e + len
end

function select_extruder(extruder)
  current_extruder = extruder
  output('M135 T' .. extruder)
end

function swap_extruder(from,to,x,y,z)
 -- ERROR
 error('The Replicator 2 has a single extruder!')
end

function move_xyz(x,y,z)
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z))
end

function move_xyze(x,y,z,e)
  letter = 'A'
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z) .. ' F' .. current_frate .. ' ' .. letter .. ff(e))
end

function move_e(e)
  letter = 'A'
  output('G1 ' .. letter .. ff(e))
end

function set_feedrate(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
  output('M73 P' .. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
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
