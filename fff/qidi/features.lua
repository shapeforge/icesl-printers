version = 1

bed_size_x_mm = 225
bed_size_y_mm = 145
bed_size_z_mm = 150
nozzle_diameter_mm = 0.4

extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0

extruder_count = 1

priming_mm_per_sec = 120

z_layer_height_mm_min = 0.1
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 10
perimeter_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 60

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 2.85
  _G['filament_priming_mm_'..i] = 6.50
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
end
