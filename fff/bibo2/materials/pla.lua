name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"
name_ch = "PLA"

for i=0,63,1 do
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 210
end

bed_temp_degree_c = 50

fan_speed_multiplier = 1.0 -- between 0 and 1
