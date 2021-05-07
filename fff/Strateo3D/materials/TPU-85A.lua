name_en = "TPU-85A"
name_fr = "TPU-85A"
name_es = "TPU-85A"

print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec = 15

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 0.0
  _G['priming_mm_per_sec_'..i] = 25
  _G['retract_mm_per_sec_'..i] = 25
end
for i = 0, max_number_brushes, 1 do
  _G['flow_multiplier_'..i] = 1.40
  _G['shell_flow_multiplier_'..i] = 1.40
  _G['speed_multiplier_'..i] = 1.40
end

bed_temp_degree_c = 40
chamber_temp_degree_c = 0

enable_fan = true
fan_speed_percent = 50
fan_speed_percent_on_bridges = 100
