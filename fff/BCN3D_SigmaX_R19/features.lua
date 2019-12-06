-- BCN3D SigmaX R19 profile
-- Bedell Pierre 30/10/2019

-- ##############################
-- Sigma special modes management
-- ##############################
mirror_mode = false
duplicate_mode = false

-- Custom checkoxes to enable special modes
--add_checkbox_setting('mirror_mode', 'Mirror Printing mode', 'Enable the Mirror Printing mode')
--add_checkbox_setting('duplicate_mode', 'Duplicate Printing mode', 'Enable the Duplicate Printing mode')

smart_purge = false
-- Custom checkbox for "smart purge"
add_checkbox_setting('smart_purge', 'Smart Purge', 'Enable Smart Purge at each extruder change')

if mirror_mode == true then duplicate_mode = false end
if duplicate_mode == true then mirror_mode = false end

-- #####################
-- Build Area dimensions
-- #####################
bed_size_x_mm = 420
bed_size_y_mm = 297
bed_size_z_mm = 210

if mirror_mode == true or duplicate_mode == true then
  bed_size_x_mm = bed_size_x_mm / 2
end

-- #################
-- Printer Extruders
-- #################
extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 2.85

-- ###################
-- Retraction Settings
-- ###################
filament_priming_mm = 6.50
priming_mm_per_sec = 40

-- ###################
-- Layer height limits
-- ###################
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.8

-- ############################
-- Printing temperatures limits
-- ############################
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 240

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- #####################
-- Printing speed limits
-- #####################
print_speed_mm_per_sec = 50
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 100

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 30

travel_speed_mm_per_sec = 80
travel_speed_mm_per_sec_min = 60
travel_speed_mm_per_sec_max = 120

-- ######################################
-- Settings affectation for each extruder
-- ######################################
-- Extruder 0
nozzle_diameter_mm_0 = nozzle_diameter_mm
filament_diameter_mm_0 = filament_diameter_mm
filament_priming_mm_0 = filament_priming_mm
extruder_temp_degree_c_0 = extruder_temp_degree_c
-- Extruder 1
nozzle_diameter_mm_1 = nozzle_diameter_mm
filament_diameter_mm_1 = filament_diameter_mm
filament_priming_mm_1 = filament_priming_mm
extruder_temp_degree_c_1 = extruder_temp_degree_c

-- ###############################
-- Swaping extruders Misc settings
-- ###############################
-- Purge Tower
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0
tower_brim_num_contours = 12

extruder_swap_zlift_mm = 0.2
extruder_swap_retract_length_mm = 6.5
extruder_swap_retract_speed_mm_per_sec = 30.0

enable_active_temperature_control = true

-- ######################################################
-- Internal procedure to fill brushes / extruder settings
-- ######################################################
for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
