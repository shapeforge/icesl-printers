-- Alpha wise dual color switching extruder
-- sylefeb 2018-12-08

function comment(text)
  output('; ' .. text)
end

current_z = 0
current_extruder = -1

extruder_e = {}
extruder_e_restart = {}

extruder_e[0] = 0
extruder_e[1] = 0
extruder_e[2] = 0
extruder_e[3] = 0
extruder_e_restart[0] = 0
extruder_e_restart[1] = 0
extruder_e_restart[2] = 0
extruder_e_restart[3] = 0

traveling = 0

function header()
  output('M201 X9000 Y9000 Z500 E10000 ; sets maximum accelerations, mm/sec^2')
  output('M203 X500 Y500 Z12 E120 ; sets maximum feedrates, mm/sec')
  output('M204 P2000 R1500 T2000 ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2')
  output('M205 X10.00 Y10.00 Z0.20 E2.50 ; sets the jerk limits, mm/sec')
  output('M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec')
  output('M107')
  output('M115 U3.1.0 ; tell printer latest fw version')
  output('M204 S2000 T1500 ; MK2 firmware only supports the old M204 format')

  output('T1')
  output('M104 S' .. extruder_temp_degree_c[extruders[0]] )
  output('M140 S' .. bed_temp_degree_c )
  output('M109 S' .. extruder_temp_degree_c[extruders[0]] )
  output('M190 S' .. bed_temp_degree_c )

  -- Z calibration + homing
  output('G28 W')
  output('G80')
  output('M203 E100 ; set max feedrate')
  -- output('M92 E140 ; E-steps per filament milimeter')
  output('G21 ;set units to millimeters')
  output('G90 ;use absolute coordinates')
  output('M82 ; use absolute distances for extrusion')
  output('G92 E0')
end

function footer()
  output('G1 Z78.6 ; Move print head up')
  output('M107')
  output('M104 S0')
  output('M140 S0')
  output('G28 X0')
  output('M84')
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
  extruder_e_restart[current_extruder] = extruder_e[current_extruder]
  output('G92 E0')
  output(';(</layer>)')
end


swap_dist_mm = 50

tower_a = extruder_swap_location_x_mm - swap_dist_mm/2
tower_b = extruder_swap_location_x_mm + swap_dist_mm/2

-- [fr] cette fonction est appelee pour re-introduire le filament
function load_extruder(extruder)

  -- load filament
  output(';load extruder ' .. extruder .. ' START')
  -- [fr] changement de fil
  output('T' .. extruder)
  -- [fr] passage en relatif sur l'axe E
  output('M83 ; use relative distances for extrusion')
  -- [fr] le filament est repousse dans l'echangeur
  --      la valeur de E est en millimetres
  --      F defini la vitesse (mm/min, c.a.d 60x mm/sec)
  output('G1 E160.0000 F1800') -- Exxx prime distance
  -- [fr] pause (?)
  output('G4 S0')
  -- [fr] repasse E en absolu
  output('M82 ; use absolute distances for extrusion')
  -- [fr] reset de l'axe E (attendu par le reste du code)
  output('G92 E0')
  -- [fr] c'est fait!
  output(';load extruder ' .. extruder .. ' END')

  current_extruder = extruder

end

-- [fr] cette fonction est appelee pour retirer le filament
function unload_extruder(extruder)

  output(';unload extruder ' .. extruder .. ' START')
  -- [fr] passage en relatif sur l'axe E
  output('M83 ; use relative distances for extrusion')
  -- [fr] le filament est retire de l'echangeur
  --      la valeur de E est en millimetres
  --      F defini la vitesse (mm/min, c.a.d 60x mm/sec)
  -- [fr] premiere etape: retrait rapide
  output('G1 E-10.0000 F6000')
  -- [fr] seconde etape: retrait lent
  output('G1 E-150.0000 F1800')
  -- [fr] IMPORTANT: la somme des deux etapes doit 
  --      etre egale a la valeur utilisee dans load_extruder
  --      pour repousser le filament
  
  -- [fr] pause (?)
  output('G4 S0')
  -- [fr] repasse E en absolu
  output('M82 ; use absolute distances for extrusion')
  -- [fr] reset de l'axe E (attendu par le reste du code)
  output('G92 E0')
  -- [fr] c'est fait!
  output(';unload extruder ' .. extruder .. ' END')

end

-- this is called once for each used extruder at startup
function select_extruder(extruder)

  output('G1 Z1.5 X0.0000 Y' .. (-3 + f(extruder)*2.5) .. ' F3000.0')

  if current_extruder > -1 then
    unload_extruder(current_extruder)
  end

  -- load filament
  load_extruder(extruder)

  -- prime outside print area
  output('G1 Z0.5 X100.0 E5.00 F1000.0')
  output('G1 Z0.5 X200.0 E20.0 F1000.0')

  -- prime done, reset E
  output('G92 E0')
  current_extruder = extruder
  
end

function swap_extruder(from,to,x,y,z)

  extruder_e_restart[current_extruder] = extruder_e[current_extruder]

  local len   = extruder_swap_retract_length_mm
  local speed = extruder_swap_retract_speed_mm_per_sec * 60

  output(';swap_extruder')
  unload_extruder(from)
  load_extruder(to)
  
end

function move_xyz(x,y,z)
  if traveling == 0 then
    traveling = 1 -- start traveling
    output(';travel')
    output('M204 S3000')
    output('M205 X20')
  end

  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

coeff = 1
function move_xyze(x,y,z,e)
  if traveling == 1 then
    traveling = 0 -- start path
    if path_is_perimeter then
      output(';perimeter')
      output('M204 S500')
      output('M205 X5')
    else
      if      path_is_shell   then output(';shell')   coeff = 1
      elseif  path_is_infill  then output(';infill')  coeff = 1
      elseif  path_is_raft    then output(';raft')    coeff = 1
      elseif  path_is_brim    then output(';brim')    coeff = 1
      elseif  path_is_shield  then output(';shield')  coeff = 1
      elseif  path_is_support then output(';support') coeff = 1
      elseif  path_is_tower   then output(';tower')   coeff = 2
      end
      output('M204 S1000')
      output('M205 X10')
    end
  end

  extruder_e[current_extruder] = e
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate * coeff) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
  else
    output('G1 F' .. f(current_frate * coeff) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff((e-extruder_e_restart[current_extruder])))
    current_z = z
  end
end

function move_e(e)
  extruder_e[current_extruder] = e
  letter = 'E'
  output('G0 ' .. letter .. f(e-extruder_e_restart[current_extruder]))
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
  output('M104 S' .. temperature .. ' T' .. extruder)
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
