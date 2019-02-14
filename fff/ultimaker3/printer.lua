-- Ultimaker 3
-- Sylvain Lefebvre  2017-07-28

version = 2

function comment(text)
  output('; ' .. text)
end

current_z = 0
current_extruder = -1

extruder_e = {}
extruder_e_restart = {}

extruder_e[0] = 0
extruder_e[1] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0

traveling = 0

extruder_stored = {}
extruder_stored[0] = false
extruder_stored[1] = false

function prep_extruder(extruder)
  output(';prep_extruder')
  -- go slightly above plate
  output('G0 Z' .. 3.0)
  -- heat up nozzle
  output('M109 T' .. extruder .. ' S' .. extruder_temp_degree_c[extruder])
  if extruder == 0 then
    output('G0 F15000 X9 Y6')
  else
    output('G0 F15000 X204 Y6')
  end
  -- first time prime
  output('G280')
  -- go to zero to wipe on bed
  output('G0 Z' .. 0.0)
  -- prime done, reset E
  output('G92 E0')
end

function header()
  r0 = filament_diameter_mm[0] / 2
  to_mm_cube_0 = 3.14159 * r0 * r0
  r1 = filament_diameter_mm[1] / 2
  to_mm_cube_1 = 3.14159 * r1 * r1

  -- material guid management for custom settings
  if material_guid == nil then
    if extruder_temp_degree_c[0] <= 180 and extruder_temp_degree_c[0] >= 210 then 
      material_guid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9'
    elseif extruder_temp_degree_c[0] <= 230 and extruder_temp_degree_c[0] >= 260 then
      material_guid = '60636bb4-518f-42e7-8237-fe77b194ebe0'
    else
      material_guid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9'
    end
  end

  h = file('header.gcode')

  if filament_tot_length_mm[0] > 0 then
    h = h:gsub('<TOOLTEMP0>', extruder_temp_degree_c[0])
  else
    h = h:gsub('<TOOLTEMP0>', 0)
  end

  h = h:gsub('<TOOLVOLUME0>', filament_tot_length_mm[0]*to_mm_cube_0)
  h = h:gsub('<TOOLMATERIAL0>', material_guid)
  -- h = h:gsub('<TOOLNOZZLE0>', nozzle_diameter_mm_0)

  if filament_tot_length_mm[1] > 0 then
    h = h:gsub('<TOOLTEMP1>', extruder_temp_degree_c[1])
  else
    h = h:gsub('<TOOLTEMP1>', 0)
  end

  h = h:gsub('<TOOLVOLUME1>', filament_tot_length_mm[1]*to_mm_cube_0)
  h = h:gsub('<TOOLMATERIAL1>', material_guid)
  -- h = h:gsub('<TOOLNOZZLE1>', nozzle_diameter_mm_0)

  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  h = h:gsub('<ESTPTIME>', time_sec)
  h = h:gsub('<XMIN>', 0)
  h = h:gsub('<YMIN>', 0)
  h = h:gsub('<ZMIN>', 0)
  h = h:gsub('<XMAX>', f(min_corner_x+extent_x))
  h = h:gsub('<YMAX>', f(min_corner_y+extent_y))
  h = h:gsub('<ZMAX>', f(extent_z))

  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  output(';retract')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 0 then
    output('G0 F600 Z' .. ff(zheight))
  else
    output('G0 F100 Z' .. ff(zheight))
  end
  current_z = zheight
end

function layer_stop()
  output(';(</layer>)')
end

-- this is called once for each used extruder at startup
function select_extruder(extruder)
  if current_extruder > -1 then
    -- reset E axis of previous
    output('G92 E0')
    extruder_e_restart[current_extruder] = extruder_e[current_extruder]
    -- store filament (large retract)
    local len   = extruder_swap_retract_length_mm
    local speed = extruder_swap_retract_speed_mm_per_sec * 60;
    output('G0 F' .. speed .. ' E' .. - len)
    output('G92 E0')
    extruder_stored[current_extruder] = true
  end
  output('T' .. extruder)
  current_extruder = extruder
  -- prep the selected extruder
  prep_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
  output(';swap_extruder')
  -- reset E axis of previous
  output('G92 E0')
  extruder_e_restart[from] = extruder_e[from]
  -- store filament (large retract)
  local len   = extruder_swap_retract_length_mm
  local speed = extruder_swap_retract_speed_mm_per_sec * 60;
  output('G0 F' .. speed .. ' E' .. - len)
  output('G92 E0')
  extruder_stored[from] = true
  -- swap extruder
  output('T' .. to)
  -- check if stored
  if extruder_stored[to] then
    -- unstore filament
    output('G0 F' .. speed .. ' E' .. len)
    output('G92 E0')
    extruder_stored[to] = false
  end
  -- done
  current_extruder = to
end

function move_xyz(x,y,z)
  if traveling == 0 then
    traveling = 1 -- start traveling
    output(';travel')
    output('M204 S3000')
    output('M205 X20')
  end
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  if traveling == 1 then
    traveling = 0 -- start path
    if path_is_perimeter then
      output(';perimeter')
      output('M204 S500')
      output('M205 X5')
    else
      if      path_is_shell   then output(';shell')
      elseif  path_is_infill  then output(';infill')
      elseif  path_is_raft    then output(';raft')
      elseif  path_is_brim    then output(';brim')
      elseif  path_is_shield  then output(';shield')
      elseif  path_is_support then output(';support')
      elseif  path_is_tower   then output(';tower')
      end
      output('M204 S1000')
      output('M205 X10')
    end
  end
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  r = filament_diameter_mm[extruders[0]] / 2
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
    current_z = z
  end
end

function move_e(e)
  letter = 'E'
  output('G0 ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
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
  output('M104 T' .. extruder .. ' S' .. f(temperature))
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
