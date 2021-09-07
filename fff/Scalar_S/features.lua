bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 200

extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
z_offset   = 0.0

filament_priming_mm = 1.2
priming_mm_per_sec = 50
retract_mm_per_sec = 50

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm /2

extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 10
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 10
perimeter_print_speed_mm_per_sec_max = 60

cover_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec_min = 10
cover_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 30
first_layer_print_speed_mm_per_sec_min = 10
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 120

----------------- Adavanced features-------------------
-- Cooling (static + progressive) --
add_checkbox_setting('override_cooling_fan', 'Progressive Cooling', " ")
add_setting('fan_speed_max_percent', 'Progressive Cooling max fan speed (%)', 0, 100, " ")
add_setting('fan_speed_min_percent', 'Progressive Cooling min fan speed (%)', 0, 100, " ")
add_setting('fan_speed_start_at_layer', 'Progressive Cooling starts at layer', 0, 1000, " ")
add_setting('fan_speed_max_at_layer', 'Progressive Cooling max speed at layer', 0, 1000, " ")

override_cooling_fan = false
fan_speed_max_percent = 100
fan_speed_min_percent = 30
fan_speed_start_at_layer=1
fan_speed_max_at_layer=3

-- Auto bed leveling --
ABL_LEFT_PROBE_BED_POSITION = 40
ABL_RIGHT_PROBE_BED_POSITION = 150
ABL_FRONT_PROBE_BED_POSITION = 10
ABL_BACK_PROBE_BED_POSITION = 185

-- Incrementaal bed leveling --
add_checkbox_setting('enable_g29_incremental_bed_leveling', 'Incremental bed leveling', " ")
add_setting('g29_margin', 'Incremental bed leveling Margin', 0, 100, " ")

enable_g29_incremental_bed_leveling = true
g29_margin = 5

-- Zfade --
add_checkbox_setting('enable_ZFade', 'Z Fade', " ")
add_setting('ZFade_height', 'Z Fade Height', 0, 100, " ")

enable_ZFade = false;
ZFade_height = 2.0

--Vertical Lift when retracting
add_checkbox_setting('enable_vertical_lift', 'Lift on retraction', " ")
add_setting('retract_vertical_lift', 'Lift on retraction Height', 0,2, " ")

enable_vertical_lift = false
retract_vertical_lift = 0.15

for i = 0, max_number_extruders, 1 do
  _G['nozzle_diameter_mm_'..i] = nozzle_diameter_mm
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = priming_mm_per_sec
  _G['retract_mm_per_sec_'..i] = retract_mm_per_sec
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
