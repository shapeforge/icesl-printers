name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 250
  _G['filament_priming_mm_'..i] = 0.1
  _G['priming_mm_per_sec_'..i] = 40
  _G['retract_mm_per_sec_'..i] = 40
end

bed_temp_degree_c = 100

enable_fan = true
fan_speed_percent = 50
fan_speed_percent_on_bridges = 80

material_flow = 100
