name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 230
  _G['filament_priming_mm_'..i] = 1.2
  _G['priming_mm_per_sec_'..i] = 30
  _G['retract_mm_per_sec_'..i] = 30
end

bed_temp_degree_c = 110

enable_fan = true
fan_speed_percent = 10
fan_speed_percent_on_bridges = 80

material_guid = '60636bb4-518f-42e7-8237-fe77b194ebe0'
