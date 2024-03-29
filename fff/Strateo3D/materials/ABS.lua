name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 250
  _G['filament_priming_mm_'..i] = 0.8
  _G['retract_mm_per_sec_'..i] = 25
  _G['priming_mm_per_sec_'..i] = 20
end

bed_temp_degree_c = 110
chamber_temp_degree_c = 60

enable_fan = true
fan_speed_percent = 10
fan_speed_percent_on_bridges = 80
