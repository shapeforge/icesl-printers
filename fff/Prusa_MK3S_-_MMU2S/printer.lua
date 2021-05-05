-- Original Prusa MK3S with MMU2S
-- 2019-05-01

current_extruder = 0
current_z = 0.0
current_frate = 0
changed_frate = false
processing = false
current_fan_speed = -1

extruder_e = {} -- table of extrusion values for each extruder
extruder_e_reset = {} -- table of extrusion values for each extruder for e reset (to comply with G92 E0)
extruder_e_swap = {} -- table of extrusion values for each extruder before to keep track of e at an extruder swap

for i = 0, extruder_count -1 do
  extruder_e[i] = 0.0
  extruder_e_reset[i] = 0.0
  extruder_e_swap[i] = 0.0
end

last_extruder_selected = 0 -- counter to track the selected / prepared extruders

skip_prime_retract = false

craftware_debug = true

--##################################################

function comment(text)
  output('; ' .. text)
end

function header()
  local h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  local f = file('footer.gcode')
  if flow_compensation == true then
    f = f:gsub('<FLOW>', 'M221 S100')
  else
    f = f:gsub('<FLOW>', '')
  end
  output(f)
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
    current_frate = speed
    changed_frate = true
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
    current_frate = speed
    changed_frate = true
    return e + len
  end
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
  extruder_e_reset[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  output('; </layer>')
end

function select_extruder(extruder) -- called at the start of the print job for each extruder that will be used to "initialize" them
  if last_extruder_selected == 0 then
    output('\n')
    output('; Send the filament type to the MMU2.0 unit.')
    output('; E stands for extruder number, F stands for filament type (0: default; 1:flex; 2: PVA)')
  end

  -- generate informations for the MMU2
  output('M403 E' .. extruder .. ' F' .. filament_type)

  last_extruder_selected = last_extruder_selected + 1
  skip_prime_retract = true

  -- generate the purge part of the "header" after selecting the last extruder 
  if last_extruder_selected == number_of_extruders then -- number_of_extruders is an IceSL internal Lua global variable which is used to know how many extruders will be used for a print job
    skip_prime_retract = false
    local p = file('purge.gcode')
    p = p:gsub('<FIRST_EXTRUDER>', extruder)
    if flow_compensation == true then -- flow compensation for small layer height
      if z_layer_height_mm < 0.075 then 
        p = p:gsub('<FLOW>', 'G221 S100')
      else
        p = p:gsub('<FLOW>', 'G221 S95')
      end
    else
      p = p:gsub('<FLOW>', '')
    end
    current_extruder = extruder
    output(p)
    current_frate = travel_speed_mm_per_sec * 60
    changed_frate = true
  end
end

function swap_extruder(from,to,x,y,z)
  output('\n; Filament change from E' .. from .. ' to E' .. to)

  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]
  current_extruder = to
  skip_prime_retract = true

  local s = file('swap.gcode')
  s = s:gsub('<NEW_TOOL_TEMP>', extruder_temp_degree_c[extruders[to]])
  s = s:gsub('<NEW_TOOL>', 'T' .. to)
  output(s)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function move_xyz(x,y,z)
  --output(';travel')
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
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
    end
    current_z = z
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
  end
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
end

function set_extruder_temperature(extruder,temperature)
  --output('M104 S' .. temperature .. ' T' .. extruder)
  output('M104 S' .. temperature)
end

function set_and_wait_extruder_temperature(extruder,temperature) -- /!\ is called implicitly after swap_extruder()
  --output('M109 S' .. temperature .. ' T' .. extruder)
  --output('M109 S' .. temperature)
end

function set_mixing_ratios(ratios)
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
