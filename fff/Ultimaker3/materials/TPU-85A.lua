name_en = "TPU-85A"
name_fr = "TPU-85A"
name_es = "TPU-85A"

material_guid = '1d52b2be-a3a2-41de-a8b1-3bcdb5618695'

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 0
  _G['priming_mm_per_sec_'..i] = 40
  _G['retract_mm_per_sec_'..i] = 40
end

for i = 0, max_number_brushes, 1 do
  _G['flow_multiplier_'..i] = 1.40
  _G['shell_flow_multiplier_'..i] = 1.40
  _G['speed_multiplier_'..i] = 1.40
end

bed_temp_degree_c = 50

print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec = 15

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
