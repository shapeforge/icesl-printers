-- Flashforge Creator Pro profile
-- Bedell Pierre 24/10/2019

-- #####################
-- Build Area dimensions
-- #####################
bed_size_x_mm = 227
bed_size_y_mm = 148
bed_size_z_mm = 150

-- ##################
-- Extruders Settings
-- ##################
extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- extruders offset
extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0
extruder_offset_x[1] =  33.0
extruder_offset_y[1] =   0.0

-- ###################
-- Retraction Settings
-- ###################
filament_priming_mm = 3.0
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

-- ######################################################
-- Internal procedure to fill brushes / extruder settings
-- ######################################################
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
