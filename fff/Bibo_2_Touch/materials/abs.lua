name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

for i = 0, max_number_extruders, 1 do
  _G['filament_priming_mm_'..i] = 1.0
  _G['extruder_temp_degree_c_' ..i] = 235
end

bed_temp_degree_c = 100

fan_speed_multiplier = 0.0 -- between 0 and 1
