-- Ultimaker 3
-- Sylvain Lefebvre  2017-07-28

extruder_e = {}
extruder_e[0] = 0
extruder_e[1] = 0

extruder_e_restart = {}
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0

extruder_stored = {}
extruder_stored[0] = false
extruder_stored[1] = false

traveling = false
changed_frate = false

current_z = 0
current_frate = 0
current_extruder = - 1
current_fan_speed = -1

craftware_debug = true

--##################################################

function comment(text)
  output('; ' .. text)
end

function e_to_mm_cube(filament_diameter, e)
  local r = filament_diameter / 2
  return (math.pi * r^2 ) * e
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

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
  
  if extruder == 0 then
    output('G0 F1500 X25 Y6 Z0.0')
  else
    output('G0 F1500 X190 Y6 Z0.0')
  end
  -- prime done, reset E
  output('G92 E0')
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function header()
  --------------------------------------------------
  -- Material Guid management for custom settings
  --------------------------------------------------
  if material_guid == nil then
    if extruder_temp_degree_c[0] <= 180 and extruder_temp_degree_c[0] >= 210 then 
      material_guid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9' -- PLA GUID
    elseif extruder_temp_degree_c[0] <= 230 and extruder_temp_degree_c[0] >= 260 then
      material_guid = '60636bb4-518f-42e7-8237-fe77b194ebe0' -- ABS GUID
    else
      material_guid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9' -- PLA GUID
    end
  end

  --------------------------------------------------
  -- Header Generation (commented output will be available in a future version of IceSL)
  --------------------------------------------------

  -- Start of the header (printer and slicer informations)
  output(';START_OF_HEADER')
  output(';HEADER_VERSION:0.1')
  output(';FLAVOR:Griffin')
  output(';GENERATOR.NAME:' .. slicer_name)
  output(';GENERATOR.VERSION:' .. slicer_version)
  output(';GENERATOR.BUILD_DATE:' .. slicer_build_date)
  output(';TARGET_MACHINE.NAME:Ultimaker 3\n')

  -- Extruder management (commented output will be available in future version of IceSL)
  if filament_tot_length_mm[0] > 0 then 
    output(';EXTRUDER_TRAIN.0.INITIAL_TEMPERATURE:' .. extruder_temp_degree_c[0])
    output(';EXTRUDER_TRAIN.0.MATERIAL.VOLUME_USED:' .. e_to_mm_cube(filament_diameter_mm[0],filament_tot_length_mm[0]))
    output(';EXTRUDER_TRAIN.0.MATERIAL.GUID:' .. material_guid)
    output(';EXTRUDER_TRAIN.0.NOZZLE.DIAMETER:' .. round(nozzle_diameter_mm_0,2) .. '\n')
    --output(';EXTRUDER_TRAIN.0.NOZZLE.NAME:' .. printcore_0)
  end

  if filament_tot_length_mm[1] > 0 then 
    output(';EXTRUDER_TRAIN.1.INITIAL_TEMPERATURE:' .. extruder_temp_degree_c[1])
    output(';EXTRUDER_TRAIN.1.MATERIAL.VOLUME_USED:' .. e_to_mm_cube(filament_diameter_mm[1],filament_tot_length_mm[1]))
    output(';EXTRUDER_TRAIN.1.MATERIAL.GUID:' .. material_guid)
    output(';EXTRUDER_TRAIN.1.NOZZLE.DIAMETER:' .. round(nozzle_diameter_mm_1,2) .. '\n')
    --output(';EXTRUDER_TRAIN.1.NOZZLE.NAME:' .. printcore_1)
  end

  -- Build plate management
  output(';BUILD_PLATE.TYPE:glass')
  output(';BUILD_PLATE.INITIAL_TEMPERATURE:' .. bed_temp_degree_c .. '\n')

  -- Printing time estimation
  output(';PRINT.TIME:' .. time_sec .. '\n')

  -- Limits of the print
  output(';PRINT.SIZE.MIN.X:' .. 0)
  output(';PRINT.SIZE.MIN.Y:' .. 0)
  output(';PRINT.SIZE.MIN.Z:' .. 0)
  output(';PRINT.SIZE.MAX.X:' .. f(min_corner_x+extent_x))
  output(';PRINT.SIZE.MAX.Y:' .. f(min_corner_y+extent_y))
  output(';PRINT.SIZE.MAX.Z:' .. f(extent_z) .. '\n')

  -- End of the header
  output(';END_OF_HEADER\n')
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output('M204 S3000')
  output('M205 X20')
  output('M107')
  output('M104 T0 S0')
  output('M104 T1 S0')
end

function retract(extruder,e)
  output(';retract')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  local e_value = e - len - extruder_e_restart[extruder]
  output('G1 F' .. speed .. ' E' .. ff(e_value))
  extruder_e[extruder] = e - len
  current_frate = speed
  changed_frate = true
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  local e_value = e + len - extruder_e_restart[extruder]
  output('G1 F' .. speed .. ' E' .. ff(e_value))
  extruder_e[extruder] = e + len
  current_frate = speed
  changed_frate = true
  return e + len
end

function layer_start(zheight)
  output('; <layer ' .. layer_id .. '>')
  local frate = 600
  if layer_id == 0 then
    output('G0 F' .. frate .. ' Z' .. ff(zheight))
  else
    frate = 100
    output('G0 F' .. frate .. ' Z' .. ff(zheight))
  end
  current_z = zheight
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  output('; </layer>')
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
    current_frate = travel_speed_mm_per_sec * 60
  end
  --output('\n')
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
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function move_xyz(x,y,z)
  if traveling == false then
    traveling = true -- start traveling
    output(';travel')
    output('M204 S3000')
    output('M205 X20')
  end

  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]

  if z == current_z then
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  if traveling == true then
    traveling = false -- start path
    if craftware_debug == true then
      if path_is_perimeter then 
        output(';segType:Perimeter\nM204 S500\nM205 X5')
      else
        if      path_is_shell     then output(';segType:HShell')
        elseif  path_is_infill    then output(';segType:Infill')
        elseif  path_is_raft      then output(';segType:Raft')
        elseif  path_is_brim      then output(';segType:Skirt')
        elseif  path_is_shield    then output(';segType:Pillar')
        elseif  path_is_support   then output(';segType:Support')
        elseif  path_is_tower     then output(';segType:Pillar')
        end
        output('M204 S1000\nM205 X10')
      end
    else
      if path_is_perimeter then 
        output(';perimeter\nM204 S500\nM205 X5')
      else
        if      path_is_shell     then output(';shell')
        elseif  path_is_infill    then output(';infill')
        elseif  path_is_raft      then output(';raft')
        elseif  path_is_brim      then output(';brim')
        elseif  path_is_shield    then output(';shield')
        elseif  path_is_support   then output(';support')
        elseif  path_is_tower     then output(';tower')
        end
        output('M204 S1000\nM205 X10')
      end
    end
  end

  local e_value = e-extruder_e_restart[current_extruder]

  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]

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
  local e_value = e-extruder_e_restart[current_extruder]
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
