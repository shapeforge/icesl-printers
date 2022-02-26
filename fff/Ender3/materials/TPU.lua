name_en = "TPU"
name_es = "TPU"
name_fr = "TPU"

bed_temp_degree_c = 40

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 235
  _G['filament_priming_mm_'..i] = 0.0
  _G['priming_mm_per_sec_'..i] = 25
  _G['retract_mm_per_sec_'..i] = 25
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 1.0
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = true
fan_speed_percent = 50
fan_speed_percent_on_bridges = 100
