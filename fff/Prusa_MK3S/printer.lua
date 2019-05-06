-- Original Prusa MK3S 
-- 2019-05-01

extruder_e = 0
extruder_e_restart = 0

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  if flow_compensation == true then
    if z_layer_height_mm < 0.075 then 
      h = h:gsub('<FLOW>', 'G221 S100')
    else
      h = h:gsub('<FLOW>', 'G221 S95')
    end
  else
    h = h:gsub('<FLOW>', '')
  end
  output(h)
end

function footer()
  f = file('footer.gcode')
  if flow_compensation == true then
    f = f:gsub('<FLOW>', 'M221 S100')
  else
    f = f:gsub('<FLOW>', '')
  end
  output(f)
end

function retract(extruder,e)
  output(';retract')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
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
  output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart)))
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G0 ' .. letter .. ff(e-extruder_e_restart))
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
  output('M104 S' .. temperature .. ' T' .. extruder)
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
