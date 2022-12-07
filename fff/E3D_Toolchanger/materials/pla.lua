name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"

filament_density = 1.25 --g/cm3

bed_temp_degree_c = 55

filament_priming_mm = 0.4


-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 210
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = 45
  _G['retract_mm_per_sec_'..i] = 45
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 0.95
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100
