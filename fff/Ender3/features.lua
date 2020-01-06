-- Ender 3 Profile
-- Bedell Pierre 27/10/2018

-- Build Area dimensions
bed_size_x_mm = 220
bed_size_y_mm = 220
bed_size_z_mm = 250

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm_0 = 1.75

z_offset   = 0.0

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Retraction Settings
filament_priming_mm_0 = 6.0
priming_mm_per_sec = 25

-- Printing temperatures limits
extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 200

perimeter_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 200

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 120

-- Misc default settings
add_brim = true
brim_distance_to_print = 1.0
brim_num_contours = 4

process_thin_features = false

-- Custom checkox to enable auto_bed_leveling
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Leveling','Use G29 Auto Leveling if the machine is equipped with one (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = false

--#################################################

-- Internal procedure to fill brushes / extruder settings
for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm_0
  _G['filament_priming_mm_'..i] = filament_priming_mm_0
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = extruder_count
end
