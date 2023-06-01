-- EmotionTech Micro Delta Rework
-- Pierre Bedell 05/06/2018

bed_origin_x = bed_size_x_mm/2
bed_origin_y = bed_size_y_mm/2

extruder_e = 0
extruder_e_restart = 0

changed_frate = false
current_frate = 0

current_z = 0.0

current_fan_speed = -1

nozzle_clearance_diameter = nozzle_diameter_mm

global_z_offset = -0.3

constant_travel_offset_mm = 0.6
slope_travel_offset       = 1.5
slope_printing_offset     = 1.5


--##################################################

function comment(text)
  output('; ' .. text)
end

function header()
  h = file('header.gcode')
  h = h:gsub('<TOOLTEMP>', extruder_temp_degree_c[extruders[0]])
  h = h:gsub('<HBPTEMP>', bed_temp_degree_c)
  output(h)
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function footer()
  output(file('footer.gcode'))
end

function retract(extruder,e)
  comment('retract')
  local len   = filament_priming_mm[extruder]
  local speed = retract_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e - len - extruder_e_restart))
  current_frate = speed
  changed_frate = true
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  comment('prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  output('G0 F' .. speed .. ' E' .. ff(e + len - extruder_e_restart))
  current_frate = speed
  changed_frate = true
  extruder_e = e + len
  return e + len
end

function layer_start(zheight)
  comment('<layer ' .. layer_id .. '>')
  output('G0 F600 Z' .. ff(zheight))
  nozzle_clearance_diameter = nozzle_diameter_mm
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

traveling = false

function slope_offset()
  if vertex_attributes['slope'] then
    local slope = math.abs(vertex_attributes['slope'])
    slope       = math.min(slope,1.37) -- safety, limit to pi/2 - pi/16
    return math.tan(slope) * nozzle_clearance_diameter / 2.0
  else
    return 0.0
  end
end


function move_xyz(x,y,z)
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  --
  local outstr = ''
  if changed_frate == true then 
    outstr = 'G0 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value)
    changed_frate = false
  else
    outstr = 'G0 X' .. f(x_value) .. ' Y' .. f(y_value)
  end
  -- 
  if z ~= current_z then
    local zoffset = 0
    if vertex_attributes['slope'] and path_length > 0.8 then
      zoffset = constant_travel_offset_mm + slope_travel_offset * slope_offset()
    end
    outstr    = outstr .. ' Z' .. ff(z+zoffset+global_z_offset)
    current_z = z + zoffset
  end
  output(outstr)
  traveling = true
  travel_last = {x=x_value,y=y_value,z=z}
end

function move_xyze(x,y,z,e)
  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
  local x_value = x - bed_origin_x
  local y_value = y - bed_origin_y
  --
  if traveling then
    -- this is the first point of a new path, move back to printing z
    local zoffset = slope_printing_offset * slope_offset()
    local fz      = travel_last.z + zoffset + global_z_offset
    output('G0 F' .. current_frate .. ' X' .. f(travel_last.x) .. ' Y' .. f(travel_last.y) .. ' Z' .. fz)
    traveling = false
  end
  --
  local outstr = ''
  if changed_frate == true then 
    outstr = 'G1 F' .. current_frate .. ' X' .. f(x_value) .. ' Y' .. f(y_value) .. ' E' .. ff(e_value)
    changed_frate = false
  else
    outstr = 'G1 X' .. f(x_value) .. ' Y' .. f(y_value) .. ' E' .. ff(e_value)
  end
  -- 
  if z ~= current_z then
    local zoffset = slope_printing_offset * slope_offset()
    outstr    = outstr .. ' Z' .. ff(z+zoffset+global_z_offset)
    current_z = z + zoffset
  end
  output(outstr)
end

function move_e(e)
  extruder_e = e
  local e_value = extruder_e - extruder_e_restart
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
