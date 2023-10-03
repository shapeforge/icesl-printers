-- Raise 3D E2 profile
-- Bedell Pierre 02/02/2021

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

purge_string = ''
n_selected_extruder = 0 -- counter to track the selected / prepared extruders

extruder_changed = false
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
  local flow = 100
  local flow_compensation_string = ''
  if enable_flow_management then
    if enable_flow_override then
      flow = flow_override
    else
      flow = material_flow
    end
  end

  local preheat_temp_string = ''
  local wait_temp_string =  ''
  local pressure_adv_string = ''
  if filament_tot_length_mm[0] > 0 then
    preheat_temp_string = preheat_temp_string .. 'M104 T0 S' .. extruder_temp_degree_c[0] .. '\n'
    wait_temp_string = wait_temp_string .. 'M109 T0 S' .. extruder_temp_degree_c[0] .. '\n'
    flow_compensation_string = flow_compensation_string .. 'M221 T0 S' .. flow .. '\n'
    pressure_adv_string = pressure_adv_string .. 'M572 D0 S' .. pressure_adv .. '\n'
  end
  if filament_tot_length_mm[1] > 0 then
    preheat_temp_string = preheat_temp_string .. 'M104 T1 S' .. extruder_temp_degree_c[1] .. '\n'
    wait_temp_string = wait_temp_string .. 'M109 T1 S' .. extruder_temp_degree_c[1] .. '\n'
    flow_compensation_string = flow_compensation_string .. 'M221 T1 S' .. flow .. '\n'
    pressure_adv_string = pressure_adv_string .. 'M572 D1 S' .. pressure_adv .. '\n'
  end

  output(';Generated with ' .. slicer_name .. ' ' .. slicer_version)

  if mirror_mode then
    output('M605 S2')
  elseif duplication_mode then
    output('M605 S1')
  end

  if enable_flow_management then
    output(flow_compensation_string)
  end

  output('M140 S' .. bed_temp_degree_c)
  output(preheat_temp_string)
  output(wait_temp_string)
  output('M190 S' .. bed_temp_degree_c)

  output(pressure_adv_string)

  output('G21')
  output('G90')
  output('M82')
  output('M107')
  output('G28')
  output('G1 Z15.0 F9000')
  output(purge_string)

  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output('\n')
  if filament_tot_length_mm[0] > 0 then
    output('M221 T0 S100')
    output('M104 T0 S0')
  end
  if filament_tot_length_mm[1] > 0 then
    output('M221 T1 S100')
    output('M104 T1 S0')
  end
  output('M140 S0')
  output('M107')
  output('G91')
  output('G1 E-1 F300')
  output('G1 Z+0.5 E-5 Y-20 F9000')
  output('G28 X0 Y0')
  output('M84')
  output('G90')
end

function retract(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
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
  if not layer_spiralized then
    if layer_id == 0 then
      frate = 600
      output('G0 F' .. frate .. ' Z' .. f(zheight))
    else
      output('G0 F' .. frate ..' Z' .. f(zheight))
    end
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
  n_selected_extruder = n_selected_extruder + 1

  local x_pos = 0
  local y_pos = -2
  local z_pos = 0.35
  if extruder == 0 then
    x_pos = 30
  elseif extruder == 1 then
    x_pos = 300
  end

  purge_string = purge_string .. '\nT' .. extruder
  purge_string = purge_string .. '\nG92 E0'
  purge_string = purge_string .. '\nG1 X' .. x_pos .. ' Y' .. y_pos .. ' F800'
  purge_string = purge_string .. '\nG1 Z' .. z_pos .. ' F200'
  purge_string = purge_string .. '\nG1 X' .. x_pos + 60 .. ' Y' .. y_pos .. ' E13 F200'
  purge_string = purge_string .. '\nG1 E15 F200'
  purge_string = purge_string .. '\nG1 Z5 F200'
  purge_string = purge_string .. '\nG92 E0'

  -- number_of_extruders is an IceSL internal Lua global variable
  -- which is used to know how many extruders will be used for a print job
  if n_selected_extruder == number_of_extruders then
    purge_string = purge_string .. '\n\nG1 F9000'
    purge_string = purge_string .. '\nM117 Printing...'
    purge_string = purge_string .. '\nM1001\n'
    extruder_stored[extruder] = false
  else
    purge_string = purge_string .. '\nG1 E-' .. extruder_swap_retract_length_mm .. ' F200' .. '\n'
    extruder_stored[extruder] = true
  end

  current_extruder = extruder
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function swap_extruder(from,to,x,y,z)
  output('\n;swap_extruder')
  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]

  -- swap extruder
  output('G92 E0')
  output('G1 F' .. extruder_swap_retract_speed_mm_per_sec * 60 .. ' E-' .. extruder_swap_retract_length_mm)
  output('T' .. to)
  output('G1 F' .. extruder_swap_retract_speed_mm_per_sec * 60 .. ' E0')

  extruder_stored[to] = false

  current_extruder = to
  extruder_changed = true
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    output(';travel')
    if use_acc_jerk_settings then
      output('M204 S' .. travel_acc .. '\nM205 X' .. travel_jerk .. ' Y' .. travel_jerk)
    end
  end

  if z ~= current_z or extruder_changed == true then
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
    if      path_is_perimeter then output(path_type[1][p_type]) if use_acc_jerk_settings then output('M204 S' .. perimeter_acc .. '\nM205 X' .. perimeter_jerk .. ' Y' .. perimeter_jerk) end
    elseif  path_is_shell     then output(path_type[2][p_type]) if use_acc_jerk_settings then output('M204 S' .. perimeter_acc .. '\nM205 X' .. perimeter_jerk .. ' Y' .. perimeter_jerk) end
    elseif  path_is_infill    then output(path_type[3][p_type]) if use_acc_jerk_settings then output('M204 S' .. infill_acc .. '\nM205 X' .. infill_jerk .. ' Y' .. infill_jerk) end
    elseif  path_is_raft      then output(path_type[4][p_type]) if use_acc_jerk_settings then output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk) end
    elseif  path_is_brim      then output(path_type[5][p_type]) if use_acc_jerk_settings then output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk) end
    elseif  path_is_shield    then output(path_type[6][p_type]) if use_acc_jerk_settings then output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk) end
    elseif  path_is_support   then output(path_type[7][p_type]) if use_acc_jerk_settings then output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk) end
    elseif  path_is_tower     then output(path_type[8][p_type]) if use_acc_jerk_settings then output('M204 S' .. default_acc .. '\nM205 X' .. default_jerk .. ' Y' .. default_jerk) end
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
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
end

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
end
