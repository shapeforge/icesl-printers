-- Voron V0 Profile
-- Hugron Pierre-Alexandre 29/06/2021

extruder_e = 0
extruder_e_restart = 0

current_extruder = 0
current_frate = 0

current_fan_speed = -1

--##################################################

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
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
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
end

function move_xyze(x,y,z,e)
  local e_value = e - extruder_e_restart
  extruder_e = e
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' F' .. current_frate .. ' E' .. ff(e_value))
end

function move_e(e)
  local e_value = e - extruder_e_restart
  extruder_e = e
  output('G1 E' .. ff(e_value))
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
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

function wait(sec,x,y,z)
  output(";WAIT -- " .. sec .. "s remaining") --print ou the remainign time
  output("G0 F6200 X10 Y10") --go to a "parking" location
  output("G4 S" .. sec .. "; wait for " .. sec .. "s") --wait for the remaining time
  output("G0 F6200 X" .. f(x) .."Y" .. f(y) .. "Z" .. ff(z)) --go back to the previous location
end  
