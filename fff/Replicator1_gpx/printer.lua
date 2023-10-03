-- Replicator Dual GPX

bed_origin_x = bed_size_x_mm / 2.0
bed_origin_y = bed_size_y_mm / 2.0

function comment(text)
  output('(' .. text .. ')')
end

function header()
  h = file('header_' .. number_of_extruders .. '.gcode')
  if number_of_extruders == 1 then
    h = h:gsub( '<TOOL>', extruders[0] )
    h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  else
    h = h:gsub( '<T0TEMP>', extruder_temp_degree_c[0] )
	h = h:gsub( '<T1TEMP>', extruder_temp_degree_c[1] )
  end
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer>')
  if not layer_spiralized then
    output('G0 Z' .. f(zheight))
  end
end

function layer_stop()
  comment('</layer>')
end

current_extruder = 0
current_frate = 0

function select_extruder(extruder)
  current_extruder = extruder
end

function swap_extruder(from,to,x,y,z)
  current_extruder = to
end

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
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

function move_xyz(x,y,z)
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  output('G0 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z))
end

function move_xyze(x,y,z,e)
  if current_extruder == 0 then letter = 'A' else letter = 'B' end
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z) .. ' F' .. f(current_frate) .. ' ' .. letter .. ff(e))
end

function move_e(e)
  if current_extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 ' .. letter .. ff(e))
end

function set_feedrate(feedrate)
  output('G1 F' .. f(feedrate))
  current_frate = feedrate
end

function extruder_start()
  output('M101')
end

function extruder_stop()
  output('M103')
end

function progress(percent)
  output('M73 P' .. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
  output('M133 ' .. 'T' .. extruder)
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
