-- Flsun SR Profile
-- Hardy Damien 14/01/2022
-- Based on Wasp 2040 Pro Profile

bed_origin_x = bed_size_x_mm/2
bed_origin_y = bed_size_y_mm/2

extruder_e = 0
extruder_e_restart = 0

current_z = 0.0
current_frate = 0
current_fan_speed = -1

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  current_frate = speed
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  current_frate = speed
  extruder_e = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
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
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  output(';travel')
  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x_value) .. ' Y' .. f(y_value))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  local _print_type = ''
  if gcode_verbose then
    --###############################################
    -- DH for verbose g-code
    -- https://gitlab.inria.fr/mfx/icesl-documentation/-/wikis/Printer-profile
    --###############################################    
    if  path_is_outer_perimeter	                then _print_type = ' ; perimeter_outer'
    elseif  path_is_perimeter and path_is_shell then _print_type = ' ; perimeter_inner'
    elseif  path_is_perimeter 	  		          then _print_type = ' ; perimeter_outer_less_visible'
    elseif  path_is_cover and path_is_shell    	then _print_type = ' ; cover_shell'
    elseif  path_is_shell     	  		          then _print_type = ' ; shell' -- INNER WALL CURA?
    elseif  path_is_raft      	  		          then _print_type = ' ; raft'
    elseif  path_is_brim      	  		          then _print_type = ' ; brim'
    elseif  path_is_shield    	  		          then _print_type = ' ; shield'
    elseif  path_is_support   	  		          then _print_type = ' ; support'
    elseif  path_is_tower     	  		          then _print_type = ' ; tower'
    elseif  path_is_bridge    	  		          then _print_type = ' ; bridge'
    elseif  path_is_cover and path_is_infill    then _print_type = ' ; cover_infill'
    elseif  path_is_cover     	  		          then _print_type = ' ; cover'
    elseif  path_is_tower     	  		          then _print_type = ' ; tower'
    elseif  path_is_infill    	  		          then _print_type = ' ; infill'
    else    _print_type = ' ; unknown print type' end
  end

  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  if z == current_z then 
    output('G1 F' .. f(current_frate) .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' Z' .. ff(z) .. ' E' .. ff(e_value) .. _print_type)
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' E' .. ff(e_value) .. _print_type)
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
  output('G1 F' .. f(current_frate) .. 'E' .. ff(e_value))
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

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
end
