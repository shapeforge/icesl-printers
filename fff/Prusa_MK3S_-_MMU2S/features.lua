-- Original Prusa MK3S with MMU2S
-- 2019-05-01

-- Build Area dimensions
bed_size_x_mm = 250
bed_size_y_mm = 210
bed_size_z_mm = 210

-- Printer Extruder
extruder_count = 5
nozzle_diameter_mm = 0.4
filament_diameter_mm_0 = 1.75

-- Layer height limits
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.15
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Retraction Settings
filament_priming_mm = 0.8 -- min 0.5 - max 2
priming_mm_per_sec = 35

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Purge Tower
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 25.0
tower_brim_num_contours = 12

tower_at_location = true -- Sent the tool head to the specified location to swap materials and create the purge tower
purge_tower_offset = 5 -- Offset between the side of the build plate and the purging tower
tower_location_x_mm = bed_size_x_mm - (tower_side_x_mm / 2) - ((tower_brim_num_contours * z_layer_height_mm) * 2) - purge_tower_offset
tower_location_y_mm = bed_size_y_mm - (tower_side_y_mm / 2) - ((tower_brim_num_contours * z_layer_height_mm) * 2) - purge_tower_offset

-- Printing speed limits
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 200

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 200

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 120

-- Misc default settings
add_checkbox_setting('flow_compensation', 'Flow compensation','Prusa-like flow compensation low-layer-height printing.') -- prusa-like flow compensation for low layer height printing
flow_compensation = false

filament_type = 0 -- for M403 command for the MMU2 (0: default; 1:flex; 2: PVA)

add_brim = true
brim_distance_to_print = 1.0
brim_num_contours = 4

process_thin_features = false

curved_covers = false 

--#################################################

-- Internal procedure to fill brushes / extruder settings
for i = 0, max_number_extruders, 1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm_0
  _G['filament_priming_mm_'..i] = filament_priming_mm_0
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
  _G['enable_curved_covers_'..i] = curved_covers
  _G['filament_priming_mm_'..i] = filament_priming_mm
end
