-- EmotionTech Micro Delta Rework
-- Pierre Bedell 05/06/2018

bed_origin_x = bed_size_x_mm/2
bed_origin_y = bed_size_y_mm/2

extruder_e = 0
extruder_e_restart = 0

changed_frate = false
current_frate = 0

current_z = 0.0

current_fan_speed = -1

--##################################################

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  comment('retract')
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  current_frate = speed
  changed_frate = true
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  comment('prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  current_frate = speed
  changed_frate = true
  extruder_e = e + len
  return e + len
end

function layer_start(zheight)
  comment('<layer ' .. layer_id .. '>')
  output('G0 F600 Z' .. ff(zheight))
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  if z == current_z then
    if changed_frate == true then 
      output('G0 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value))
      changed_frate = false
    else
      output('G0 X' .. f(x_value) .. ' Y' .. f(y_value))
    end
  else
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z))
      changed_frate = false
    else
      output('G0 X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  if z == current_z then
    if changed_frate == true then 
      output('G1 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x_value) .. ' Y' .. f(y_value) .. ' E' .. ff(e_value))
    end
  else
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
    end
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
  if changed_frate == true then 
    output('G1 F' .. current_frate .. ' E' .. ff(e_value))
    changed_frate = false
  else
    output('G1 E' .. ff(e_value))
  end
end

function set_feedrate(feedrate)
  if feedrate ~= current_frate then
    current_frate = feedrate
    changed_frate = true
  end
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
