--Wanhao Duplicator i3
--13.11.2017 Colin Hudson

-- Changes made
-- Introduce rudimentary fan control based on previous layer size
-- Different Speeds for retraction and prime (priming_speed_pct) and extra_length_on_prime
-- Rudimentary debug system
-- Changes made to reduce gcode size; no speed information if speed is set already; no z value if the movement is at the current height
-- Change precision to ff (from f 3 digits precision) for all extruder moves
-- Make the layer change speed to be a fixed value

custom_fan_management = false -- activate Colin Hudson strategy
debug_level = 0 -- Higher number means more detailed debug in the gcode output
debug_match = nil --  A string for differing debug domains ( currentz, adj_fan_speed, feedrate)
currentz = 0 -- The current z height
extruder_e = 0
extruder_e_restart = 0
last_fspeed = -1
current_extruder = 0
current_frate = 0

function comment(text)
  output('; ' .. text)
end

function debug_lvl(lvl, variable_to_output)
  if lvl <= debug_level then
    comment('dbg!' .. variable_to_output)
  end
end

function debug_output(lvl, match, variable_to_output)
  if debug_match then
    if match == debug_match then
      debug_lvl(lvl, variable_to_output)
    end
  else
    debug_lvl(lvl, variable_to_output)
  end
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

function output_fan_speed(fspeed)
  if (fspeed ~= last_fspeed) then
    debug_output(2, 'adj_fan_speed', 'Setting fan')
    if fspeed == 0 then
      output('M107')
    else
      output('M106 S' .. fspeed)
    end
    last_fspeed = fspeed
  end
end

function adj_fan_speed(layer_filament_mm)
  -- Adjust the fan speed based on the amount of filament extruded on the previous layer
  local i = 1
  debug_output(1, 'adj_fan_speed', '>adj_fan_speed(layer_filament_mm =' .. layer_filament_mm .. ')')
  if fan_speed then
    while fan_speed[i] do
      if layer_filament_mm <= fan_speed[i][1] then
        output_fan_speed(fan_speed[i][2])
        break
      end
      i = i + 1
    end -- while
    if fan_speed[i] == nil then
      debug_output(2, 'adj_fan_speed', 'No match in table using default')
      if default_fan_speed then
        output_fan_speed(default_fan_speed)
      end
    end
  else
    if default_fan_speed then
      debug_output(2, 'adj_fan_speed', 'setting fan to default')
      output_fan_speed(default_fan_speed)
    end
    debug_output(2, 'adj_fan_speed', 'No fan setting')
  end
  debug_output(1, 'adj_fan_speed','<adj_fan_speed(layer_filament_mm =' .. layer_filament_mm .. ')')
end

function layer_start(z)
  if custom_fan_management then
    if layer_id == 1
    then
      last_fspeed = -1
      adj_fan_speed(first_layer_flag)
    end
  end
  comment('<layer>' .. layer_id)
  output('G1 Z' .. f(z) .. ' F3000')
  currentz = z
end

function layer_stop()
  if custom_fan_management then
    adj_fan_speed(extruder_e-extruder_e_restart)
  end
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e)
  debug_output(1, 'retraction', 'Retracting')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60 * priming_speed_pct/100
  debug_output(1, 'retraction', 'Priming')
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. ff(e + len - extruder_e_restart+extra_length_on_prime))
  extruder_e = e + len + extra_length_on_prime
  return e + len + extra_length_on_prime
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if (z == currentz) then
    output('G1 X' .. f(x) .. ' Y' .. f(y) )
  else
    debug_output(1, 'currentz', 'Move is not to current layer')
    output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
    currentz = z
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  --output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' F' .. current_frate .. ' ' .. letter .. ff(e - extruder_e_restart))
  if (z == currentz) then
    output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff(e - extruder_e_restart))
  else
    output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' ' .. letter .. ff(e - extruder_e_restart))
    debug_output(0, 'currentz', 'Move is not to current layer')
    currentz = z
  end
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_restart))
end

function set_feedrate(feedrate)
  if feedrate == current_frate then
    debug_output(2, 'feedrate', 'No output. Feedrate is already ' .. feedrate)
  else
    output('G1 F' .. feedrate)
    current_frate = feedrate
  end
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
  if not custom_fan_management then
    if speed ~= current_fan_speed then
      output('M106 S'.. math.floor(255 * speed/100))
      current_fan_speed = speed
    end
  end
end
