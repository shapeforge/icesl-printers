name_en = "PETG"
name_es = "PETG"
name_fr = "PETG"
name_ch = "PETG"

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 225
  _G['filament_priming_mm_'..i] = 5.0
  _G['priming_mm_per_sec_'..i] = 25
end

bed_temp_degree_c = 85

enable_fan = true
fan_speed_percent = 90
fan_speed_percent_on_bridges = 100
