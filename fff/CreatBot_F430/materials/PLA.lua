name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"
name_ch = "PLA"

for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 210
  _G['filament_priming_mm_'..i] = 1.2
  _G['priming_mm_per_sec_'..i] = 30
  _G['retract_mm_per_sec_'..i] = 30
end

bed_temp_degree_c = 50

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

material_guid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9'
