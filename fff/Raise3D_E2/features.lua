-- Raise 3D E2 profile
-- Bedell Pierre 02/02/2021

-- ########################
-- Special modes management
-- ########################
mirror_mode = false
duplication_mode = false

-- Custom checkoxes to enable special modes
--add_checkbox_setting('mirror_mode', 'Mirror Printing mode', 'Enable the Mirror Printing mode')
--add_checkbox_setting('duplication_mode', 'Duplicate Printing mode', 'Enable the Duplicate Printing mode')

if mirror_mode == true then duplication_mode = false end
if duplication_mode == true then mirror_mode = false end

-- function to force every brush to have only one extruder (for mirror & duplication mode)
function apply_restrictions()
  for i = 0, max_number_brushes, 1 do
    _G['extruder_'..i] = 0
    _G['infill_extruder_'..i] = 0
  end
end

-- #####################
-- Build Area dimensions
-- #####################
bed_size_x_mm = 365
bed_size_y_mm = 240
bed_size_z_mm = 240

-- #################
-- Printer Extruders
-- #################
extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- ###################
-- Retraction Settings
-- ###################
filament_priming_mm = 0.50
priming_mm_per_sec = 40
retract_mm_per_sec = 40

-- ###################
-- Layer height limits
-- ###################
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.8

-- ############################
-- Printing temperatures limits
-- ############################
extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 300

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

-- #####################
-- Printing speed limits
-- #####################
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 100

perimeter_print_speed_mm_per_sec = 50
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 50
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 30

travel_speed_mm_per_sec = 150
travel_speed_mm_per_sec_min = 60
travel_speed_mm_per_sec_max = 200

-- #####################
-- Acceleration settings
-- #####################
use_acc_jerk_settings = false
default_acc = 800 -- mm/s²
perimeter_acc = 800 -- mm/s²
infill_acc = 800 -- mm/s²
travel_acc = 1500 -- mm/s²

default_jerk = 5.00 -- mm/s
perimeter_jerk = 5.00 -- mm/s
infill_jerk = 5.00 -- mm/s
travel_jerk = 5.00 -- mm/s

-- #############
-- Misc settings
-- #############
-- Purge Tower
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0
tower_brim_num_contours = 12

-- extruder swap behaviour
enable_active_temperature_control = true
extruder_swap_zlift_mm = 0.2
extruder_swap_retract_length_mm = 10.0
extruder_swap_retract_speed_mm_per_sec = 20.0

-- brim
add_brim = true
brim_distance_to_print_mm = 1.0
brim_num_contours = 4

-- flow management
enable_flow_management =  false

-- flow override
emable_flow_override = false
flow_override = 96 --  default value as PLA !

-- pressure advance
pressure_adv = 0.09

-- misc
process_thin_features = false

if mirror_mode == true or duplication_mode == true then
  bed_size_x_mm = bed_size_x_mm / 2
  apply_restrictions()
end

-- #############################################
-- Procedure to fill brushes / extruder settings
-- #############################################
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

apply_restrictions()
