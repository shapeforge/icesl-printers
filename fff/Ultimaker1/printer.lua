-- Ultimaker 1

function comment(text)
  output('; ' .. text)
end

current_extruder = 0
extruder_e = {}
extruder_e_restart = {}
extruder_e[0] = 0
extruder_e[1] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0

function header()
  h = file('header_' .. number_of_extruders .. '.gcode')
  h = h:gsub( '<TOOL>', extruders[0] )
  h = h:gsub( '<T0TEMP>', extruder_temp_degree_c[extruders[0]] )
  if extruders[1] then
	h = h:gsub( '<T1TEMP>', extruder_temp_degree_c[extruders[1]] )
  end
  output(h)
end

function footer()
output('M104 S0                     ;extruder heater off ')
output('M140 S0                     ;heated bed heater off (if you have it) ')
output('G91                                    ;relative positioning ')
output('G1 E-1 F300                            ;retract the filament a bit before lifting the nozzle, to release some of the pressure ')
output('G1 Z+0.5 E-5 X-20 Y-20 F9000 ;move Z up a bit and retract filament even more ')
output('G28 X0 Y0                              ;move X/Y to min endstops, so the head is out of the way ')
output('M84                         ;steppers off ')
output('G90                         ;absolute positioning ')
end

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60;
  output(';<retract>')
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  output(';<prime>')
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function layer_start(zheight)
  comment('<layer>')
  output('G1 Z' .. f(zheight))
end

function layer_stop()
  comment('</layer>')
end

current_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
  comment('<swapextruder>')
  output('G92 E0')
  extruder_e_restart[from] = extruder_e[from]
  output('T' .. to)
  comment('</swapextruder>')
  current_extruder = to
end

function move_xyz(x,y,z)
  if(current_extruder == 1) then
	x = x + 2*offset_x
	y = y - 2*offset_y
  end
  output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
end

function move_xyze(x,y,z,e)
  if(current_extruder == 1) then
  	x = x + 2*offset_x
	  y = y - 2*offset_y
  end
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' F' .. f(current_frate) .. ' ' .. letter .. ff(e-extruder_e_restart[current_extruder]))
end

function move_e(e)
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e-extruder_e_restart[current_extruder]))
end

function set_feedrate(feedrate)
  output('G1 F' .. f(feedrate))
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
