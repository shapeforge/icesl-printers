-- CreatBot F430 profile
-- Bedell Pierre 07/04/2020

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

skip_prime = false
skip_retract = false

craftware_debug = true
processing = false

initialized_extruders = 0 -- track the number of initilized extruders

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
    tool_temp_string = tool_temp_string .. 'T0\nM104 T0 S' .. extruder_temp_degree_c[0] .. ' ;extruder 0 temperature\nM109 T0 S' .. extruder_temp_degree_c[0] .. '\n'
  end
  if filament_tot_length_mm[1] > 0 then
    tool_temp_string = tool_temp_string .. 'T1\nM104 T1 S' .. extruder_temp_degree_c[1] .. ' ;extruder 1 temperature\nM109 T1 S' .. extruder_temp_degree_c[1] .. '\n'
  end

  output(tool_temp_string)
  --output('M140 S' .. bed_temp_degree_c .. ' ;bed temperature') -- set bed temperature
  output('M190 S' .. bed_temp_degree_c .. ' ;bed temperature') -- set & wait for bed temperature
  --output('M141 S' .. chamber_temp_degree_c .. ' ;chamber temperature') -- set chamber temperature
  output('M191 S' .. chamber_temp_degree_c .. ' ;chamber temperature\n') -- set & wait for chamber temperature

  output(file('header.gcode'))

  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  if skip_retract then 
    --comment('retract skipped')
    skip_retract = false
    return e
  else
    comment('retract')
    local len   = filament_priming_mm[extruder]
    local speed = priming_mm_per_sec[extruder] * 60
    local e_value = (e - extruder_e_swap[current_extruder] - extruder_e_reset[current_extruder]) - len
    output('G1 F' .. speed .. ' E' .. ff(e_value))
    extruder_e[extruder] = e - len
    current_frate = speed
    changed_frate = true
    return e - len
  end
end

function prime(extruder,e)
  if skip_prime then 
    --comment('prime skipped')
    skip_prime = false
    return e
  else
    comment('prime')
    local len   = filament_priming_mm[extruder]
    local speed = priming_mm_per_sec[extruder] * 60
    local e_value = (e - extruder_e_swap[current_extruder] - extruder_e_reset[current_extruder]) + len
    output('G1 F' .. speed .. ' E' .. ff(e_value))
    extruder_e[extruder] = e + len
    current_frate = speed
    changed_frate = true
    return e + len
  end
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
-- a retract is called after each extruder preparation
function select_extruder(extruder)
  local speed = travel_speed_mm_per_sec * 60

  local purge_pos = ""
  local park_pos = ""
  local purge_end_pos = 0

  initialized_extruders = initialized_extruders + 1

  if initialized_extruders == extruder_count then
    purge_pos = "X30 Y0"
    park_pos = "G0 Z5\nG0 X10 Y15"
    purge_end_pos = 10
  else
    purge_pos = "X10 Y10"
    park_pos = "G0 Z5\nG0 Y5"
    purge_end_pos = 30
  end

  output("\n;prepare extruder " .. extruder)
  output("G0 F" .. speed .. " X0 Y0")
  output("M83 ;relative E values")
  output("T" .. extruder .. " F400 ;activate extruder " .. extruder)
  output("G0 " .. purge_pos .." Z0.4 ;move to purge position")
  output("M221 T" .. extruder .. " S300 ;set flow to 300%")
  output("G1 F200 X" .. purge_end_pos .." E+8 ;extrude a purge line")
  output("M221 T" .. extruder .. " S100 ;set flow back to 100%")
  output(park_pos)
  output("M82 ;absolute E values")
  output("G92 E0 ;reset E values\n")

  current_extruder = extruder
  current_frate = speed
  changed_frate = true
end

-- a retract is called before a swap and a prime is called after
function swap_extruder(from,to,x,y,z)
  output('\n;swap_extruder from extruder ' .. from .. ' to extruder ' .. to)
  local len   = extruder_swap_retract_length_mm
  local speed = extruder_swap_retract_speed_mm_per_sec * 60;

  extruder_e_reset[from] = extruder_e[from]
  output("G92 E0")
  extruder_e_swap[from] = extruder_e_swap[from] + extruder_e[from] - extruder_e_reset[from]

  -- swap extruder
  output('T' .. to)

  current_extruder = to
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
    comment('travel')
  end

  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]

  if z ~= current_z then
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
    end
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

  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]

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
