-- 3DMS XLP

function comment(text)
  output('; ' .. text)
end

extruder_e = 0
extruder_e_restart = 0

function prep_extruder(extruder)
end


function header()
  h = file('header.gcode')
  h = h:gsub( '<TOOLTEMP>', extruder_temp_degree_c[extruders[0]] )
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  h = h:gsub( '<NOZZLE_SIZE>', f(nozzle_diameter_mm) )
  h = h:gsub( '<LAYER_HEIGHT>', f(z_layer_height_mm) )
  h = h:gsub( '<FILAMENT_DIAMETER>', f(filament_diameter_mm_0) )
  if(enable_g29_incremental_bed_leveling == true) then 
  LeftLocation = math.floor(min_corner_x - g29_margin)
  FrontLocation = math.floor(min_corner_y - g29_margin)
  RightLocation = math.floor(min_corner_x + extent_x + g29_margin)
  BackLocation = math.floor(min_corner_y + extent_y + g29_margin)
   if(LeftLocation >= ABL_LEFT_PROBE_BED_POSITION and FrontLocation >= ABL_FRONT_PROBE_BED_POSITION and RightLocation <= ABL_RIGHT_PROBE_BED_POSITION and BackLocation <= ABL_BACK_PROBE_BED_POSITION) then 
		g29 = 'G29 L'..LeftLocation..' F'..FrontLocation.. ' R'..RightLocation..' B'..BackLocation
	else
		g29 = 'G29'
	end
	h = h:gsub( 'G29', g29 )
  end
  
  if(enable_ZFade == true) then 
	h = h:gsub("<ZFADE>", "M420 Z" .. ZFade_height.." ;Enable ZFade with "..ZFade_height.."mm")
  else
	h = h:gsub("<ZFADE>","")
  end
  
  output(h)
end

function footer()
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment('<LAYER:'..layer_id..'>')
  comment('<Current Height:' ..f(zheight).. '>')
  output('G1 Z' .. f(zheight))
  
	if(override_cooling_fan == true ) then 
	  if(fan_speed_start_at_layer > fan_speed_max_at_layer) then return end
	  
	  if (layer_id >= fan_speed_start_at_layer) and (layer_id <= fan_speed_max_at_layer) then
		  distance = fan_speed_max_at_layer - fan_speed_start_at_layer + 1
		  layer_idx = (layer_id - fan_speed_start_at_layer) + 1
		  
		  --case when we want to start full speed first
		  if(distance == 1) then 
			  if(fan_speed_max_percent < fan_speed_min_percent) then
			    comment('Override Fans Speed '..(fan_speed_min_percent)..'%')
				output('M106 S' .. math.floor((fan_speed_min_percent / 100 * 255)))
			  else
			    comment('Override Fans Speed '..(fan_speed_max_percent)..'%')
				output('M106 S' .. math.floor((fan_speed_max_percent / 100 * 255)))
			  end
		  else
		  -- progressive fan speed
			  speed = ((layer_idx * 100/ distance) * (fan_speed_max_percent) / 100)
				if(speed < fan_speed_min_percent) then 
				    comment('Override Fans Speed '..(fan_speed_min_percent)..'%')
					output('M106 S' .. math.floor(fan_speed_min_percent / 100 * 255))
				else
				    comment('Override Fans Speed '..math.floor(speed) ..'%')
					output('M106 S' .. math.floor(speed / 100 * 255))
				end
			  
		  end
	  end
	end
end

function layer_stop()
  extruder_e_restart = extruder_e
  output('G92 E0')
  comment('</layer>')
end

function retract(extruder,e) 
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  output ('G1 F' .. speed .. ' ' .. letter .. ff(e - len - extruder_e_restart))
  if enable_vertical_lift == true then
	  output ('G91  ; use relative coordinates')
	  output ('G1 Z'..f(retract_vertical_lift)..'  ; Lift the nozzle')
	  output ('G90  ; use absolute coordinates')
  end
  
  
  extruder_e = e - len
  return e - len
end

function prime(extruder,e)
  len   = filament_priming_mm[extruder]
  speed = priming_mm_per_sec[extruder] * 60;
  letter = 'E'
  if enable_vertical_lift == true then
	  output ('G91  ; use relative coordinates')
	  output ('G1 Z-'..f(retract_vertical_lift)..'  ; Lift the nozzle')
	  output ('G90  ; use absolute coordinates')
  end
  output ('G1 F' .. speed .. ' ' .. letter .. ff(e + len - extruder_e_restart))
  extruder_e = e + len
  return e + len
end

current_extruder = 0
current_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if enable_vertical_lift == true then
     output('G1 X' .. f(x) .. ' Y' .. f(y))
  else
    output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. f(z+z_offset))
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  letter = 'E'
  output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' ' .. letter .. ff(e - extruder_e_restart))
end

function move_e(e)
  extruder_e = e
  letter = 'E'
  output('G1 ' .. letter .. ff(e - extruder_e_restart))
end

function set_feedrate(feedrate)
  output('G1 F' .. feedrate)
  current_frate = feedrate
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
  output('M117 ' ..i(percent)..'%')
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 S' .. temperature .. ' T' .. extruder)
end

function set_fan_speed(speed)
    if(override_cooling_fan == true) then return end
	
    comment('IceSL Fans Speed '..speed..'%')
	if(speed < fan_speed_min_percent and speed > 0) then
	  comment('IceSL Fans Speed ('..speed..'%) < Min fan speed('..fan_speed_min_percent..'%), Using minimum fan speed instead')
	  output('M106 S'.. math.floor(255 * fan_speed_min_percent/100))
	elseif (speed > fan_speed_max_percent) then 
	    comment('IceSL Fans Speed ('..speed..'%) > Max fan speed('..fan_speed_max_percent..'%), Using maximum fan speed instead')
		output('M106 S'.. math.floor(255 * fan_speed_max_percent/100))
	else
	  output('M106 S'.. math.floor(255 * speed/100))
	end
end 
