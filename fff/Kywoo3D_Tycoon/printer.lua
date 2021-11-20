-- Kywoo3d Tycoon

-- comment
function comment(text)
  output('; ' .. text)
end


-- move
function move_e(e)
  extruder_e = e
  output('G1 E' .. ff(e - extruder_e_restart))
end

function move_xyz(x,y,z)
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
end

function move_xyze(x,y,z,e)
  extruder_e = e
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' F' .. current_frate .. ' E' .. ff(e - extruder_e_restart))
end

-- filament
function set_feedrate(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

-- extruder
current_extruder = 0
current_frate = 0
function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

extruder_e = 0
extruder_e_restart = 0
function extruder_start()
end

function extruder_stop()
end

-- extruder temperature
function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

-- prime
function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

-- retract
function retract(extruder,e) 
  len   = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

-- fan
current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

-- header + footer
function footer()
  output(file('footer.gcode'))
end

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
end

-- layer
function layer_start(zheight)
  comment('<layer ' .. layer_id .. '>')
  output('G1 Z' .. f(zheight))
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer stop ' .. layer_id .. '>')
end

-- progress
function progress(percent)
end

-- wait
function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G0 F" .. travel_speed_mm_per_sec .. " X10 Y10")
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
  output("G0 F" .. travel_speed_mm_per_sec .. " X" .. f(x) .. " Y" .. f(y) .. " Z" .. ff(z))
end
