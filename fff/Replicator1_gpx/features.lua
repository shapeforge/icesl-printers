bed_size_x_mm = 230
bed_size_y_mm = 150
bed_size_z_mm = 145
nozzle_diameter_mm = 0.4

extruder_count = 2
extruder_swap_at_location = false
extruder_swap_retract_length_mm = 6.0
extruder_swap_retract_speed_mm_per_sec = 30.0

gen_tower = true
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0

calibre_x = -0.1 -- -0.1 --  0.08;  -0.05
calibre_y =  0.0 -- 0.24 --    0.25;  0.25

extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0
extruder_offset_x[1] =  33.0
extruder_offset_y[1] =   0.0

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
