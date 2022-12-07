name_en = "ABS-ASA"
name_es = "ABS-ASA"
name_fr = "ABS-ASA"

filament_density = 1.04 --g/cm3

bed_temp_degree_c = 110

filament_priming_mm = 0.4

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = 45
  _G['retract_mm_per_sec_'..i] = 45
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 0.91 -- between 0.90 and 0.93 for extrudr ASA
	_G['speed_multiplier_'..i] = 1.0
end


enable_fan = false
fan_speed_percent = 50
fan_speed_percent_on_bridges = 50
