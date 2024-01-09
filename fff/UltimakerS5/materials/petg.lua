name_en = "PETG"
name_es = "PETG"
name_fr = "PETG"
name_ch = "PETG"

material_guid = '1cbfaeb3-1906-4b26-b2e7-6f777a8c197a'

bed_temp_degree_c = 85

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 6.50
  _G['priming_mm_per_sec_'..i] = 40
  _G['retract_mm_per_sec_'..i] = 40
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = 0.95
	_G['speed_multiplier_'..i] = 1.0
end

enable_fan = true
fan_speed_percent = 20
fan_speed_percent_on_bridges = 100
