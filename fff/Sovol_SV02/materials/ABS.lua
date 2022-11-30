name_en = "ABS"
name_fr = "ABS"
name_es = "ABS"

bed_temp_degree_c = 110

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 5.0
  _G['retract_mm_per_sec_'..i] = 50
  _G['priming_mm_per_sec_'..i] = 50
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 0.95 
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = false -- enable fan only if the printer is enclosed !
fan_speed_percent = 10
fan_speed_percent_on_bridges = 80
