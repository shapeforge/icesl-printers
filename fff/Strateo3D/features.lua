-- EmotionTech Strateo3D profile
-- Bedell Pierre 21/07/2020

-- #####################
-- Build Area dimensions
-- #####################
bed_size_x_mm = 600
bed_size_y_mm = 420
bed_size_z_mm = 495

-- #################
-- Printer Extruders
-- #################
-- Note: Extruder 0 is on the right, Extruder 1 is on the left
extruder_count = 2
nozzle_diameter_mm = 0.6
filament_diameter_mm = 1.75

-- ###################
-- Retraction Settings
-- ###################
filament_priming_mm = 1.50
priming_mm_per_sec = 20
retract_mm_per_sec = 20

-- ###################
-- Layer height limits
-- ###################
z_layer_height_mm = 0.3
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.8

-- ############################
-- Printing temperatures limits
-- ############################
extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

chamber_temp_degree_c = 0
chamber_temp_degree_c_min = 0
chamber_temp_degree_c_max = 110

-- #####################
-- Printing speed limits
-- #####################
print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 100

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 30

travel_speed_mm_per_sec = 100
travel_speed_mm_per_sec_min = 60
travel_speed_mm_per_sec_max = 200

-- #####################
-- Acceleration settings
-- #####################
-- Use with caution ! IceSL doesn't manage acceleations by itself !
-- The accelerations/jerk will only be managed in a simple/restricted way directly by the profile 
-- (depending on the path type) .  
--add_checkbox_setting(internal_name, description, tooltip, default)
acc_tooltip = 'Enable Acceleration & Jerk Control\n\n'
acc_tooltip = acc_tooltip .. 'Use with caution!\n'
acc_tooltip = acc_tooltip .. 'IceSL doesn\'t manage accelerations and jerk by itself!\n\n'
acc_tooltip = acc_tooltip .. 'The accelerations/jerk will only be managed\n'
acc_tooltip = acc_tooltip .. 'in a simple/restricted way directly by the profile\n'
acc_tooltip = acc_tooltip .. '(depending on the path type).'
add_checkbox_setting('enable_acc', 'Enable Acceleration Control', acc_tooltip, false)

default_acc = 1500 -- mm/s²
perimeter_acc = 1000 -- mm/s²
infill_acc = 1500 -- mm/s²
travel_acc = 1500 -- mm/s²

default_jerk = 25.0 -- mm/s
perimeter_jerk = 10.0 -- mm/s
infill_jerk = 25.0 -- mm/s
travel_jerk = 30.0 -- mm/s

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
extruder_swap_retract_length_mm = 6.5
extruder_swap_retract_speed_mm_per_sec = 25.0

-- brim
add_brim = true
brim_distance_to_print = 1.0
brim_num_contours = 3

-- misc
process_thin_features = false

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
