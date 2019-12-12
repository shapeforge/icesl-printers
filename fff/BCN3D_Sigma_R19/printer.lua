-- BCN3D Sigma R19 profile
-- Bedell Pierre 30/10/2019

current_extruder = 0
current_z = 0.0
current_frate = 0
changed_frate = false
traveling = false
current_fan_speed = -1

extruder_e = {} -- table of extrusion values for each extruder
extruder_e_reset = {} -- table of extrusion values for each extruder for e reset (to comply with G92 E0)
extruder_e_swap = {} -- table of extrusion values for each extruder before to keep track of e at an extruder swap

for i = 0, extruder_count -1 do
  extruder_e[i] = 0.0
  extruder_e_reset[i] = 0.0
  extruder_e_swap[i] = 0.0
end

purge_string = ''

skip_prime_retract = false
extruder_changed = false

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
  local filament_total_length = 0
  local extruders_info_string = ''
  local tool_temp_string = ''
  -- Fetching print job informations
  if filament_tot_length_mm[0] > 0 then 
    filament_total_length = filament_total_length + filament_tot_length_mm[0]
    extruders_info_string = extruders_info_string .. ' T0 ' .. round(nozzle_diameter_mm_0,2)
    tool_temp_string = tool_temp_string .. 'T0\nM104 T0 S' .. extruder_temp_degree_c[0] .. '\nM109 T0 S' .. extruder_temp_degree_c[0] .. ' ;Fixed T0 temperature\n'
  end
  if filament_tot_length_mm[1] > 0 then 
    filament_total_length = filament_total_length + filament_tot_length_mm[1]
    extruders_info_string = extruders_info_string .. ' T1 ' .. round(nozzle_diameter_mm_1,2)
    tool_temp_string = tool_temp_string .. 'T1\nM104 T1 S' .. extruder_temp_degree_c[1] .. '\nM109 T1 S' .. extruder_temp_degree_c[1] .. ' ;Fixed T1 temperature\n'
  end

  output(';FLAVOR:Marlin')
  output(';TIME:' .. time_sec)
  output(';Filament used: ' .. round(filament_total_length / 1000, 5) .. 'm')
  output(';Layer height: ' .. round(z_layer_height_mm,2))
  output(';Extruders used:' .. extruders_info_string)
  output(';Generated with ' .. slicer_name .. ' ' .. slicer_version)

  output('M190 S' .. bed_temp_degree_c .. ' ;bed temperature')
  output(tool_temp_string)

  local h = file('header.gcode')
  if mirror_mode == true then
    h = h:gsub('<PRINT_MODE>', 'M605 S6      ;enable mirror mode\n')
  elseif duplication_mode == true then
    h = h:gsub('<PRINT_MODE>', 'M605 S5      ;enable duplication mode\n')
  else
    h = h:gsub('<PRINT_MODE>', '')
  end
  h = h:gsub('<BUCKET_PURGE>', purge_string)
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  extruder_e[current_extruder] = e
  if skip_prime_retract then 
    --comment('retract skipped')
    skip_prime_retract = false
    return e
  else
    comment('retract')
    local len   = filament_priming_mm[extruder]
    local speed = priming_mm_per_sec[extruder] * 60
    extruder_e[current_extruder] = e - extruder_e_swap[current_extruder]
    output('G1 F' .. speed .. ' E' .. ff(extruder_e[current_extruder] - extruder_e_reset[current_extruder] - len))
    return e - len
  end
end

function prime(extruder,e)
  if skip_prime_retract then 
    --comment('prime skipped')
    skip_prime_retract = false
    return e
  else
    comment('prime')
    local len   = filament_priming_mm[extruder]
    local speed = priming_mm_per_sec[extruder] * 60
    extruder_e[current_extruder] = e - extruder_e_swap[current_extruder]
    output('G1 F' .. speed .. ' E' .. ff(extruder_e[current_extruder] - extruder_e_reset[current_extruder] + len))
    return e + len
  end
end

function layer_start(zheight)
  output('; <layer ' .. layer_id .. '>')
  if layer_id == 0 then
    output('G0 F600 Z' .. f(zheight))
  else
    output('G0 F100 Z' .. f(zheight))
  end
  current_z = zheight
end

function layer_stop()
  extruder_e_reset[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  output('; </layer>')
end

-- this is called once for each used extruder at startup
function select_extruder(extruder)
  skip_prime_retract = true

  extruder_side = ''
  if extruder == 0 then 
    extruder_side = 'left'
  elseif extruder == 1 then 
    extruder_side = 'right'
  end

  purge_string = purge_string .. "\nT" .. extruder .. "           ;switch to the " .. extruder_side ..  " extruder"
  purge_string = purge_string .. "\nG92 E0       ;zero the extruded length"
  purge_string = purge_string .. "\nG1 F47.4 E15 ;extrude 15mm of feed stock"
  purge_string = purge_string .. "\nG92 E0  "
  purge_string = purge_string .. "\nG4 P2000     ;stabilize hotend's pressure\n"

  current_extruder = extruder
end

function swap_extruder(from,to,x,y,z)
  output('\n;swap_extruder')
  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]

  -- swap extruder
  output('T' .. to)
  -- temp ?
  output('G92 E0')
  output('G91')
  output('G1 F12000 Z' .. f(extruder_swap_zlift_mm) .. ' ;z_lift')
  output('G90')
  output('G92 E0')
  output('G1 F600 E6.5')
  output('G92 E0')
  if smart_purge == true then
    output('M800 F47.4 S0.0002 E20.0 P0.0 ;smartpurge')
  else
    output('G1 F47.4 E2.5 ;defaultpurge')
  end
  output('G92 E0')
  output('G1 F2400 E-6.5')
  output('G92 E0')
  output('G4 P2000\n')

  current_extruder = to
  extruder_changed = true
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    comment('travel')
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
  else
    changed_frate = false
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
