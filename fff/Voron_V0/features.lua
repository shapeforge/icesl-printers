-- Voron V0 Profile
-- Hugron Pierre-Alexandre 29/06/2021

-- Build Area dimensions
bed_size_x_mm = 120
bed_size_y_mm = 120
bed_size_z_mm = 120

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- Retraction Settings
filament_priming_mm = 3.0
priming_mm_per_sec = 30
retract_mm_per_sec = 30

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.80

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 290

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 80
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 300

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 300

first_layer_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 100

travel_speed_mm_per_sec = 200
travel_speed_mm_per_sec_min = 20
travel_speed_mm_per_sec_max = 500

-- Misc default settings
add_brim = true
brim_distance_to_print = 2.0
brim_num_contours = 3
z_lift_mm = 0.4

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
