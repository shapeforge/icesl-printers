-- Generic reprap

version = 2

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

function layer_start(zheight)
  comment('<layer>')
  if layer == 2 then
    output('M106 S204') -- fan ON
  end
  output('G1 Z' .. f(zheight))
  layer = layer + 1
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e) 
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. ff(e + len - extruder_e_restart))
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
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' F' .. current_frate .. ' ' .. letter .. ff(e - extruder_e_restart))
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_restart))
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
