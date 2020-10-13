-- Creality CR10S pro
-- 30/07/2020

extruder_e = 0
extruder_e_restart = 0
current_z = 0.0

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

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  local frate = 600
  comment('<layer ' .. layer_id ..'>')
  output('G1 F' .. frate .. ' Z' .. f(zheight))
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('<layer ' .. layer_id ..'>')
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  current_frate = speed
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  current_frate = speed
  return e + len
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if processing == true then
    processing = false
  end
  output(';travel')
  output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
  current_z = z
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
  end

  output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
  current_z = z
end

function move_e(e)
  extruder_e = e
  local e_value =  extruder_e - extruder_e_restart
  output('G1 F' .. current_frate .. ' E' .. ff(e_value))
end

function set_feedrate(feedrate)
  current_frate = feedrate
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
