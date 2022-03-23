name_en = "PETG"
name_es = "PETG"
name_fr = "PETG"

bed_temp_degree_c = 70

if direct_drive then
  filament_priming_mm = 0.4
else
  filament_priming_mm = 5.0
end

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 235
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = 45
  _G['retract_mm_per_sec_'..i] = 45
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 1.0
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = true
fan_speed_percent = 20 -- from 20% to 50%
fan_speed_percent_on_bridges = 100
