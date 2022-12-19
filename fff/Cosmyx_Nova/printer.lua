-- Cosmyx Nova Profile
-- Bedell Pierre 13/12/2022

extruder_e = 0
extruder_e_restart = 0

current_extruder = 0
current_frate = 0

current_fan_speed = -1
processing = false

path_type = 1 -- 1:default, 2:Craftware, 3:Prusa/Super Slicer, 4:Cura

path_tag = {
  --{ 'default',  'Craftware',              'Prusa/Super Slicer',       'Cura'}
  { ';travel',    ';segType:Travel',        ';travel',                  ';travel' },
  { ';perimeter', ';segType:Perimeter',     ';TYPE:External perimeter', ';TYPE:WALL-OUTER' },
  { ';shell',     ';segType:HShell',        ';TYPE:Internal perimeter', ';TYPE:WALL-INNER' },
  { ';cover',     ';segType:Infill',        ';TYPE:Solid infill',       ';TYPE:FILL' },
  { ';infill',    ';segType:Infill',        ';TYPE:Internal infill',    ';TYPE:FILL' },
  { ';gapfill',   ';segType:Infill',        ';TYPE:Gap fill',           ';TYPE:FILL' },
  { ';bridge',    ';segType:SupportTouch',  ';TYPE:Overhang perimeter', ';TYPE:WALL-OUTER' },
  { ';support',   ';segType:Support',       ';TYPE:Support material',   ';TYPE:SUPPORT' },
  { ';brim',      ';segType:Skirt',         ';TYPE:Skirt',              ';TYPE:SKIRT' },
  { ';raft',      ';segType:Raft',          ';TYPE:Skirt',              ';TYPE:SKIRT' },
  { ';shield',    ';segType:Pillar',        ';TYPE:Skirt',              ';TYPE:SKIRT' },
  { ';tower',     ';segType:Pillar',        ';TYPE:Skirt',              ';TYPE:SKIRT' },
}

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

function tag_path()
  if     path_is_travel          then output(path_tag[1][path_type])
  elseif path_is_perimeter       then output(path_tag[2][path_type])
  elseif path_is_outer_perimeter then output(path_tag[2][path_type])
  elseif path_is_shell           then output(path_tag[3][path_type])
  elseif path_is_cover           then output(path_tag[4][path_type])
  elseif path_is_infill          then output(path_tag[5][path_type])
  elseif path_is_gapfill         then output(path_tag[6][path_type])
  elseif path_is_bridge          then output(path_tag[7][path_type])
  elseif path_is_support         then output(path_tag[8][path_type])
  elseif path_is_brim            then output(path_tag[9][path_type])
  elseif path_is_raft            then output(path_tag[10][path_type])
  elseif path_is_shield          then output(path_tag[11][path_type])
  elseif path_is_tower           then output(path_tag[12][path_type])
  end
end

--##################################################

function header()
  output('M104 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; set extruder temp')
  output('M140 S' .. bed_temp_degree_c .. ' ; set bed temp')
  output('M190 S' .. bed_temp_degree_c .. ' ; wait for bed temp')
  output('M109 S' .. extruder_temp_degree_c[extruders[0]] .. ' ; wait for extruder temp')

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
  
  output('; start of print')
  output("") 
end

function footer()
  output("") 
  output('; end of print')
  output("") 
  output('M83')
end

function layer_start(zheight)
  comment('<layer ' .. layer_id .. ' >')
  output('G1 F600 Z' .. ff(zheight))
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer ' .. layer_id .. ' >')
end

function retract(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G1 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

-- this is called once for each used extruder at startup
-- it is used here to generate purge with proper nozzle diameter
function select_extruder(extruder)
  local n = nozzle_diameter_mm_0

  -- purge position
  local x_pos = 299.0
  local y_pos = 160.0
  local z_pos = 0.3 -- used as deposition height

  local l1 = 10 -- length of the purge start
  local l2 = 40 -- length of the purge end

  local w1 = n * 1.5 -- width of the purge start
  local w2 = n * 3.0 -- width of the purge end
  
  local e_value = 0.0

  output('')
  output('; purging extruder')
  output('G1 Z5 F15000 ; lift')
  output('G1 X' .. f(xpos) .. ' Y' .. f(y_pos) .. ' F4500 ; move to prime')
  output('G1 Z' .. f(z_pos) .. ' F4500 ; get ready to prime')
  output('G92 E0 ; reset extrusion distance') -- useless as we are in relative gcode here !
  
  y_pos = y_pos - l1
  e_value = round(e_from_dep(l1, w1, z_pos, extruder),2)
  output('G1 Y' .. f(y_pos) .. ' E' .. f(e_value) .. ' F600 ; prime nozzle') -- purge start
  
  y_pos = y_pos + l2
  e_value = round(e_from_dep(l2, w2, z_pos, extruder),2)
  output('G1 Y' .. f(y_pos) .. ' E' .. f(e_value) .. ' F600 ; prime nozzle') -- purge start
  
  y_pos = y_pos - 30
  output('G1 Y' .. y_pos .. ' F5000 ; quick wipe')
  
  output('G92 E0')
  output('; done purging extruder\n')
  
  output('M82 ; switching to absolute extrusion')
  output('G92 E0 ; reset extrusion distance')
  output('')

  current_extruder = extruder
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function swap_extruder(from,to,x,y,z)
end

-- Uses only G1 !
function move_xyz(x,y,z)
  if processing == true then 
    tag_path() 
    processing = false
  end
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
end

function move_xyze(x,y,z,e)
  if processing == false then 
    tag_path() 
    processing = true
  end

  local e_value = e - extruder_e_restart
  extruder_e = e
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' F' .. current_frate .. ' E' .. ff(e_value))
end

function move_e(e)
  local e_value = e - extruder_e_restart
  extruder_e = e
  output('G1 E' .. ff(e_value))
end

function set_feedrate(feedrate)
  output('G1 F' .. f(feedrate))
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

-- The contents of this function is a placeholder
-- you can replace it by what you see fit to exented "layer time"
function wait(sec,x,y,z)
  local pos_x = 10 -- "parking" coordinates
  local pos_y = 10

  output("\n; Waiting for minimum layer time -- " .. f(sec) .. "s remaining")
  output("G1 F" .. travel_speed_mm_per_sec * 60 .. " X" .. pos_x .. " Y" .. pos_y .. " ; go to the parking position")
  -- G4 uses milliseconds on Klipper !
  output("G4 P" .. f(sec) * 1000 .. " ; wait for " .. f(sec) .. "s")
  output("G1 F" .. travel_speed_mm_per_sec * 60 .. " X" .. f(x) .." Y" .. f(y) .. " Z" .. ff(z) .. "; going back to  the previous location\n")
end  
