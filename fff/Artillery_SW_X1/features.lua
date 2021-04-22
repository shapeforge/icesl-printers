-- Artillery SideWinder X1 Profile
-- Alexandre Brugnoni (alexandre.brugnoni@ensa-nancy.fr)
-- 22/04/2021

bed_size_x_mm = 310
bed_size_y_mm = 310
bed_size_z_mm = 400
nozzle_diameter_mm = 0.4

enable_z_lift = true
z_lift_mm = 0.5

extruder_count = 1

z_offset   = 0.0

priming_mm_per_sec = 45

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = 1

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 120

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i = 0, max_number_extruders, 1 do
  _G['filament_diameter_mm_'..i] = 1.74
  _G['filament_priming_mm_'..i] = 2.2 -- 0.8 for direct drive extruder
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
