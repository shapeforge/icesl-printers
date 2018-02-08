version = 1

bed_size_x_mm = 360
bed_size_y_mm = 320
bed_size_z_mm = 320
nozzle_diameter_mm = 0.4

extruder_count = 9
extruder_offset_x = {}
extruder_offset_y = {}

for i = 0, extruder_count-1 do
  extruder_offset_x[i] =  0.0
  extruder_offset_y[i] =  0.0
end

extruder_swap_at_location = true
extruder_swap_location_x_mm = 330
extruder_swap_location_y_mm = 320

gen_tower = false
tower_side_x_mm = 0
tower_side_y_mm = 0
tower_brim_num_contours = 0

enable_active_temperature_control = false

z_offset   = 0.0

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

fan_speed_multiplier = 1.0 -- between 0 and 1

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 4.0
  _G['extruder_temp_degree_c_' ..i] = 220
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
