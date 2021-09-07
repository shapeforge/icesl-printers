bed_size_x_mm = 305
bed_size_y_mm = 305
bed_size_z_mm = 610

extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
z_offset = 0.0

filament_priming_mm = 4.0
priming_mm_per_sec = 40
retract_mm_per_sec = 40

z_layer_height_mm_min = 0.01
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

print_speed_mm_per_sec = 50
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 300

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 120

tower_at_location = true
tower_location_x_mm = bed_size_x_mm
tower_location_y_mm = bed_size_y_mm

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
