name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

for i=0,63,1 do
  _G['filament_priming_mm_'..i] = 1.0
  _G['extruder_temp_degree_c_' ..i] = 230
end

bed_temp_degree_c = 110

fan_speed_multiplier = 0.0 -- between 0 and 1
