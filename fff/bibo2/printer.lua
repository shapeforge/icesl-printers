-- Bibo 2 Touch X
-- 2018-02-06

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
  output('M117 Purge Extruder ' .. extruder)

  -- reset E
  output('G92 E0')
  -- go slightly above plate
  output('G0 Z' .. 3.0)
  -- heat up nozzle
  output('M109 T' .. extruder .. ' S' .. extruder_temp_degree_c[extruder])

  output('G0 Z0.3 X'.. f(-bed_size_x_mm/2) .. ' Y' .. f(-bed_size_y_mm/2 + extruder*2.5) .. ' ; move to start-line position')
  output('G1 X0 F3000.0 E20.0')
  output('G1 Z0.2 X'.. f(bed_size_x_mm/2) ..' F3000.0 E40.0')

  -- go to zero to wipe on bed
  output('G0 Z' .. 0.0)
  -- prime done, reset E
  output('G92 E0')
end

function header()
  output('G90 ; absolute mode')
  output('G21 ; metric values')
  output('M82 ; Extruder in absolute mode')

  output('G28 ; home all axes')

  output('M190 S' .. bed_temp_degree_c .. ' ; heat bed')
  output('M106 S0 ; fan off')
end

function footer()
  output('M106 S0 ; fan off')
  output('M104 T0 S0 ; cool extruder 0')
  output('M104 T1 S0 ; cool extruder 1')
  output('M106 S255') -- fan ON
  output('M140 S0  ;heated bed heater off (if you have it)')
  output('G91')
  output('G1 Z1 F100   ;relative positioning')
  output('G1 E-1 F300 ;retract the filament a bit before lifting the nozzle, to release some of the pressure')
  output('G1 Z+0.5 E-2 X-20 Y-20 F600 ;move Z up a bit and retract filament even more')
  output('G28 X0 Y0                              ;move X/Y to min endstops, so the head is out of the way')
  output('M84                         ;steppers off')
  output('G90                         ;absolute positioning')
  output('M106 S0 ; fan off')
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
    output('M106 S' .. math.floor(255 * fan_speed_multiplier)) -- fan ON
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
  end
  x = x + extruder_offset_x[current_extruder] - bed_size_x_mm/2
  y = y + extruder_offset_y[current_extruder] - bed_size_y_mm/2
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
    if path_is_perimeter    then output(';perimeter')
    elseif  path_is_shell   then output(';shell')
    elseif  path_is_infill  then output(';infill')
    elseif  path_is_raft    then output(';raft')
    elseif  path_is_brim    then output(';brim')
    elseif  path_is_shield  then output(';shield')
    elseif  path_is_support then output(';support')
    elseif  path_is_tower   then output(';tower')
    end
  end
  x = x + extruder_offset_x[current_extruder] - bed_size_x_mm/2
  y = y + extruder_offset_y[current_extruder] - bed_size_y_mm/2
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
