-- Printer dimmensions
bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 160

-- Printer Extruder
filament_diameter = 1.75
nozzle_diameter_mm = 0.4
extruder_count = 5 -- number of separated virtual extruders (to affect a color to a brush)
nb_filament_in = 5 -- number of inputed filament in the nozzle

z_offset   = 0.0

enable_active_temperature_control = false
gen_shield = false

-- Purge tower settings
gen_tower = true
tower_side_x_mm = 25.0
tower_side_y_mm = 20.0
tower_brim_num_contours = 5

-- Default Retraction Settings
filament_priming_mm = 6
priming_mm_per_sec = 100

-- Layer height settings
z_layer_height_mm = 0.3
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Printing speed settings
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

-- Printing temperatures settings
extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 250

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Cooling settings
enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = nb_filament_in
end


add_checkbox_setting('auto_bed_leveling', 'Auto Bed Levelling sensor','Auto Levelling Sensor (BLTouch, Pinda, capacitive sensor, etc.)')

-- default parameters
print_speed_mm_per_sec = 10
perimeter_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec = 10
print_speed_microlayers_mm_per_sec = 40
travel_speed_mm_per_sec = 80
add_brim = true
extruder_purge_volume_mm3 = 10
shield_distance_to_part_mm = 2
mixing_shield_speed_multiplier = 1
filament_priming_mm_0 = 6
travel_max_length_without_retract = 5
extruder_swap_zlift_mm = 0
extruder_swap_retract_length_mm = 0
flow_dampener_path_length_end_mm = 6
flow_dampener_path_length_start_mm = 6
flow_dampener_e_length_mm = 6
print_kickback_length_mm = 0
mixing_wipe_length_mm = 0
enable_fit_single_path = true
path_width_speed_adjustement_exponent = 1
