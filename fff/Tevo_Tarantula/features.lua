bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 200

extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
z_offset = 0.0

filament_priming_mm = 5.0
priming_mm_per_sec = 60
retract_mm_per_sec = 60

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 60

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 60

cover_print_speed_mm_per_sec = 30
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 60

travel_speed_mm_per_sec = 100

enable_fit_single_path = true
path_width_speed_adjustment_exponent = 2.0

lin_advance_k = 0 -- set to 0 to disable

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

