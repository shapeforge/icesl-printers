-- LulzBot TAZ 6 Single Extruder
-- Cloned from generic reprap and borrowed from numerous others
-- (the load order is features first, then profiles, then materials)
--
-- 2019-06-07 Brad Morgan              Initial Release

bed_size_x_mm = 280
bed_size_y_mm = 280
bed_size_z_mm = 250

nozzle_diameter_mm = 0.5

extruder_count = 1

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120
bed_temp_degree_c     = 45

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i = 0, max_number_extruders, 1 do
  _G['filament_diameter_mm_'..i] = 2.85
  _G['filament_priming_mm_'..i] = 6.50
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
