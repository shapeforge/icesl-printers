-- Generic reprap customized for Tevo Tarantula (still pretty generic, would work for any Marlin printer with Linear Advance feature enabled)

function comment(text)
  output('; ' .. text)
end

layer_count = 0

extruder_e = 0 -- current total extrusion length
extruder_e_layer_start = 0 -- total extrusion length at start of current layer

function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  h = h:gsub( '<LINADVANCE>', lin_advance_k )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer ' .. layer_count .. '>')
  comment('<extruded ' .. extruder_e .. 'mm >')
  
  extruder_e_layer_start = extruder_e
  output('G92 E0')
  
  -- change Z height before extruding only for layers other than the first (because of the priming in the corner, for the first layer we want to start moving X and Y before Z reaches the initial layer height)
  if layer_count ~= 0 then
	output('G1 Z' .. f(zheight))
  end
end

function layer_stop()
  comment('</layer ' .. layer_count .. '>')
  layer_count = layer_count + 1
end

function retract(extruder,e) 
  length = filament_priming_mm[extruder]
  speed = retract_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e - length - extruder_e_layer_start))
  extruder_e = e - length
  return extruder_e
end

function prime(extruder,e)
  length = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  output('G1 F' .. speed .. ' E' .. ff(e + length - extruder_e_layer_start))
  extruder_e = e + length
  return extruder_e
end

current_extruder = 0
current_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if z == current_z then
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  if z == current_z then
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff(e - extruder_e_layer_start))
  else
    output('G1 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' ' .. letter .. ff(e - extruder_e_layer_start))
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_layer_start))
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

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

current_fan_speed = -1
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
