version = 2

bed_size_x_mm = 210
bed_size_y_mm = 210
bed_size_z_mm = 205

nozzle_diameter_mm = 0.4

extruder_count = 1

offset_x = 0
offset_y = 21.6

calibre_x =  0.0 -- -0.1 --  0.08;  -0.05
calibre_y =  0.0 -- 0.24 --    0.25;  0.25

tool0_offset_x = 0.0
tool0_offset_y = 0.0

tool1_offset_x = 0.0
tool1_offset_y = 21.6

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.1
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
  _G['filament_diameter_mm_'..i] = 2.85
  _G['filament_priming_mm_'..i] = 6.0
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
