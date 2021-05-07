-- LulzBot TAZ 6 Single Extruder
-- Cloned from generic reprap and borrowed from numerous others
--
-- 2019-06-07 Brad Morgan              Initial Release

--
-- to minimize error introduced by large (float) values, 
-- E is reset at the beginning of each layer.
--
extruder_e = 0
extruder_e_restart = 0

--
-- variables used to optimize (reduce the size of) the GCode output
-- (X and Y could be added to further reduce the size)
--
current_z = 0.0
current_frate = 0
changed_frate = false
current_fan_speed = -1

--
-- variables used to implement a different bed and/or nozzle 
-- temperature for the first layer.
--
first_bed = true
first_extruder = true
if bed_temp_first_c == nil then
  bed_temp_first_c = bed_temp_degree_c
  first_bed = false
end
if bed_temp_remove_c == nil then
  bed_temp_remove_c = 40
end
if extruder_first_degree_c_0 == nil then
  extruder_first_degree_c_0 = extruder_temp_degree_c_0
  first_extruder = false
end

--
-- function used to output comments in the gcode
--
function comment(text)
  output('; ' .. text)
end

--
-- function used to output debug text to the console
-- to turn off, either comment out the calls or comment out the print
--
function debug(text)
  print(text)
end

--
-- header.gcode is copied from CuraLE, https://www.lulzbot.com/cura
-- variables to be substituted are in Cura format
-- added support for a different first layer value for bed and nozzle temperatures(see layer_start)
--
function header()
--  debug('header')
  h = file('header.gcode')
  h = h:gsub( '{material_bed_temperature}', bed_temp_degree_c )
  h = h:gsub( '{material_bed_temperature_layer_0}', bed_temp_first_c )
  h = h:gsub( '{material_print_temperature}', extruder_temp_degree_c_0 ) -- [extruders[0]]
  h = h:gsub( '{material_print_temperature_layer_0}', extruder_first_degree_c_0 ) -- [extruders[0]]
  h = h:gsub( '{material_soften_temperature}', extruder_soft_degree_c_0 ) -- [extruders[0]]
  h = h:gsub( '{material_wipe_temperature}', extruder_wipe_degree_c_0 ) -- [extruders[0]]
  h = h:gsub( '{material_probe_temperature}', extruder_probe_degree_c_0 ) -- [extruders[0]]
  output(h)
end

--
-- footer.gcode is copied from CuraLE, https://www.lulzbot.com/cura
-- variables to be substituted are in Cura format
-- added support for bed part removal temperature
-- (keep part removal temperature is a boolean in CuraLE)
--
function footer()
--  debug('footer')
  h = file('footer.gcode')
  h = h:gsub( '{material_part_removal_temperature}', bed_temp_remove_c)
  h = h:gsub( '{material_keep_part_removal_temperature_t}', bed_temp_remove_c)
  output(h)
end

--
-- added support for a different first layer bed and nozzle temperatures
--
function layer_start(zheight)
--  debug('layer_start - '..layer_id)
--  debug('first_bed = '..tostring(first_bed)..', bed_temp_first_c = '..tostring(bed_temp_first_c)..', bed_temp_degree_c = '..tostring(bed_temp_degree_c))
--  debug('first_extruder = '..tostring(first_extruder)..', extruder_first_degree_c_0 = '..tostring(extruder_first_degree_c_0)..
--    ', extruder_temp_degree_c_0 = '..tostring(extruder_temp_degree_c_0))
  comment('<layer '.. layer_id ..'>')
  output('G1 Z' .. f(zheight))
  current_z = zheight
  if first_bed and bed_temp_first_c ~= bed_temp_degree_c and layer_id > 0 then
    output('M140 S' .. bed_temp_degree_c)
    first_bed = false
  end
  if first_extruder and extruder_first_degree_c_0 ~= extruder_temp_degree_c_0 and layer_id > 0 then
    output('M104 S' .. extruder_temp_degree_c_0)
    first_extruder = false
  end
end

function layer_stop()
--  debug('layer_stop - '..layer_id)
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

--
-- added optimization for feedrate
--
function retract(extruder,e)
--  debug('retract')
  length = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60
  if speed ~= current_frate then
    changed_frate = true
  end
  output('G1 F' .. speed .. ' E' .. f(e - length - extruder_e_restart))
  extruder_e = e - length
  return e - length
end

--
-- added optimization for feedrate
--
function prime(extruder,e)
--  debug('prime')
  length = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  if speed ~= current_frate then
    changed_frate = true
  end
  output('G1 F' .. speed .. ' E' .. f(e + length - extruder_e_restart))
  extruder_e = e + length
  return e + length
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

-- function move_xyz(x,y,z)
--   output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
-- end
--
-- added optimizations for feedrate and Z
--
function move_xyz(x,y,z)
  if z == current_z then
    if changed_frate == true then 
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z))
    end
    current_z = z
  end
end

-- function move_xyze(x,y,z,e)
--   extruder_e = e
--   output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' E' .. ff(e - extruder_e_restart))
-- end
--
-- added optimizations for feedrate and Z
--
function move_xyze(x,y,z,e)
  extruder_e = e
  if z == current_z then
    if changed_frate == true then 
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e - extruder_e_restart))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e - extruder_e_restart))
    end
  else
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' E' .. ff(e - extruder_e_restart))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z) .. ' E' .. ff(e - extruder_e_restart))
    end
    current_z = z
  end
end

-- function move_e(e)
--   extruder_e = e
--   output('G1 E' .. ff(e - extruder_e_restart))
-- end
--
-- added optimization for feedrate
--
function move_e(e)
  extruder_e = e
  output('G1 E' .. ff(e - extruder_e_restart))
  if changed_frate == true then 
    output('G1 F' .. current_frate .. ' E' .. ff(e - extruder_e_restart))
    changed_frate = false
  else
    output('G1 E' .. ff(e - extruder_e_restart))
  end
end

-- function set_feedrate(feedrate)
--   output('G1 F' .. feedrate)
--   current_frate = feedrate
-- end
--
-- added optimization for feedrate
-- feedrate is stored and output is deferred (see move_* functions)
--
function set_feedrate(feedrate)
  if feedrate ~= current_frate then
    current_frate = feedrate
    changed_frate = true
  else
    changed_frate = false
  end
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
  output('M73 P'.. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G0 F" .. travel_speed_mm_per_sec .. " X10 Y10")
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
  output("G0 F" .. travel_speed_mm_per_sec .. " X" .. f(x) .. " Y" .. f(y) .. " Z" .. ff(z))
end
