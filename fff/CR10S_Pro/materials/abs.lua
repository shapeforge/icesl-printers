name_en = "ABS-ASA"
name_es = "ABS-ASA"
name_fr = "ABS-ASA"

filament_density = 1.04 --g/cm3

bed_temp_degree_c = 110

if direct_drive then
  filament_priming_mm = 0.4
else
  filament_priming_mm = 5.0
end

-- affecting settings to each extruder
extruder_temp_degree_c = 240
filament_priming_mm = filament_priming_mm
priming_mm_per_sec = 45
retract_mm_per_sec = 45

flow_multiplier = 0.97
speed_multiplier = 1.0

enable_fan = false
fan_speed_percent = 50
fan_speed_percent_on_bridges = 50
