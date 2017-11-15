-- Qidi Avatar IV
-- mm1980 15.11.2017
-- no retraction while z<=0.2mm (for better adhesion of the first layer)

version = 1

--variables
current_z = 0		--Z cache, produce shorter G-code (emit Z only if changed
retraction_z = 0.21     --min z value for retraction (test current_z>retraction_z)
current_tool = 0        --tool index, can be 0 or 1
current_frate = 100	--F cache, produce shorter G-code (emit F only if changed)
current_e = {}		--extrusion length cache
current_e[0] = 0
current_e[1] = 0

--constants
bed_origin_x = bed_size_x_mm / 2.0  --xy correction
bed_origin_y = bed_size_y_mm / 2.0  --xy correction
--constants
letter = {}             --tool code (A for tool 0/right extruder, B for tool 1/left extruder)
letter[0] = 'A'	        --1st extduder code
letter[1] = 'B'	        --2nd extduder code
filament_priming_mm = {}           		-- extraction lengths
filament_priming_mm[0] = filament_priming_mm_0 	-- 1st extruder retraction length
filament_priming_mm[1] = filament_priming_mm_1 	-- 2nd extruder retraction length

--code

function header()
  output(';(**** QIDI Tech Avatar IV - profile QIDI ****)')
  output(';')

  ;output(';(**** SWAPPED T0/A and T1/B ****)')
  ;output(';')

  if number_of_extruders ~= 1 then
    output(';(**** Multiple extruders: ' .. number_of_extruders .. ' extruders ****)')
    output(';')
  end

  output(';(**** Filament T0: ' .. filament_tot_length_mm[extruders[0]] .. 'mm ****)')
  if number_of_extruders == 2 then
    output(';(**** Filament T1: ' .. filament_tot_length_mm[extruders[1]] .. 'mm ****)')
  end
  output(';')

  h = file('header_' .. number_of_extruders .. '.gcode')
  h = h:gsub( '<T0TEMP>', extruder_temp_degree_c[0])
  h = h:gsub( '<T1TEMP>', extruder_temp_degree_c[1])
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c)
  output(h)

  output(';')
end

function footer()
  output(';')
  output(file('footer.gcode'))
end

function layer_start(zheight)
  comment(';(<layer>)')
  output('G0 F100 Z' .. ff(zheight))
end

function layer_stop()
  comment(';(</layer>)')
end

function select_extruder(tool)
  current_tool = tool
  output(';select_extruder tool(' .. current_tool .. '), letter=' .. letter[current_tool] .. '')
end

function swap_extruder(from,to,x,y,z)
   output(';swap_extruder E=' .. current_e[current_tool] .. '.')
   speed = extruder_swap_retract_speed_mm_per_sec * 60
   len = extruder_swap_retract_length_mm
   current_tool = from
   Qretract(speed,len)
   current_tool = to
   Qrestore(speed,len)
   output(';swap_extruder E=' .. current_e[current_tool] .. '.')
end

function Qretract(speed,len)
  if current_z>retraction_z then
    current_e[current_tool] = current_e[current_tool] - len
    output('G1 F' .. speed .. ' ' .. letter[current_tool] .. ff(current_e[current_tool]))
  end
  return current_e[current_tool]
end

function Qrestore(speed,len)
  if current_z>retraction_z then
    current_e[current_tool] = current_e[current_tool] + len
    output('G1 F' .. speed .. ' ' .. letter[current_tool] .. ff(current_e[current_tool]))
  end
  return current_e[current_tool]
end

function retract(tool,e)
  speed = priming_mm_per_sec * 60
  len = filament_priming_mm[current_tool]
  return Qretract(speed,len)
end

function prime(tool,e)
  speed = priming_mm_per_sec * 60
  len   = filament_priming_mm[current_tool]
  return Qrestore(speed,len)
end

function move_xyz(x,y,z)
  if z == current_z then
    output('G0 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y))
  else
    output('G0 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  current_e[current_tool] = e
  if z == current_z then
    output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' ' .. letter[current_tool] .. ff(e))
  else
    output('G1 X' .. f(x-bed_origin_x) .. ' Y' .. f(y-bed_origin_y) .. ' Z' .. f(z) .. ' ' .. letter[current_tool] .. ff(e))
    current_z = z
  end
end

function move_e(e)
  current_e[current_tool] = e
  output('G1 ' .. letter[current_tool] .. ff(e))
end

function set_feedrate(feedrate)
  if current_frate == feedrate then
    --do nothing
    --output(';set_feetrate called with unchanged value')
  else
    output('G1 F' .. feedrate)
    current_frate = feedrate
  end
end

function extruder_start()
  --not implemented with sailfish
  --output('M101')
end

function extruder_stop()
  --not implemented with sailfish
  --output('M103')
end

function progress(percent)
  output('M73 P' .. percent)
end
