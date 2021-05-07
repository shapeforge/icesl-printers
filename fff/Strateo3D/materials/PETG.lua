name_en = "PETG"
name_es = "PETG"
name_fr = "PETG"
name_ch = "PETG"

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 1.9
  _G['priming_mm_per_sec_'..i] = 25
  _G['retract_mm_per_sec_'..i] = 25
end

bed_temp_degree_c = 85
chamber_temp_degree_c = 0

enable_fan = true
fan_speed_percent = 70
fan_speed_percent_on_bridges = 100
