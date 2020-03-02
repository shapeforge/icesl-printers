bed_size_x_mm = 305
bed_size_y_mm = 305
bed_size_z_mm = 610

nozzle_diameter_mm = 0.4

extruder_count = 2
tower_at_location = true
tower_location_x_mm = bed_size_x_mm
tower_location_y_mm = bed_size_y_mm

z_offset   = 0.0

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.01
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 300

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 4.0
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
