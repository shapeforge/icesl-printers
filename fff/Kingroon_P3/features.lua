-- Kingroon P3 Profile
-- Alexandre Brugnoni (alexandre.brugnoni@ensa-nancy.fr)
-- 22/04/2021

bed_size_x_mm = 180
bed_size_y_mm = 180
bed_size_z_mm = 180

extruder_count = 1
nozzle_diameter_mm = 0.25
filament_diameter_mm = 1.75
z_offset = 0.0

filament_priming_mm = 2.0
priming_mm_per_sec = 30
retract_mm_per_sec = 30

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 45
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 100

fan_speed_percent = 70

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
