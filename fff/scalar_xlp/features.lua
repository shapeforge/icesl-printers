version = 2

bed_size_x_mm = 400
bed_size_y_mm = 300
bed_size_z_mm = 300
nozzle_diameter_mm = 0.4

extruder_count = 1

z_offset   = 0.0

priming_mm_per_sec = 50

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm /2

print_speed_mm_per_sec_min = 10
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 10
perimeter_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 30
first_layer_print_speed_mm_per_sec_min = 10
first_layer_print_speed_mm_per_sec_max = 80

----------------- Adavanced features-------------------
-- Cooling (static + progressive) --
override_cooling_fan = false
fan_speed_max_percent = 100
fan_speed_min_percent = 30
fan_speed_start_at_layer=1
fan_speed_max_at_layer=3

-- Auto bed leveling --
ABL_LEFT_PROBE_BED_POSITION = 30
ABL_RIGHT_PROBE_BED_POSITION = 375
ABL_FRONT_PROBE_BED_POSITION = 30
ABL_BACK_PROBE_BED_POSITION = 285

-- Incrementaal bed leveling --
enable_g29_incremental_bed_leveling = true
g29_margin = 5

-- Zfade --
enable_ZFade = false;
ZFade_height = 2.0

--Vertical Lift when retracting
enable_vertical_lift = false
retract_vertical_lift = 0.15


for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 1.2
  _G['extruder_temp_degree_c_' ..i] = 200
  _G['extruder_temp_degree_c_'..i..'_min'] = 190
  _G['extruder_temp_degree_c_'..i..'_max'] = 280
  _G['extruder_mix_count_'..i] = 1
end
