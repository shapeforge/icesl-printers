-- Flashforge Creator Pro profile
-- Bedell Pierre 24/10/2019

bed_origin_x = bed_size_x_mm / 2.0
bed_origin_y = bed_size_y_mm / 2.0

current_extruder = 0
current_frate = 0

current_fan_speed = -1

function comment(text)
  output('(' .. text .. ')')
end

function header()
  local h = file('header.gcode')

  local extruders_temp_string = ""
  local extruders_park_string = ""
  local extruders_purge_string = ""

  if filament_tot_length_mm[0] > 0 then
    extruders_temp_string = extruders_temp_string .. '\nM104 S' .. extruder_temp_degree_c[extruders[0]] .. '(set extruder 0 temperature)'
    extruders_temp_string = extruders_temp_string .. '\nM133 T0 (stabilize extruder 0 temperature)'
  end
  if filament_tot_length_mm[1] > 0 then
    extruders_temp_string = extruders_temp_string .. '\nM104 S' .. extruder_temp_degree_c[extruders[1]] .. '(set extruder 1 temperature)'
    extruders_temp_string = extruders_temp_string .. '\nM133 T1 (stabilize extruder 1 temperature)'
  end

  if number_of_extruders == 1 then
    if filament_tot_length_mm[0] > 0 then
      extruders_park_string = extruders_park_string .. 'G1 X-113 Y-72 Z30 F9000 (move to park position on the left of the build plate for extruder 0)'
      extruders_purge_string = extruders_purge_string .. 'M135 T0 (select left tool - extruder 0)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X-110 Y-70 F9000 (reposition nozzle)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X-100 Y-70 A25 F300 (purge nozzle)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X-110 Y-70 Z0.15 F1200 (slow wipe)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X-100 Y-70 Z0.5 F1200 (lift)'
    elseif filament_tot_length_mm[1] > 0 then
      extruders_park_string = extruders_park_string .. 'G1 X113 Y-72 Z30 F9000 (move to park position on the right of the build plate for extruder 1)'
      extruders_purge_string = extruders_purge_string .. 'M135 T1 (select right tool - extruder 1)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 F9000 (reposition nozzle)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 B25 F300 (purge nozzle)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X100 Y-70 Z0.15 F1200 (slow wipe)'
      extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 Z0.5 F1200 (lift)'
    end
  elseif number_of_extruders == 2 then
    extruders_park_string = extruders_park_string .. 'G1 X-110 Y-70 Z30 F9000 (move to park position on the left of the build plate)'
    extruders_purge_string = extruders_purge_string .. 'M135 T0 (select left tool - extruder 0)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X-110 Y-70 F9000 (reposition nozzle)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X-100 Y-70 A25 F300 (purge nozzle)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X-110 Y-70 Z0.15 F1200 (slow wipe)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X-100 Y-70 Z0.5 F1200 (lift)'
    extruders_purge_string = extruders_purge_string .. '\n\nG1 Z5.0'
    extruders_purge_string = extruders_purge_string .. '\n\nM135 T1 (select right tool - extruder 1)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 F9000 (reposition nozzle)'
    extruders_purge_string = extruders_purge_string .. '\nG1 Z0.4'
    extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 B25 F300 (purge nozzle)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X100 Y-70 Z0.15 F1200 (slow wipe)'
    extruders_purge_string = extruders_purge_string .. '\nG1 X110 Y-70 Z0.5 F1200 (lift)'
  end

  h = h:gsub( '<EXTRUDERS_PARK>', extruders_park_string)
  h = h:gsub( '<HB_TEMP>', bed_temp_degree_c )
  h = h:gsub( '<EXTRUDERS_TEMP>', extruders_temp_string)
  h = h:gsub( '<EXTRUDERS_PURGE>', extruders_purge_string)
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer>')
  output('G0 Z' .. f(zheight))
end

function layer_stop()
  comment('</layer>')
end

function retract(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60;
  if extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e - len))
  return e - len
end

function prime(extruder,e)
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60;
  if extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 F' .. f(speed) .. ' ' .. letter .. ff(e + len))
  return e + len
end

function select_extruder(extruder)
  current_extruder = extruder
  output('M135 T' .. extruder)
end

function swap_extruder(from,to,x,y,z)
  current_extruder = to
end

function move_xyz(x,y,z)
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  output('G0 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z))
end

function move_xyze(x,y,z,e)
  x = x + extruder_offset_x[current_extruder]
  y = y + extruder_offset_y[current_extruder]
  if current_extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z) .. ' F' .. current_frate .. ' ' .. letter .. ff(e))
end

function move_e(e)
  if current_extruder == 0 then letter = 'A' else letter = 'B' end
  output('G1 ' .. letter .. ff(e))
end

function set_feedrate(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

function extruder_start()
  output('M101')
end

function extruder_stop()
  output('M103')
end

function progress(percent)
  output('M73 P' .. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
  output('M133 T' .. extruder)
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
