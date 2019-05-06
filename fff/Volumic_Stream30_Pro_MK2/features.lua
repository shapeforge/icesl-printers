-- Volumic Stream 30 Pro MK2
-- 2019-03-22

-- Printer dimmensions
bed_size_x_mm = 300
bed_size_y_mm = 200
bed_size_z_mm = 300

-- Printer Extruder
extruder_count = 1
filament_diameter = 1.75
nozzle_diameter_mm = 0.4

z_offset   = 0.0

-- Default Retraction Settings
filament_priming_mm = 2.0
priming_mm_per_sec = 50

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Printing speed limits
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 75
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
