--  Vormvrij Lutum 4.6
-- based on Bedell Pierre 27/10/2018
-- Pierre-Alexandre Hugron 17/02/2023

-- Build Area dimensions
bed_size_x_mm = 435
bed_size_y_mm = 460
bed_size_z_mm = 510

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 3
filament_diameter_mm = 3

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.80

-- Retraction Settings
filament_priming_mm = 0.3 
priming_mm_per_sec = 15 
retract_mm_per_sec = 15 

-- need  + 0.1 mm distance after a rectract


-- Printing speed limits
print_speed_mm_per_sec = 70
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 200

perimeter_print_speed_mm_per_sec = 70
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 200

cover_print_speed_mm_per_sec = 70
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 200

first_layer_print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 150

-- Misc default settings
add_brim = true
brim_distance_to_print_mm = 3.0
brim_num_contours = 3
z_lift_mm = 3

process_thin_features = false

-- Custom checkox to enable auto_bed_leveling
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Leveling','Use G29 Auto Leveling if the machine is equipped with one (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = false

--#################################################

