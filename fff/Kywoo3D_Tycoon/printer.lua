-- Kywoo3d Tycoon

-- comment
function comment(text)
  output('; ' .. text)
end


-- extruder
current_extruder = 0
current_frate = 0
extruder_e = 0
extruder_e_restart = 0

-- filament
function set_feedrate(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

-- extruder temperature
function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end
function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

-- extruder prime
function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

-- extruder retract
function retract(extruder,e) 
  len   = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

-- extruder switch
function select_extruder(extruder)
end
function swap_extruder(from,to,x,y,z)
end
function extruder_start()
end
function extruder_stop()
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
  f = file('footer.gcode')
  f = f:gsub( '<MAX_SPEED>', max_speed )
  output(f)
end
function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  h = h:gsub( '<MAX_SPEED>', max_speed )
  output(h)
end

-- layer
function elephant_foot_adjust(zheight)
  if zheight < elephant_foot_z_height then
    bed_current_temp_degree_c = math.floor(bed_temp_degree_c * (100 - elephant_foot_temp_percent * (zheight / elephant_foot_z_height))/ 100)
  else
    bed_current_temp_degree_c = math.floor(bed_temp_degree_c * (100 - elephant_foot_temp_percent) / 100)
  end
  output('M140 S' .. bed_current_temp_degree_c)
end
function layer_start(zheight)
  comment('<layer ' .. layer_id .. '>')
  elephant_foot_adjust(zheight)
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
