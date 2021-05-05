 -- Seckit Sk-Go

extruder_e = 0
extruder_e_restart = 0
current_z = 0.0

changed_frate = false
processing = false

current_extruder = 0
current_frate = 0

current_fan_speed = -1

path_type = {
--{ 'default',    'Craftware'}
  { ';perimeter',  ';segType:Perimeter' },
  { ';shell',      ';segType:HShell' },
  { ';infill',     ';segType:Infill' },
  { ';raft',       ';segType:Raft' },
  { ';brim',       ';segType:Skirt' },
  { ';shield',     ';segType:Pillar' },
  { ';support',    ';segType:Support' },
  { ';tower',      ';segType:Pillar'}
}

craftware_debug = true -- allow the use of Craftware paths naming convention

--##################################################

function comment(text)
  output('; ' .. text)
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function header()
  local acc_string = ''
  acc_string = acc_string .. 'M201 X' .. x_max_acc .. ' Y' .. y_max_acc .. ' Z' .. z_max_acc .. ' E' .. e_max_acc .. ' ; sets maximum accelerations, mm/sec^2\n'
  acc_string = acc_string .. 'M203 X' .. x_max_speed .. ' Y' .. y_max_speed .. ' Z' .. z_max_speed .. ' E' .. e_max_speed .. ' ; sets maximum feedrates, mm/sec\n'
  acc_string = acc_string .. 'M204 P' .. ex_max_acc .. ' R' .. e_prime_max_acc .. ' T' .. ex_max_acc .. ' ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2\n'
  acc_string = acc_string .. 'M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec'

  local h = file('header.gcode')
  h = h:gsub('<NOZZLE_DIAMETER>', round(nozzle_diameter_mm_0,2))
  h = h:gsub('<ACCELERATIONS>', acc_string)
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  h = h:gsub('<FILAMENT>', filament_linear_adv_factor)
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  current_frate = speed
  changed_frate = true
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  current_frate = speed
  changed_frate = true
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  local frate = 100
  if layer_id == 0 then
    frate = 600
    output('G0 F' .. frate ..' Z' .. ff(zheight))
  else
    output('G0 F' .. frate ..' Z' .. ff(zheight))
  end
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  output(';(</layer>)')
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    output(';travel')
    output('M204 S' .. default_acc)
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
  extruder_e = e

  local e_value = extruder_e - extruder_e_restart

  if processing == false then 
    processing = true
    local p_type = 1 -- default paths naming
    if craftware_debug then p_type = 2 end
    if      path_is_perimeter then output(path_type[1][p_type]) output('M204 S' .. perimeter_acc)
    elseif  path_is_shell     then output(path_type[2][p_type]) output('M204 S' .. perimeter_acc)
    elseif  path_is_infill    then output(path_type[3][p_type]) output('M204 S' .. infill_acc)
    elseif  path_is_raft      then output(path_type[4][p_type]) output('M204 S' .. default_acc)
    elseif  path_is_brim      then output(path_type[5][p_type]) output('M204 S' .. default_acc)
    elseif  path_is_shield    then output(path_type[6][p_type]) output('M204 S' .. default_acc)
    elseif  path_is_support   then output(path_type[7][p_type]) output('M204 S' .. default_acc)
    elseif  path_is_tower     then output(path_type[8][p_type]) output('M204 S' .. default_acc)
    end
  end

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

  local e_value =  extruder_e - extruder_e_restart

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
  output('M104 S' .. temperature)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature)
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
