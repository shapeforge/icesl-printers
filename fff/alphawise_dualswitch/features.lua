-- Alphawise with filament switching procedure using "virtual extruders"

bed_size_x_mm = 300
bed_size_y_mm = 300
bed_size_z_mm = 200

extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

filament_priming_mm = 6.0
priming_mm_per_sec = 40
retract_mm_per_sec = 40

extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

gen_tower = false

tower_at_location = true
tower_location_x_mm = 90
tower_location_y_mm = 140
tower_side_x_mm = 50.0
tower_side_y_mm = 20.0
tower_brim_num_contours = 5

extruder_swap_retract_length_mm = 200.0
extruder_swap_retract_speed_mm_per_sec = 90.0

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

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
