name_en = "PLA"
name_fr = "PLA"
name_es = "PLA"

bed_temp_degree_c = 60

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 220
  _G['filament_priming_mm_'..i] = 6.5
  _G['priming_mm_per_sec_'..i] = 40
  _G['retract_mm_per_sec_'..i] = 40
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 0.98
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
