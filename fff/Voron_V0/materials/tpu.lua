name_en = "TPU"
name_es = "TPU"
name_fr = "TPU"

filament_density = 1.21 --g/cm3

-- temperatures
extruder_temp_degree_c = 235
bed_temp_degree_c = 55

-- prime/retracts
filament_priming_mm = 0
priming_mm_per_sec = 30
retract_mm_per_sec = 50

-- flow
flow_multiplier = 1.0
speed_multiplier = 1.0

-- cooling
enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

--#################################################

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = extruder_temp_degree_c
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = priming_mm_per_sec
  _G['retract_mm_per_sec_'..i] = retract_mm_per_sec
end

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
	_G['flow_multiplier_'..i] = flow_multiplier 
	_G['speed_multiplier_'..i] = speed_multiplier
end