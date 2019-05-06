-- Dagoma DiscoEasy200
-- Modified by Pierre Bedell, 2019-04-30

function comment(text)
  output('; ' .. text)
end

extruder_e = 0
extruder_e_restart = 0

current_extruder = 0
current_frate = 0
changed_frate = false

current_z = 0

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  output(';<layer ' .. layer_id .. '>')
  output('G1 F' .. f(current_frate) .. ' Z' .. f(zheight + z_offset))
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer ' .. layer_id .. '>')
end

function retract(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60;
  letter = 'E'
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)  
  if z == current_z then
    if changed_frate == true then 
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'

  if z == current_z then
    if changed_frate == true then 
      output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart)))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart)))
    end
  else
    if changed_frate == true then 
      output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' ' .. letter .. ff((e-extruder_e_restart)))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' ' .. letter .. ff((e-extruder_e_restart)))
    end
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_restart))
end

function set_feedrate(feedrate)
  current_frate = feedrate
  changed_frate = true
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. math.floor(temperature))
end

function set_fan_speed(speed)
  output('M106 S'.. math.floor(255 * speed/100))
end
