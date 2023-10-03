-- Common Prusa I3 with Diamond 5 filaments
-- Bedell Pierre 18/07/2019

processing = false

current_z = 0.0

current_frate = 0
changed_frate = false

current_extruder = 0

extruder_e = {} -- table of extrusion values for each extruder
extruder_e_reset = {} -- table of extrusion values for each extruder for e reset (to comply with G92 E0)
extruder_e_adjusted = {} -- table of adjusted extrusion values for each extruder for the filament_diameter_management feature
extruder_e_swap = {} -- table of extrusion values for each extruder before to keep track of e at an extruder swap

for i = 0, extruder_count -1 do
  extruder_e[i] = 0.0
  extruder_e_reset[i] = 0.0
  extruder_e_adjusted[i] = 0.0
  extruder_e_swap[i] = 0.0
end

skip_prime_retract = false
skip_ratios_change = false
last_extruder_selected = 0 -- counter to track the selected / prepared extruders

current_fan_speed = -1

current_A = 0.20
current_B = 0.20
current_C = 0.20
current_D = 0.20
current_H = 0.20

craftware_debug = true

--##################################################

function comment(text)
  output('; ' .. text)
end

function header()
  local auto_level_string = 'G29 ; auto bed levelling\nG0 F6200 X0 Y0 ; back to the origin to begin the purge '

  local h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )

  if auto_bed_leveling == true then
    h = h:gsub( '<BEDLVL>', auto_level_string )
  else
    h = h:gsub( '<BEDLVL>', "G0 F6200 X0 Y0" )
  end

  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  output(';<layer ' .. layer_id .. '>')
  if not layer_spiralized then
    output('G0 Z' .. f(zheight))
  end
end

function layer_stop()
  extruder_e_reset[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e)
  extruder_e[current_extruder] = e
  if skip_prime_retract then
    --comment('retract skipped')
    skip_prime_retract = false
    return e
  else
    comment('retract')
    local len    = filament_priming_mm[extruder] * nb_input
    local speed  = (retract_mm_per_sec[extruder] * nb_input) * 60;
    local e_value = e - len - extruder_e_reset[current_extruder]
    if filament_diameter_management == true then
      extruder_e_adjusted[current_extruder] = extruder_e_adjusted[current_extruder] - len
      e_value = extruder_e_adjusted[current_extruder] - extruder_e_reset[current_extruder]
    end
    output('G1 F' .. speed .. ' E' .. ff(e_value) .. ' A0.20 B0.20 C0.20 D0.20 H0.20')
    extruder_e[current_extruder] = e - len
    current_frate = speed
    changed_frate = true
    return e - len
  end
end

function prime(extruder,e)
  extruder_e[current_extruder] = e
  if skip_prime_retract then
    --comment('retract skipped')
    skip_prime_retract = false
    return e
  else
    comment('prime')
    local len   = filament_priming_mm[extruder] * nb_input
    local speed = (priming_mm_per_sec[extruder] * nb_input) * 60;
    local e_value = e + len - extruder_e_reset[current_extruder]
    if filament_diameter_management == true then
      extruder_e_adjusted[current_extruder] = extruder_e_adjusted[current_extruder] + len
      e_value = extruder_e_adjusted[current_extruder] - extruder_e_reset[current_extruder]
    end
    output('G1 F' .. speed .. ' E' .. ff(e_value) .. ' A0.20 B0.20 C0.20 D0.20 H0.20')
    extruder_e[current_extruder] = e + len
    current_frate = speed
    changed_frate = true
    return e + len
  end
end

function select_extruder(extruder)
  last_extruder_selected = last_extruder_selected + 1
  -- skip unnecessary prime/retract and ratios setup
  skip_prime_retract = true
  skip_ratios_change = true

  if last_extruder_selected == number_of_extruders then -- number_of_extruders is an IceSL internal Lua global variable which is used to know how many extruders will be used for a print job
    skip_prime_retract = false
    skip_ratios_change = false
    current_extruder = extruder
  end
end

function swap_extruder(from,to,x,y,z)
  output('; Extruder change from vE' .. from .. ' to vE' .. to)
  output('G92 E0')

  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]
  current_extruder = to
  skip_prime_retract = true
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    comment('travel')
  end
    if z == current_z then
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  local delta_e = e - extruder_e[current_extruder]
  extruder_e[current_extruder] = e

  local e_value = extruder_e[current_extruder] - extruder_e_reset[current_extruder]

  if path_is_raft then
    current_A = 0.20
    current_B = 0.20
    current_C = 0.20
    current_D = 0.20
    current_H = 0.20
  end

  if processing == false then
    processing = true
    if craftware_debug == true then
      if      path_is_perimeter then output(';segType:Perimeter')
      elseif  path_is_shell     then output(';segType:HShell')
      elseif  path_is_infill    then output(';segType:Infill')
      elseif  path_is_raft      then output(';segType:Raft')
      elseif  path_is_brim      then output(';segType:Skirt')
      elseif  path_is_shield    then output(';segType:Pillar')
      elseif  path_is_support   then output(';segType:Support')
      elseif  path_is_tower     then output(';segType:Pillar')
      end
    else
      if      path_is_perimeter then comment('perimeter')
      elseif  path_is_shell     then comment('shell')
      elseif  path_is_infill    then comment('infill')
      elseif  path_is_raft      then comment('raft')
      elseif  path_is_brim      then comment('brim')
      elseif  path_is_shield    then comment('shield')
      elseif  path_is_support   then comment('support')
      elseif  path_is_tower     then comment('tower')
      end
    end
  end

  local r_a = current_A
  local r_b = current_B
  local r_c = current_C
  local r_d = current_D
  local r_h = current_H

  -- adjust based on filament diameters
  if filament_diameter_management == true then
    r_a = current_A * (filament_diameter_mm_0 * filament_diameter_mm_0)
          / (filament_diameter_A * filament_diameter_A)
    r_b = current_B * (filament_diameter_mm_0 * filament_diameter_mm_0)
          / (filament_diameter_B * filament_diameter_B)
    r_c = current_C * (filament_diameter_mm_0 * filament_diameter_mm_0)
          / (filament_diameter_C * filament_diameter_C)
    r_d = current_D * (filament_diameter_mm_0 * filament_diameter_mm_0)
          / (filament_diameter_D * filament_diameter_D)
    r_h = current_H * (filament_diameter_mm_0 * filament_diameter_mm_0)
          / (filament_diameter_H * filament_diameter_H)
    local sum = (r_a + r_b + r_c + r_d + r_h)
    r_a = r_a / sum
    r_b = r_b / sum
    r_c = r_c / sum
    r_d = r_d / sum
    r_h = r_h / sum
    local delta_e_adjusted = delta_e * sum
    extruder_e_adjusted[current_extruder] = extruder_e_adjusted[current_extruder] + delta_e_adjusted

    e_value = extruder_e_adjusted[current_extruder] - extruder_e_reset[current_extruder]
  end
  -------------------------------------

  if z == current_z then
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value) .. ' A' .. f(r_a) .. ' B' .. f(r_b) .. ' C' .. f(r_c) .. ' D' .. f(r_d) .. ' H' .. f(r_h))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value) .. ' A' .. f(r_a) .. ' B' .. f(r_b) .. ' C' .. f(r_c) .. ' D' .. f(r_d) .. ' H' .. f(r_h))
    end
  else
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value) .. ' A' .. f(r_a) .. ' B' .. f(r_b) .. ' C' .. f(r_c) .. ' D' .. f(r_d) .. ' H' .. f(r_h))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value) .. ' A' .. f(r_a) .. ' B' .. f(r_b) .. ' C' .. f(r_c) .. ' D' .. f(r_d) .. ' H' .. f(r_h))
    end
    current_z = z
  end
end

function move_e(e)
  comment('dampener reset')
  local delta_e = e - extruder_e[current_extruder]
  extruder_e[current_extruder] = e

  local e_value = extruder_e[current_extruder] - extruder_e_reset[current_extruder]

  if filament_diameter_management == true then
    extruder_e_adjusted[current_extruder] = extruder_e_adjusted[current_extruder] + delta_e
    e_value = extruder_e_adjusted[current_extruder] - extruder_e_reset[current_extruder]
  end

  if changed_frate == true then
    output('G1 F' .. current_frate .. ' E' .. ff(e_value) .. ' A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C) .. ' D' .. f(current_D) .. ' H' .. f(current_H))
    changed_frate = false
  else
    output('G1 E' .. ff(e_value) .. ' A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C) .. ' D' .. f(current_D) .. ' H' .. f(current_H))
  end
end

function set_feedrate(feedrate)
  if feedrate ~= current_frate then
    current_frate =  math.floor(feedrate)
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

function set_mixing_ratios(ratios)
  if skip_ratios_change then
    skip_ratios_change = false
  else
    local sum = ratios[0] + ratios[1] + ratios[2] + ratios[3] + ratios[4]
    if sum == 0 then
      ratios[0] = 0.20
      ratios[1] = 0.20
      ratios[2] = 0.20
      ratios[3] = 0.20
      ratios[4] = 0.20
    end

    if ratios[0] ~= current_A or ratios[1] ~= current_B or ratios[2] ~= current_C or ratios[3] ~= current_D or ratios[4] ~= current_H then
      current_A = ratios[0]
      current_B = ratios[1]
      current_C = ratios[2]
      current_D = ratios[3]
      current_H = ratios[4]
      comment('Mixing Ratios set to A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C) .. ' D' .. f(current_D) .. ' H' .. f(current_H))
      output('G92 E0')
      extruder_e_reset[current_extruder] = extruder_e[current_extruder]
    end
  end
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
