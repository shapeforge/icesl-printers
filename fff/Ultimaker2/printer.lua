-- Ultimaker 2
-- Sylvain Lefebvre  2014-03-08

current_extruder = 0
extruder_e = 0
extruder_e_reset = 0
reset_e_on_next_prime = false

current_z = 0
current_frate = 0
changed_frate = false

current_fan_speed = 0

function comment(text)
  output('; ' .. text)
end

function to_mm_cube(e)
  local r = filament_diameter_mm[extruders[0]] / 2
  return math.pi * r * r * e
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function prep_extruder(extruder)
  output(';prep_extruder')
  -- go slightly above plate
  output('G0 F1000 X15 Y5 Z0.0')
  output('G92 E0')
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function header()
  output(';FLAVOR:UltiGCode')
  output(';TIME:' .. time_sec)
  output(';MATERIAL:' .. to_mm_cube( filament_tot_length_mm[extruders[0]]) )
  output(';MATERIAL2:0')
  output(';NOZZLE_DIAMETER:' .. round(nozzle_diameter_mm_0,2))
  --output('M207 F' .. retract_mm_per_sec * 60 .. ' S' .. filament_priming_mm_0)
  --output('M208 F' .. priming_mm_per_sec * 60 .. ' S' .. filament_priming_mm_0)
  output('M82')
  output('G92 E0')
  output('M107')
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output('G10')
  output('M107')
end

function retract(extruder,e)
  extruder_e = e
  output('G10')
  return e
end

function prime(extruder,e)
  extruder_e = e
  output('G11')
  if reset_e_on_next_prime == true then
    output('G92 E0')
    extruder_e_reset = extruder_e
    reset_e_on_next_prime = false
  end
  return e
end

function layer_start(zheight)
  output('; <layer ' .. layer_id .. '>')
  local frate = 600
  if not layer_spiralized then
    if layer_id == 0 then
      output('G0 F' .. frate .. ' Z' .. ff(zheight))
    else
      frate = 100
      output('G0 F' .. frate .. ' Z' .. ff(zheight))
    end
  end
  current_z = zheight
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  reset_e_on_next_prime = true
  output('; </layer ' .. layer_id .. '>')
end

function select_extruder(extruder)
  prep_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  output('; move_xyz')
  if z == current_z then
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  output('; move_xyze')
  extruder_e = e
  local e_value = to_mm_cube(e - extruder_e_reset)
  if z == current_z then
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value))
    end
  else
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
    end
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  local e_value = to_mm_cube(e - extruder_e_reset)
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
  output('M104 S' .. f(temperature) .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
   output('M109 S' .. f(temperature) .. ' T' .. extruder)
end

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G0 F" .. travel_speed_mm_per_sec .. " X10 Y10")
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
  output("G0 F" .. travel_speed_mm_per_sec .. " X" .. f(x) .. " Y" .. f(y) .. " Z" .. ff(z))
end
