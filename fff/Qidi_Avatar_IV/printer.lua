-- Qidi Avatar IV
-- mm1980 11.12.2017
-- no retraction while z<=0.2mm (for better adhesion of the first layer)

--variables
current_z = 0		    --Z cache, produce shorter G-code (emit Z only if changed
retraction_z = 0.21 --min z value for retraction (test current_z>retraction_z)
current_tool = 0    --tool index, can be 0 or 1
current_frate = 100	--F cache, produce shorter G-code (emit F only if changed)
current_e = {}		  --extrusion length cache
current_e[0] = 0
current_e[1] = 0

--constants
bed_origin_x = bed_size_x_mm / 2.0  --xy correction
bed_origin_y = bed_size_y_mm / 2.0  --xy correction

--variables imported by features.lua, profile.lua or material.lua
if qidi_swap_extruders == nil then qidi_swap_extruders = false end      --bool, false=normal (T0=A, T1=B), true=swap (T0=B, T1=A)
if qidi_extra_z_distance == nil then qidi_extra_z_distance = 0.0 end    --if >0 it provide extra z space (for SoftPLA/PETG)
if qidi_extra_z_distance<0 then qidi_extra_z_distance=0 end             --do not dive into the bed
if qidi_retract_after_z == nil then qidi_retract_after_z = 0.0 end      --

letter = {}                          --tool code (A for tool 0/right extruder, B for tool 1/left extruder)
if qidi_swap_extruders == false then --normal tool codes
  letter[0] = 'A'	                     --1st extduder letter code
  letter[1] = 'B'	                     --2nd extduder letter code
else                                 --tool codes swapped
  letter[0] = 'B'	                     --1st extduder letter code
  letter[1] = 'A'	                     --2nd extduder letter code
end

filament_priming_mm = {}           		          -- retraction/priming lengths
filament_priming_mm[0] = filament_priming_mm_0 	-- 1st extruder retraction length
filament_priming_mm[1] = filament_priming_mm_1 	-- 2nd extruder retraction length

--code

function comment(text)
  output('; ' .. text)
end

function header()
  output(';(**** QIDI Tech Avatar IV - profile QIDI ****)')
  output(';')

  if qidi_swap_extruders == true then
    output(';(**** SWAPPED T0/A and T1/B ****)')
    output(';')
  end

  if number_of_extruders ~= 1 then
    output(';(**** Multiple extruders: ' .. number_of_extruders .. ' extruders ****)')
    output(';')
  end

  if number_of_extruders == 1 then
    if qidi_swap_extruders == false then
      output(';(**** Filament T0: ' .. filament_tot_length_mm[extruders[0]] .. 'mm ****)')
    else
      output(';(**** Filament T1: ' .. filament_tot_length_mm[extruders[0]] .. 'mm ****)')
    end
  elseif number_of_extruders == 2 then
    if qidi_swap_extruders == false then
      output(';(**** Filament T0: ' .. filament_tot_length_mm[extruders[0]] .. 'mm ****)')
      output(';(**** Filament T1: ' .. filament_tot_length_mm[extruders[1]] .. 'mm ****)')
    else
      output(';(**** Filament T1: ' .. filament_tot_length_mm[extruders[0]] .. 'mm ****)')
      output(';(**** Filament T0: ' .. filament_tot_length_mm[extruders[1]] .. 'mm ****)')
    end
  end
  output(';')

  output(';(**** QIDI Avatar IV ****)')
  output(';(**** startup gcode ****)')
  output(';(**** init ****)')
  output('M136                                ;(enable build progress)')
  output('M73 P0                              ;(set initial build percentage)')
  output('G21                                 ;(set units to mm)')
  output('G90                                 ;(set positioning to absolute)')
  output(';(**** homing ****)')
  output('G162 X Y F2500                      ;(home XY axes maximum)')
  output('G161 Z F1100                        ;(home Z axis minimum)')
  output('G92 X230 Y145 Z-5 A0 B0             ;(set Z to -5)')
  output('G1 X230 Y145 Z0.0                   ;(move Z to "0")')
  output('G161 Z F100                         ;(home Z axis minimum)')
  output('M132 X Y Z                          ;(recall stored home offsets for XYZ axis)')
  if qidi_extra_z_distance > 0 then
    output(';(**** Z=0 correction ****)')
    output(';G92 Z-' .. f(qidi_extra_z_distance) .. '		                ;(extra Z space for PETG and SoftPLA)')
  end
  output(';(**** heating ****)')
  output('G1 X-112.5 Y-72.5 Z50 F1800         ;(move to waiting position)')
  output('G130 X20 Y20 Z20 A20 B20            ;(lower stepper Vrefs while heating)')
  output('M140 S' .. bed_temp_degree_c .. ' T0                        ;(set HBP temperature)')
  output('M6 T0                               ;(wait for HBP to reach temperature)')
  if number_of_extruders == 1 then
    if qidi_swap_extruders == false then
      output('M104 S' .. extruder_temp_degree_c[0] .. ' T0                        ;(set extruder 0 temperature)')
      output('M6 T0                               ;(wait for extruder 0 reach temperature)')
    else
      output('M104 S' .. extruder_temp_degree_c[0] .. ' T1                        ;(set extruder 1 temperature)')
      output('M6 T1                               ;(wait for extruder 1 reach temperature)')
      output('T1                                  ;(select tool 1 (offset calcualtion))')
    end
  elseif number_of_extruders == 2 then
    if qidi_swap_extruders == false then
      output('M104 S' .. extruder_temp_degree_c[0] .. ' T0                        ;(set extruder 0 temperature)')
      output('M104 S' .. extruder_temp_degree_c[1] .. ' T1                        ;(set extruder 1 temperature)')
      output('M6 T0                               ;(wait for extruder 0 reach temperature)')
      output('M6 T1                               ;(wait for extruder 1 reach temperature)')
    else
      output('M104 S' .. extruder_temp_degree_c[0] .. ' T1                        ;(set extruder 1 temperature)')
      output('M104 S' .. extruder_temp_degree_c[1] .. ' T0                        ;(set extruder 0 temperature)')
      output('M6 T1                               ;(wait for extruder 0 reach temperature)')
      output('M6 T0                               ;(wait for extruder 1 reach temperature)')
      output('T1                                  ;(select tool 1 (offset calcualtion))')
    end
  end
  output('G130 X127 Y127 Z40 A127 B127        ;(set stepper motor Vref to defaults)')
  output(';(**** prime ****)')
  if number_of_extruders == 1 then
    output('G1 X-112.5 Y-72.5 Z0.2 F1800 ' .. letter[0] .. '4     ;(push out 4 mm)')
    output('G1 X0 Y-72.5 Z0.2 F1800 ' .. letter[0] .. '4          ;(push out 4 mm and move down half way)')
    output('G1 X112.5 Y-72.5 Z0.2 F1800 ' .. letter[0] .. '8      ;(push out 4 mm and move prime full way)')
  elseif  number_of_extruders == 2 then
    output('G1 X-112.5 Y-72.5 Z0.2 F1800 A4 B4  ;(push out 4 mm)')
    output('G1 X0 Y-72.5 Z0.2 F1800 A4 B4       ;(push out 4 mm and move down half way)')
    output('G1 X112.5 Y-72.5 Z0.2 F1800 A8 B8   ;(push out 4 mm and move prime full way)')
  end
  output('G92 A0 B0                           ;(reset counters after prime)')
  output(';(**** end of startup gcode ****)')
  output(';')
end

function footer()
  output(';(**** end of print gcode ****)')
  output('M140 S0        ;(Set heated bed temperature to 0)')
  output('M104 S0 T0     ;(Set extruder 0 temperature to 0)')
  output('M104 S0 T1     ;(Set extruder 1 temperature to 0)')
  output('M127 T0        ;(Disable cooling fan)')
  output('G1 Z150 F900   ;(Move the platform down)')
  output('G162 X Y F2000 ;(Home X and Y)')
  output('M18 X Y Z      ;(Turn off steppers after a build)')
  output('M18 A B        ;(Turn off A and B steppers)')
  output('M70 P5         ;(Display We <3 Making Things!)')
  output('M72 P1         ;(Play Ta-Da song)')
  output('M73 P100       ;(Set build percentage to 100%)')
  output('M137           ;(build end notification)')
  output(';(**** end of end of print gcode ****)')
end

function layer_start(zheight)
  comment(';(<layer>)')
  if not layer_spiralized then
    output('G0 F100 Z' .. f(zheight) .. ' F3000')
  end
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
  speed = retract_mm_per_sec[extruder] * 60
  len = filament_priming_mm[current_tool]
  return Qretract(speed,len)
end

function prime(tool,e)
  speed = priming_mm_per_sec[extruder] * 60
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
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
end
