-- Generic reprap

version = 1

function comment(text)
  output('; ' .. text)
end

extruder_e = 0
extruder_e_restart = 0

current_A = 0.333
current_B = 0.333
current_C = 0.333
retract_e = 5
--retract_e = 2
retract_feed = 1200

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
  --extruder_e_restart = extruder_e
  --output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  letter = 'E'
  output('G1 F' .. speed .. ' E' .. f(e - len - extruder_e_restart) .. ' A1 B1 C1')
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  output('G1 F' .. speed .. ' E' .. f(e + len - extruder_e_restart) .. ' A1 B1 C1')
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
  if path_is_raft then
    current_A = 0.33
    current_B = 0.33
    current_C = 0.34
  end
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' F' .. current_frate .. ' ' .. letter .. f(e - extruder_e_restart) .. ' A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C))
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. f(e - extruder_e_restart))
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

function set_mixing_ratios(ratios)
  current_A = ratios[0]
  current_B = ratios[1]
  current_C = ratios[2]
end
