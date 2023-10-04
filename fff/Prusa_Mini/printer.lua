-- Original Prusa Mini
-- 23/10/2020

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
  local flow  = 95
  if z_layer_height_mm < 0.075 then
   flow  = 100
  end
  
  output('; <THUMBNAIL_SMALL> (thumbnail management not yet supported, placeholder macro for later use)')
  output('; <THUMBNAIL_BIG> (thumbnail management not yet supported, placeholder macro for later use)')
  output('')

  --output('M73 P0 R0')
  --output('')

  output('M201 X' .. x_max_acc .. ' Y' .. y_max_acc .. ' Z' .. z_max_acc .. ' E' .. e_max_acc .. ' ; sets maximum accelerations, mm/sec^2')
  output('M203 X' .. x_max_speed .. ' Y' .. y_max_speed .. ' Z' .. z_max_speed .. ' E' .. e_max_speed .. ' ; sets maximum feedrates, mm/sec')
  output('M204 P' .. printing_max_acc .. ' R' .. prime_ret_max_acc .. ' T' .. travel_max_acc .. ' ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2')
  output('M205 X' .. x_max_jerk .. ' Y' .. y_max_jerk .. ' Z' .. z_max_jerk .. ' E' .. e_max_jerk .. ' ; sets the jerk limits, mm/sec')
  output('M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec')
  output('')

  output('M862.3 P "MINI" ; printer model check')
  output('M107')
  output('G90 ; use absolute coordinates')
  output('M83 ; extruder relative mode')
  output('')

  output('M104 S170 ; set extruder temp for bed leveling')
  output('M140 S' .. bed_temp_degree_c .. ' ; set bed temp')
  output('M109 R170 ; wait for bed leveling temp')
  output('M190 S' .. bed_temp_degree_c .. ' ; wait for bed temp')
  output('M204 T1250 ; set travel acceleration')
  output('G28 ; home all without mesh bed level')
  output('G29 ; mesh bed leveling ')
  output('M204 T2500 ; restore travel acceleration')
  output('M104 S' ..  extruder_temp_degree_c[extruders[0]] .. ' ; set extruder temp')
  output('G92 E0.0')
  output('G1 Y-2.0 X179 F2400')
  output('G1 Z3 F720')
  output('M109 S' ..  extruder_temp_degree_c[extruders[0]] .. ' ; wait for extruder temp')
  output('')

  output('; intro line')
  output('G1 X170 F1000')
  output('G1 Z0.2 F720')
  output('G1 X110.0 E8.0 F900')
  -- output('M73 P0 R0')
  output('G1 X40.0 E10.0 F700')
  output('G92 E0.0')
  output('')
  
  output('G21 ; set units to millimeters')
  output('G90 ; use absolute coordinates')
  output('M82 ; use absolute distances for extrusion')
  output('G92 E0.0')
  output('')
  
  output('M221 S' .. flow .. ' ; set flow')
  output('M900 K' .. filament_linear_adv_factor .. ' ; Linear Advance - Filament gcode')
  output('')
  
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output('')
  output('M83 ; extruder relative mode')
  output('G1 E-1 F2100 ; retract')
  output('G1 X178 Y178 F4200 ; park print head')
  output('G4 ; wait')
  output('M104 S0 ; turn off temperature')
  output('M140 S0 ; turn off heatbed')
  output('M107 ; turn off fan')
  output('M221 S100 ; reset flow')
  output('M900 K0 ; reset LA')
  output('M84 ; disable motors')
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  current_frate = speed
  changed_frate = true
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  current_frate = speed
  changed_frate = true
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  local frate = 100
  if not layer_spiralized then
    if layer_id == 0 then
      frate = 600
      output('G0 F' .. frate ..' Z' .. ff(zheight))
    else
      output('G0 F' .. frate ..' Z' .. ff(zheight))
    end
  end
  --remaining_time = time_sec - layer_start_time
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  extruder_e_restart = extruder_e
  --remaining_time = time_sec - layer_stop_time
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
  -- output('M73 P' .. percent .. ' R' .. remaining_time)
  output('M73 P' .. percent)
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
