bed_size_x_mm = 214
bed_size_y_mm = 186
bed_size_z_mm = 160

extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =  0.0
extruder_offset_y[0] =  0.0
extruder_offset_x[1] =  0.0
extruder_offset_y[1] =  0.0

filament_priming_mm = 4.0
priming_mm_per_sec = 40
retract_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 235
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 100
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 30
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 20
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 80

fan_speed_multiplier = 1.0 -- between 0 and 1

gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0
tower_brim_num_contours = 12

tower_at_location = true
tower_location_x_mm = bed_size_x_mm / 2 - 15
tower_location_y_mm = bed_size_y_mm / 2 - 15

enable_active_temperature_control = false

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
