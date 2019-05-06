-- Diamond3 profile for brushes
-- Use with caution, this is a highly experimental profile

----------------------------------------
-- Verbose: Put this value to true to 
-- monitor retractions, primes and path types
verbose    = true
----------------------------------------

current_e  = 0

extruder_e = {}
for i = 0, extruder_count - 1 do
  extruder_e[i] = 0.0
end

current_frate = 0

current_A  = 0.33
current_B  = 0.33
current_C  = 0.34

current_fan_speed = -1

retracted = false

in_tower = false
in_part = false

-- ########################################

function other_e(e)
  local sum = 0.0
  for i=0,extruder_count-1 do
    if i ~= e then
      sum = sum + extruder_e[i]
    end
  end
  return sum
end

-- ########################################

function comment(text)
  output('; ' .. text)
end

-- ########################################

function header()
  auto_level_string = 'G29 ; auto bed levelling\nG0 F6200 X0 Y0 ; back to the origin to begin the purge '
  
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )

  if auto_bed_leveling == true then
    h = h:gsub( '<BEDLVL>', auto_level_string )
  else
    h = h:gsub( '<BEDLVL>', "G0 F6200 X0 Y0" )
  end

  output(h)
end

-- ########################################

function footer()
  output(file('footer.gcode'))
end

-- ########################################

function layer_start(zheight)
  comment('<layer>')
  output('G1 Z' .. f(zheight))
end

-- ########################################

function layer_stop()
  comment('</layer>')
end

-- ########################################

function retract(extruder,e)
  if retracted then 
    return e 
  end
  letter = 'E'
  len   = filament_priming_mm[extruder] * nb_filament_in
  speed = (priming_mm_per_sec * nb_filament_in) * 60
  extruder_e[current_e] = e - len
  ----------------------------------------
  if verbose == true then
    comment('<retract from ' .. (e + other_e(current_e)) .. ' to ' .. (e - len + other_e(current_e)) .. '>')
  end
  ----------------------------------------
  output('G1 F' .. speed .. ' ' .. letter .. ff(e - len + other_e(current_e)) .. ' A0.33 B0.33 C0.34')
  retracted = true
  return e - len
end

-- ########################################

function prime(extruder,e)
  if not retracted then 
    return e 
  end
  letter = 'E'
  len   = filament_priming_mm[extruder] * nb_filament_in
  speed = (priming_mm_per_sec * nb_filament_in) * 60
  extruder_e[current_e] = e + len
  ----------------------------------------
  if verbose == true then
    comment('<prime from ' .. (e + other_e(current_e)) .. ' to ' .. (e + len + other_e(current_e)) .. '>')
  end
  ----------------------------------------
  output('G1 F' .. speed .. ' ' .. letter .. ff(e + len + other_e(current_e)) .. ' A0.33 B0.33 C0.34')
  retracted = false
  return e + len
end

-- ########################################

function select_extruder(extruder)
  current_e = extruder
  comment('</select ' .. extruder .. '>')
end

-- ########################################

function swap_extruder(from,to,x,y,z)
    current_e = to
    comment('</swap ' .. to .. '>')
end

-- ########################################

function move_xyz(x,y,z)
  output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
end

-- ########################################

function move_xyze(x,y,z,e)
  letter = 'E'
  if path_is_raft then
    current_A = 0.33
    current_B = 0.33
    current_C = 0.34
  end

  ----------------------------------------
  if verbose == true then 
    if path_is_perimeter == true or path_is_shell == true or path_is_infill == true then 
      if in_part == false then
        output(';Part')
      end
      in_part = true
      in_tower = false
    elseif path_is_tower == true then
      if in_tower == false then
        output(';Tower')
      end
      in_tower = true
      in_part = false
    end
  end
  ----------------------------------------
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' F' .. current_frate .. ' ' .. letter .. ff(e + other_e(current_e)) .. ' A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C))
end

-- ########################################

function move_e(e)
  letter = ' E'
  output('G1 ' .. letter .. ff(e + other_e(current_e)))
end

-- ########################################

function set_feedrate(feedrate)
  feedrate = math.floor(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

-- ########################################

function extruder_start()
end

-- ########################################

function extruder_stop()
end

-- ########################################

function progress(percent)
end

-- ########################################

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature)
end

-- ########################################

function set_mixing_ratios(ratios)
  sum = ratios[0] + ratios[1] + ratios[2]
  if sum == 0 then
    ratios[0] = 0.33
    ratios[1] = 0.33
    ratios[2] = 0.34
  end
  current_A = ratios[0]
  current_B = ratios[1]
  current_C = ratios[2]
end

-- ########################################

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

-- ########################################
