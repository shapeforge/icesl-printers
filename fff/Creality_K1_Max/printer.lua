-- Creality K1 Max based on Seckit Sk-G0 universal profile

-- Hugron Pierre-Alexandre 18/06/2020
-- Updated by Bedell Pierre 30/11/2022

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

craftware = true -- allow the use of Craftware paths naming convention

--##################################################

function comment(text)
  output('; ' .. text)
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function vol_to_mass(volume, density)
  return density * volume
end

function e_to_mm_cube(filament_diameter, e)
  local r = filament_diameter / 2
  return (math.pi * r^2 ) * e
end

-- get the E value (for G1 move) from a specified deposition move
function e_from_dep(dep_length, dep_width, dep_height, extruder)
  local r1 = dep_width / 2
  local r2 = filament_diameter_mm[extruder] / 2
  local extruded_vol = dep_length * math.pi * r1 * dep_height
  return extruded_vol / (math.pi * r2^2)
end

function jerk_to_junction_deviation(jerk, accel)
  return 0.4 * ( (jerk^2) / accel )
end

function scv_to_jerk(scv) -- scv = square corner velocity
  return math.sqrt(2) * scv
end

function jerk_to_scv(jerk) -- scv = square corner velocity
  return jerk/math.sqrt(2)
end

--##################################################

function set_limits(fw)
  if fw == 0 then -- Marlin
    output('M201 X' .. x_max_acc .. ' Y' .. y_max_acc .. ' Z' .. z_max_acc .. ' E' .. e_max_acc .. ' ; sets maximum accelerations, mm/sec^2')
    output('M203 X' .. x_max_speed .. ' Y' .. y_max_speed .. ' Z' .. z_max_speed .. ' E' .. e_max_speed .. ' ; sets maximum feedrates, mm/sec')
    output('M204 P' .. default_acc .. ' R' .. e_prime_max_acc .. ' T' .. default_acc .. ' ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2')
    output('M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec')
    if classic_jerk == true then
      output('M205 X' .. default_jerk .. ' Y' .. default_jerk .. ' ; sets XY Jerk')
    else
      output('M205 J' .. jerk_to_junction_deviation(default_jerk, default_acc) .. ' ; sets Junction Deviation')
    end
  elseif fw == 1 then -- RRF
    output('M201 X' .. x_max_acc .. ' Y' .. y_max_acc .. ' Z' .. z_max_acc .. ' E' .. e_max_acc .. ' ; sets maximum accelerations, mm/sec^2')
    output('M203 X' .. x_max_speed .. ' Y' .. y_max_speed .. ' Z' .. z_max_speed .. ' E' .. e_max_speed .. ' ; sets maximum feedrates, mm/sec')
    output('M204 P' .. default_acc .. ' R' .. e_prime_max_acc .. ' T' .. default_acc .. ' ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2')
    output('M205 X' .. default_jerk .. ' Y' .. default_jerk .. ' ; sets XY Jerk')
    --output('M566 X' .. default_jerk*60 .. ' Y' .. default_jerk*60 .. ' ; sets XY Jerk')
  elseif fw == 2 then -- Klipper
    output('; set velocity / acceleration limits')
    output('SET_VELOCITY_LIMIT VELOCITY=' .. (x_max_speed + y_max_speed)/2 .. ' ACCEL=' .. (x_max_acc + y_max_acc)/2 .. ' ACCEL_TO_DECEL=' .. ((x_max_acc + y_max_acc)/2)/2 .. ' SQUARE_CORNER_VELOCITY=' .. round(jerk_to_scv(default_jerk),2) )
  else
    output("; No suitable firmware configuration specified in features.lua.\n; Acceleration will be the machine's defaults.")
  end
end

function set_acceleration(fw, acc_value, jerk_value)
  if fw == 0 then -- Marlin
    output('M204 P' .. acc_value)
    if classic_jerk == true then
      output('M205 X' .. jerk_value .. ' Y' .. jerk_value)
    else
      output('M205 J' .. jerk_to_junction_deviation(jerk_value, acc_value))
    end
  elseif fw == 1 then -- RRF
    output('M204 P' .. acc_value)
    output('M205 X' .. jerk_value .. ' Y' .. jerk_value)
    --output('M566 X' .. jerk_value*60 .. ' Y' .. jerk_value*60)
  elseif fw == 2 then -- Klipper
    output('SET_VELOCITY_LIMIT ACCEL=' .. acc_value .. ' ACCEL_TO_DECEL=' .. acc_value .. ' SQUARE_CORNER_VELOCITY=' .. round(jerk_to_scv(jerk_value),2) )
  else
    output("; No suitable firmware configuration specified in features.lua.\n; Specific acceleration won't be used.")
  end
end

function set_linear_adv(fw)
  if fw == 0 then -- Marlin
    output('M900 K' .. filament_linear_adv_factor .. ' ; Linear/Pressure advance')
  elseif fw == 1 then -- RRF
    output('M572 D0 S' .. filament_linear_adv_factor .. ' ; Linear/Pressure advance')
  elseif fw == 2 then -- Klipper
    output('SET_PRESSURE_ADVANCE ADVANCE=' .. filament_linear_adv_factor .. ' ; Linear/Pressure advance')
  else
    output("; No suitable firmware configuration specified in features.lua.\n; Linear/Pressure advance setting won't be used.")
  end
end

function set_bed_level(fw)
  if fw == 0 then -- Marlin
    output('G29 ; auto bed leveling')
  elseif fw == 1 then -- RRF
    output('G29 S0; mesh bed leveling')
  elseif fw == 2 then -- Klipper
    output('BED_MESH_CALIBRATE ; mesh bed leveling')
  else
    output("; No suitable firmware configuration specified in features.lua.\n; Auto bed leveling won't be used.")
  end
end

function set_bed_mesh(fw)
  if fw == 0 then -- Marlin
    output('M420 S1 ; enable bed leveling (was disabled y G28)')
    output('M420 L ; load previous bed mesh')
  elseif fw == 1 then -- RRF
    output('G29 S1 P"heightmap.csv"; load default bed mesh')
  elseif fw == 2 then -- Klipper
    output('BED_MESH_PROFILE LOAD="default" ; load default bed mesh')
  else
    output("; No suitable firmware configuration specified in features.lua.\n; Bed mesh won't be used.")
  end
end

function header_additionnal_infos(fw)
  if fw == 0 then -- Marlin''
  elseif fw == 1 then -- RRF
  elseif fw == 2 then -- Klipper
    -- additionnal informations for Klipper web API (Moonraker)
    -- if feedback from Moonraker is implemented in the choosen web UI (Mainsail, Fluidd, Octoprint), this info will be used for gcode previewing
    output("")
    output("; Additionnal informations for Mooraker API")
    output("; Generated by <" .. slicer_name .. " " .. slicer_version .. ">")
    output("; print_height_mm :\t" .. f(extent_z))
    output("; layer_count :\t" .. f(extent_z/z_layer_height_mm))
    output("; filament_type : \t" .. name_en)
    output("; filament_name : \t" .. name_en)
    output("; filament_used_mm : \t" .. f(filament_tot_length_mm[0]) )
    -- caution! density is in g/cm3, convertion to g/mm3 needed!
    output("; filament_used_g : \t" .. f(vol_to_mass(e_to_mm_cube(filament_diameter_mm[0], filament_tot_length_mm[0]), filament_density/1000)) )
    output("; estimated_print_time_s : \t" .. time_sec)
    output("")
  else
  end
end

--##################################################

function header()
  output('G21 ; set units to millimeters')
  output('G90 ; use absolute coordinates')
  output('M82 ; extruder absolute mode\n')


  set_limits(firmware)

  if firmware == 2 then -- klipper
    output('START_PRINT EXTRUDER_TEMP=' .. extruder_temp_degree_c[extruders[0]] .. ' BED_TEMP=' .. bed_temp_degree_c)
  end
  output('')
  if firmware ~= 2 then -- not klipper
    output('M104 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; set extruder temp')
    output('M190 S' .. bed_temp_degree_c .. ' ; wait for bed temp')
    output('M107')
    output('G28 ; home all without mesh bed level')
  end

  

  if auto_bed_leveling == true and reload_bed_mesh == false then
    set_bed_level(firmware)
    output('G0 F' .. travel_speed_mm_per_sec * 60 .. 'X0 Y0 ; back to the origin to begin the purge')
  elseif reload_bed_mesh == true then
    set_bed_mesh(firmware)
  end

  output('M109 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; wait for extruder temp')

  output('')
  set_linear_adv(firmware)

  header_additionnal_infos(firmware)

  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  if firmware ~= 2 then -- not klipper
    output('')
    output('G4 ; wait')
    output('M104 S0 ; turn off temperature')
    output('M140 S0 ; turn off heatbed')
    output('M107 ; turn off fan')
    output('G28 X Y ; home X and Y axis')
    output('G91')
    output('G0 Z10') -- move in Z to clear space between print and nozzle
    output('G90')
    output('M84 ; disable motors')
    output('')
  else -- klipper
    output('END_PRINT')
  end

  -- restore default accel
  set_limits(firmware)
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
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
  output('; <layer ' .. layer_id .. '>')
  local frate = 100
  if layer_id == 0 then
    frate = 600
    if not layer_spiralized then
      output('G0 F' .. frate ..' Z' .. ff(zheight))
    end
  else
    if not layer_spiralized then
      output('G0 F' .. frate ..' Z' .. ff(zheight))
    end
  end
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  output('; </layer>')
end

function select_extruder(extruder)
  -- hack to work around not beeing a lua global
  local n = nozzle_diameter_mm_0 -- should be changed to nozzle_diameter_mm[extruder] when available

  local x_pos = 0.1
  local y_pos = 20
  local z_pos = 0.3

  local l1 = 200 -- length of 1st purge line
  local l2 = 200 -- length of 2nd purge line

  local w = n * 1.2 -- width of the purge line


  local e_value = 0.0

  if firmware ~= 2 then -- not klipper
    output('\n; purge extruder')
    output('G0 F6000 X' .. f(x_pos) .. ' Y' .. f(y_pos) ..' Z' .. f(z_pos))
    output('G92 E0')

    y_pos = y_pos + l1
    e_value = round(e_from_dep(l1, w, z_pos, extruder),2)
    output('G1 F1500 Y' .. f(y_pos) .. ' E' .. e_value .. '   ; draw 1st line') -- purge start

    x_pos = x_pos + n*0.75
    output('G1 F5000 X' .. f(x_pos) .. '   ; move a little to the side')

    y_pos = y_pos - l2
    e_value = e_value + round(e_from_dep(l2, w, z_pos, extruder),2)
    output('G1 F1000 Y' .. f(y_pos) .. ' E' .. e_value .. '  ; draw 2nd line') -- purge end
    output('G92 E0')
    output('; done purging extruder\n')
  end

  current_extruder = extruder
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    output(';travel')
    if use_per_path_accel then
      output('M204 S' .. default_acc)
    end
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
    if      path_is_perimeter then output(path_type[1][p_type])
    elseif  path_is_shell     then output(path_type[2][p_type])
    elseif  path_is_infill    then output(path_type[3][p_type])
    elseif  path_is_raft      then output(path_type[4][p_type])
    elseif  path_is_brim      then output(path_type[5][p_type])
    elseif  path_is_shield    then output(path_type[6][p_type])
    elseif  path_is_support   then output(path_type[7][p_type])
    elseif  path_is_tower     then output(path_type[8][p_type])
    end

    -- acceleration management
    if use_per_path_accel then
      if      path_is_perimeter then set_acceleration(firmware, perimeter_acc, default_jerk)
      elseif  path_is_shell     then set_acceleration(firmware, perimeter_acc, default_jerk)
      elseif  path_is_infill    then set_acceleration(firmware, infill_acc, infill_jerk)
      elseif  path_is_raft      then set_acceleration(firmware, default_acc, default_jerk)
      elseif  path_is_brim      then set_acceleration(firmware, default_acc, default_jerk)
      elseif  path_is_shield    then set_acceleration(firmware, default_acc, default_jerk)
      elseif  path_is_support   then set_acceleration(firmware, default_acc, default_jerk)
      elseif  path_is_tower     then set_acceleration(firmware, default_acc, default_jerk)
      end
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
