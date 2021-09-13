-- Dagoma DiscoEasy200
-- Modified by Pierre Bedell, 2019-04-30

-- Build Area dimensions
bed_size_x_mm = 211
bed_size_y_mm = 211
bed_size_z_mm = 205

-- Printer Extruder
extruder_count = 1
filament_diameter = 1.75
nozzle_diameter_mm = 0.4
z_offset = 0.0

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 0

-- Retraction Settings
filament_priming_mm = 3.5 -- for e3dv6 in bowden, retraction length should be between 2 and 5mm
priming_mm_per_sec = 50
retract_mm_per_sec = 50

-- Layer height limits
z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Printing speed limits
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 100

cover_print_speed_mm_per_sec = 30
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 100

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 120

-- Misc default settings
add_brim = true
brim_distance_to_print_mm = 1.0
brim_num_contours = 4

process_thin_features = false

enable_curved_covers_0 = false 

--#################################################

-- Internal procedure to fill brushes / extruder settings
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
