-- Dagoma NEVA

bed_origin_x = bed_size_x_mm/2
bed_origin_y = bed_size_y_mm/2

function comment(text)
  output('; ' .. text)
end

extruder_e = 0
extruder_e_restart = 0

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

layer = 0
fan_step = 0

function layer_start(zheight)
  comment('<layer>')
  output('G1 Z' .. f(zheight))
  layer = layer + 1
  if zheight > 2.0 and fan_step == 0 then
    fan_step = 1
    output('M106 S110')
  end
  if zheight > 10.0 and fan_step == 1 then
    fan_step = 2
    output('M106 S196')
  end
  if zheight > 20.0 and fan_step == 2 then
    fan_step = 3
    output('M106 S255')
  end
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e) 
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

current_extruder = 0
current_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z+z_offset))
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z+z_offset) .. ' F' .. f(current_frate) .. ' ' .. letter .. ff(e - extruder_e_restart))
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_restart))
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

function set_fan_speed(speed)
  output('M106 S'.. math.floor(255 * speed/100))
end