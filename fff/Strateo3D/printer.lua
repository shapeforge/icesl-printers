-- EmotionTech Strateo3D profile
-- Bedell Pierre 21/07/2020

current_extruder = 0
current_z = 0.0
current_frate = 0
changed_frate = false
current_fan_speed = -1

extruder_e = {} -- table of extrusion values for each extruder
extruder_e_reset = {} -- table of extrusion values for each extruder for e reset (to comply with G92 E0)
extruder_e_swap = {} -- table of extrusion values for each extruder before to keep track of e at an extruder swap
extruder_stored = {} -- table to store the state of the extruders after the purge procedure (to prevent additionnal retracts)

for i = 0, extruder_count -1 do
  extruder_e[i] = 0.0
  extruder_e_reset[i] = 0.0
  extruder_e_swap[i] = 0.0
  extruder_stored[i] = false
end

processing = false

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

craftware_debug = true

--##################################################

function comment(text)
  output('; ' .. text)
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function header()
  local tool_temp_string = ''

  if filament_tot_length_mm[0] > 0 then 
    tool_temp_string = tool_temp_string .. 'M104 T0 S' .. extruder_temp_degree_c[0] .. '\n'
    tool_temp_string = tool_temp_string .. 'M105\n'
    tool_temp_string = tool_temp_string .. 'M109 T0 S' .. extruder_temp_degree_c[0] .. '\n'
    tool_temp_string = tool_temp_string .. 'M105\n'
  end
  if filament_tot_length_mm[1] > 0 or (mirror_mode == true or duplication_mode == true) then 
    tool_temp_string = tool_temp_string .. 'M104 T1 S' .. extruder_temp_degree_c[1] .. '\n'
    tool_temp_string = tool_temp_string .. 'M105\n'
    tool_temp_string = tool_temp_string .. 'M109 T1 S' .. extruder_temp_degree_c[1] .. '\n'
    tool_temp_string = tool_temp_string .. 'M105\n'
  end

  local h = file('header.gcode')
  h = h:gsub('<TOOL_TEMP>', tool_temp_string)
  h = h:gsub('<BED_TEMP>', bed_temp_degree_c)
  h = h:gsub('<CHAMBER_TEMP>', chamber_temp_degree_c)
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  local f = file('footer.gcode')
  output(f)
end

function retract(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  local e_value = e - extruder_e_swap[current_extruder]
  if extruder_stored[extruder] then 
    comment('retract on extruder ' .. extruder .. ' skipped')
  else
    comment('retract')    
    output('G1 F' .. speed .. ' E' .. ff(e_value - extruder_e_reset[current_extruder] - len))
    extruder_e[current_extruder] = e_value - len
    current_frate = speed
    changed_frate = true
  end  
  return e - len
end

function prime(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  local e_value = e - extruder_e_swap[current_extruder]
  if extruder_stored[extruder] then 
    comment('prime on extruder ' .. extruder .. ' skipped')
  else
    comment('prime')    
    output('G1 F' .. speed .. ' E' .. ff(e_value - extruder_e_reset[current_extruder] + len))
    extruder_e[current_extruder] = e_value + len
    current_frate = speed
    changed_frate = true
  end  
  return e + len
end

function layer_start(zheight)
  output('; <layer ' .. layer_id .. '>')
  local frate = 100
  if layer_id == 0 then
    frate = 600
    output('G0 F' .. frate .. ' Z' .. f(zheight))
  else
    output('G0 F' .. frate ..' Z' .. f(zheight))
  end
  current_z = zheight
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  extruder_e_reset[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  output('; </layer>')
end

-- this is called once for each used extruder at startup
function select_extruder(extruder)
  local x_pos = 0
  local y_pos = 0.5 + (extruder*2)

  output('T' .. extruder)
  output('G0 F6000 X' .. x_pos .. ' Y' .. y_pos ..' Z0.3')
  output('G92 E0.0')
  x_pos = x_pos + 60.0
  output('G1 F1000 X' .. x_pos .. ' E9.0   ; purge line') -- purge line
  x_pos = x_pos + 40.0
  output('G1 F1000 X' .. x_pos .. ' E21.5  ; purge line') -- purge line
  output('G92 E0.0')

  current_extruder = extruder
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function swap_extruder(from,to,x,y,z)
  output('\n;swap_extruder')
  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]

  -- swap extruder
  output('G92 E0.0')
  output('T' .. to)
  output('G92 E0.0\n')

  current_extruder = to
  extruder_changed = true
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    output(';travel')
    output('M204 S' .. travel_acc .. '\nM205 X' .. travel_jerk .. ' Y' .. travel_jerk)
  end

  if z ~= current_z then
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
    end
    extruder_changed = false
    current_z = z
  else
    if changed_frate == true then 
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  end
end

function move_xyze(x,y,z,e)
  extruder_e[current_extruder] = e - extruder_e_swap[current_extruder]

  local e_value = extruder_e[current_extruder] - extruder_e_reset[current_extruder]

  if processing == false then 
    processing = true
    local p_type = 1 -- default paths naming
    if craftware_debug then p_type = 2 end
    if      path_is_perimeter then output(path_type[1][p_type]) output('M204 S' .. perimeter_acc .. '\nM205 X' .. perimeter_jerk .. ' Y' .. perimeter_jerk)
    elseif  path_is_shell     then output(path_type[2][p_type]) output('M204 S' .. perimeter_acc .. '\nM205 X' .. perimeter_jerk .. ' Y' .. perimeter_jerk)
    elseif  path_is_infill    then output(path_type[3][p_type]) output('M204 S' .. infill_acc .. '\nM205 X' .. infill_jerk .. ' Y' .. infill_jerk)
    elseif  path_is_raft      then output(path_type[4][p_type]) output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk)
    elseif  path_is_brim      then output(path_type[5][p_type]) output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk)
    elseif  path_is_shield    then output(path_type[6][p_type]) output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk)
    elseif  path_is_support   then output(path_type[7][p_type]) output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk)
    elseif  path_is_tower     then output(path_type[8][p_type]) output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk)
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
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' E' .. ff(e_value))
    end
    current_z = z
  end
end

function move_e(e)
  extruder_e[current_extruder] = e - extruder_e_swap[current_extruder]

  local e_value =  extruder_e[current_extruder] - extruder_e_reset[current_extruder]

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
  output('M104 T' .. extruder .. ' S' .. f(temperature))
  output('M105')
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
  output('M105')
end

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
