name_en = "TPU-85A"
name_fr = "TPU-85A"
name_es = "TPU-85A"

bed_temp_degree_c = 50

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 230
  _G['filament_priming_mm_'..i] = 6.0
  _G['priming_mm_per_sec_'..i] = 45
  _G['retract_mm_per_sec_'..i] = 45
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 1.25
	_G['speed_multiplier_'..i] = 1.25
end

print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec = 15

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
