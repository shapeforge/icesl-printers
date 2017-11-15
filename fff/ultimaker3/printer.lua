-- Ultimaker 3
-- Sylvain Lefebvre  2017-07-28

version = 1

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
  output(';START_OF_HEADER')
  output(';HEADER_VERSION:0.1')
  output(';FLAVOR:Griffin')
  output(';GENERATOR.NAME:IceSL')
  output(';GENERATOR.VERSION:2.1')
  output(';GENERATOR.BUILD_DATE:2017-07-28')
  output(';TARGET_MACHINE.NAME:Ultimaker 3')
  if filament_tot_length_mm[0] > 0 then
    output(';EXTRUDER_TRAIN.0.INITIAL_TEMPERATURE:'..extruder_temp_degree_c[0])
  else
    output(';EXTRUDER_TRAIN.0.INITIAL_TEMPERATURE:'..0)
  end
  output(';EXTRUDER_TRAIN.0.MATERIAL.VOLUME_USED:' .. filament_tot_length_mm[0]*to_mm_cube_0)
  output(';EXTRUDER_TRAIN.0.MATERIAL.GUID:506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9')
  output(';EXTRUDER_TRAIN.0.NOZZLE.DIAMETER:0.4')
  if filament_tot_length_mm[1] > 0 then
    output(';EXTRUDER_TRAIN.1.INITIAL_TEMPERATURE:'..extruder_temp_degree_c[1])
  else
    output(';EXTRUDER_TRAIN.1.INITIAL_TEMPERATURE:'..0)
  end
  output(';EXTRUDER_TRAIN.1.MATERIAL.VOLUME_USED:' .. filament_tot_length_mm[1]*to_mm_cube_1)
  output(';EXTRUDER_TRAIN.1.MATERIAL.GUID:506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9')
  output(';EXTRUDER_TRAIN.1.NOZZLE.DIAMETER:0.4')
  output(';BUILD_PLATE.INITIAL_TEMPERATURE:' .. bed_temp_degree_c)
  output(';PRINT.TIME:' .. time_sec)
  output(';PRINT.SIZE.MIN.X:'..0)
  output(';PRINT.SIZE.MIN.Y:'..0)
  output(';PRINT.SIZE.MIN.Z:'..0)
  output(';PRINT.SIZE.MAX.X:'..f(min_corner_x+extent_x))
  output(';PRINT.SIZE.MAX.Y:'..f(min_corner_y+extent_y))
  output(';PRINT.SIZE.MAX.Z:'..f(extent_z))
  output(';END_OF_HEADER')
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
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. f(e - len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e - len
  return e - len
end

function prime(extruder,e)
  output(';prime')
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec * 60
  output('G0 F' .. speed .. ' E' .. f(e + len - extruder_e_restart[extruder]))
  extruder_e[extruder] = e + len
  return e + len
end

function layer_start(zheight)
  output(';(<layer ' .. layer_id .. '>)')
  if layer_id == 1 then
    output('M106 S255') -- fan ON
  end
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
