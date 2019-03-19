-- Foldarap Mega 200x200x450

bed_size_x_mm = 200
bed_size_y_mm = 190
bed_size_z_mm = 450

nozzle_diameter_mm = 0.4

extruder_count = 1

z_offset   = 0.0

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 3

print_speed_mm_per_sec_min = 10
print_speed_mm_per_sec_max = 300

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 120

first_layer_print_speed_mm_per_sec = 15
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.74
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end