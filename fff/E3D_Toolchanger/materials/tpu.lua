name_en = "TPU"
name_es = "TPU"
name_fr = "TPU"

filament_density = 1.21 --g/cm3

bed_temp_degree_c = 55

filament_priming_mm = 2.2

--Special speeds for TPU
print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 25
cover_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec = 20

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 235
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = 40
  _G['retract_mm_per_sec_'..i] = 40
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 1.05
	_G['speed_multiplier_'..i] = 1.05
end

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
