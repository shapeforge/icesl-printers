bed_size_x_mm = 195
bed_size_y_mm = 195
bed_size_z_mm = 205
nozzle_diameter_mm = 0.4

extruder_count = 1

z_offset   = 0.0

priming_mm_per_sec = 50

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 100

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 0

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.74
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 235
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end

