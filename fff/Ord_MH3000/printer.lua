-- ORD

current_extruder = 0
current_frate = 0
extruder_e = {}
extruder_e_restart = {}
extruder_e[0] = 0
extruder_e[1] = 0
extruder_e[2] = 0
extruder_e[3] = 0
extruder_e[4] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0
extruder_e_restart[2] = 0
extruder_e_restart[3] = 0
extruder_e_restart[4] = 0

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  -- warm bed
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  strextruders = ''
  -- warm all at once
  for _,t in pairs(extruders) do
    strextruders = strextruders .. 'M104 T' .. t .. ' S' .. extruder_temp_degree_c[t] .. '\n'
  end
  -- wait for temp
  for _,t in pairs(extruders) do
    strextruders = strextruders .. 'M109 T' .. t .. ' S' .. extruder_temp_degree_c[t] .. '\n'
  end
  h = h:gsub( '<TOOLTEMPS>', strextruders )
  output(h)
  -- prime each extruder
  for _,t in pairs(extruders) do
    output('T' .. t)
    output('G92 E0')
    output('G1 E20.0 F300.0')
  end
  output('G92 E0')
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

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e,pathtype)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function select_extruder(extruder)
comment('<selectextruder>')
output('T' .. extruder)
current_extruder = extruder
comment('</selectextruder>')
end

function swap_extruder(from,to,x,y,z)
comment('<swapextruder>')
extruder_e_restart[from] = extruder_e[from]
output('G92 E0')
output('T' .. to)
current_extruder = to
comment('</swapextruder>')
end

function move_xyz(x,y,z)
  output('G1 X' .. f(x+offset_x) .. ' Y' .. f(y+offset_y) .. ' Z' .. f(z+z_offset))
end

function move_xyze(x,y,z,e)
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G1 X' .. f(x+offset_x) .. ' Y' .. f(y+offset_y) .. ' Z' .. f(z+z_offset) .. ' F' .. f(current_frate) .. ' ' .. letter .. ff(e-extruder_e_restart[current_extruder]))
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
