-- CreatBot F430 profile
-- Bedell Pierre 07/04/2020

-- #####################
-- Build Area dimensions
-- #####################
bed_size_x_mm = 400
bed_size_y_mm = 300
bed_size_z_mm = 300

-- #################
-- Printer Extruders
-- #################
extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- Extruders offset
extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] = 0.0
extruder_offset_y[0] = 0.0
extruder_offset_x[1] = 72.0
extruder_offset_y[1] = 0.0

-- ###################
-- Retraction Settings
-- ###################
filament_priming_mm = 1.2
priming_mm_per_sec = 30

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
extruder_temp_degree_c_max = 420

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 140

chamber_temp_degree_c = 0
chamber_temp_degree_c_min = 0
chamber_temp_degree_c_max = 70

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

travel_speed_mm_per_sec = 70
travel_speed_mm_per_sec_min = 50
travel_speed_mm_per_sec_max = 180

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

-- #############
-- Misc settings
-- #############
-- Purge Tower
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0
tower_brim_num_contours = 12
-- z_lift
z_lift_mm = 0.2
-- swapping extruder
extruder_swap_zlift_mm = 0.2
extruder_swap_retract_length_mm = 15.0
extruder_swap_retract_speed_mm_per_sec = 30.0

enable_active_temperature_control = true

-- ###############
-- Custom controls
-- ###############
-- Chanber temperature
add_setting("chamber_temp_degree_c", "Temperature of the printing chamber",chamber_temp_degree_c_min, chamber_temp_degree_c_max, "Temperature (Celsius) of the heated chamber", chamber_temp_degree_c)

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
