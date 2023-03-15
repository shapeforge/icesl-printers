name_en = "TPU"
name_fr = "TPU"
name_es = "TPU"

filament_linear_adv_factor = 0

-- temperatures
extruder_temp_degree_c = 230
bed_temp_degree_c = 45

-- prime/retracts
filament_priming_mm = 0.8
retract_mm_per_sec = 40
priming_mm_per_sec = 15

-- flow
flow_multiplier = 1.25
speed_multiplier = 1.25

-- cooling
enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

-- speeds
print_speed_mm_per_sec = 35
perimeter_print_speed_mm_per_sec = 35
first_layer_print_speed_mm_per_sec = 25

--#################################################

-- affecting settings to each extruder
for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = extruder_temp_degree_c
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = priming_mm_per_sec
  _G['retract_mm_per_sec_'..i] = retract_mm_per_sec
end
