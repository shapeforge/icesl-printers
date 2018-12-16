version    = 2

verbose    = true

current_frate = 0

current_e  = 0
extruder_e = {}

for i=0,extruder_count-1 do
  extruder_e[i] = 0.0
end

current_A  = 0.33
current_B  = 0.33
current_C  = 0.34

function other_e(e)
  local sum = 0.0
  for i=0,extruder_count-1 do
    if i ~= e then
	  sum = sum + extruder_e[i]
	end
  end
  return sum
end

function comment(text)
  output('; ' .. text)
end

function header()
  if auto_bed_leveling == true then
    h = file('bed_level_header.gcode')
  else
    h = file('header.gcode')
  end
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<layer>')
  output('G1 Z' .. f(zheight))
end

function layer_stop()
  comment('</layer>')
end

retracted = false

function retract(extruder,e)
  if retracted then return e end
  retracted = true
  len   = filament_priming_mm[extruder] * nb_nozzle_in
  speed = (priming_mm_per_sec * nb_nozzle_in) * 60
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. f(e - len + other_e(current_e)) .. ' A0.33 B0.33 C0.34')
  extruder_e[current_e] = e - len
  comment('<retract from ' .. (e + other_e(current_e)) .. ' to ' .. (e - len + other_e(current_e)) .. '>')
  return e - len
end

function prime(extruder,e)
  if not retracted then return e end
  retracted = false
  len   = filament_priming_mm[extruder] * nb_nozzle_in
  speed = (priming_mm_per_sec * nb_nozzle_in) * 60
  letter = 'E'
  output('G1 F' .. speed .. ' ' .. letter .. f(e + len + other_e(current_e)) .. ' A0.33 B0.33 C0.34')
  extruder_e[current_e] = e + len
  comment('<prime from ' .. (e + other_e(current_e)) .. ' to ' .. (e + len + other_e(current_e)) .. '>')
  return e + len
end

function select_extruder(extruder)
  current_e = extruder
  comment('</select ' .. extruder .. '>')
end

function swap_extruder(from,to,x,y,z)
    comment('</swap ' .. to .. '>')
    current_e = to
end

function move_xyz(x,y,z)
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
end

function move_xyze(x,y,z,e)
  letter = ' E'
  if path_is_raft then
    current_A = 0.33
    current_B = 0.33
    current_C = 0.34
  end
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset) .. ' F' .. current_frate .. ' ' .. letter .. ff(e + other_e(current_e)) .. ' A' .. f(current_A) .. ' B' .. f(current_B) .. ' C' .. f(current_C))
end

function move_e(e)
  letter = ' E'
  output('G1 ' .. letter .. ff(e + other_e(current_e)))
end

function set_feedrate(feedrate)
  feedrate = math.floor(feedrate)
  output('G1 F' .. feedrate)
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

function set_mixing_ratios(ratios)
  sum = ratios[0] + ratios[1] + ratios[2]
  if sum == 0 then
    ratios[0] = 0.33
    ratios[1] = 0.33
    ratios[2] = 0.34
  end
  current_A = ratios[0]
  current_B = ratios[1]
  current_C = ratios[2]
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end
