version = 2

bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 160
nozzle_diameter_mm = 0.4

extruder_count = 1
nb_nozzle_in = 3 -- number of inputed filament in the nozzle

z_offset   = 0.0

priming_mm_per_sec = 100

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120
bed_temp_degree_c = 50

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 6.0
  _G['extruder_temp_degree_c_' ..i] = 190
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 3
end

add_checkbox_setting('auto_bed_leveling', 'Auto Bed Levelling sensor','Auto Levelling Sensor (BLTouch, Pinda, capacitive sensor, etc.)')

add_setting('filament_diameter_A','Filament diameter extruder A',1.0,2.0)
filament_diameter_A = 1.75

add_setting('filament_diameter_B','Filament diameter extruder B',1.0,2.0)
filament_diameter_B = 1.75

add_setting('filament_diameter_C','Filament diameter extruder C',1.0,2.0)
filament_diameter_C = 1.75

-- default parameters
print_speed_mm_per_sec = 10
perimeter_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec = 10
print_speed_microlayers_mm_per_sec = 40
travel_speed_mm_per_sec = 80
add_brim = false
gen_shield = true
extruder_purge_volume_mm3 = 10
shield_distance_to_part_mm = 2
mixing_shield_speed_multiplier = 1
filament_priming_mm_0 = 6
travel_max_length_without_retract = 1
extruder_swap_zlift_mm = 0
flow_dampener_path_length_end_mm = 6
flow_dampener_path_length_start_mm = 6
flow_dampener_e_length_mm = 6
print_kickback_length_mm = 0
mixing_wipe_length_mm = 0
enable_fit_single_path = true
path_width_speed_adjustement_exponent = 1
