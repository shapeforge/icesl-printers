name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"
name_ch = "PLA"

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 210
  _G['filament_priming_mm_'..i] = 1.4
  _G['priming_mm_per_sec_'..i] = 25
end

bed_temp_degree_c = 60
chamber_temp_degree_c = 60

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
