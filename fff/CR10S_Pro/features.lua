-- Creality CR10S pro
-- 30/07/2020

-- Custom checkbox to enable auto_bed_leveling
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Leveling','Use G29 Auto Leveling if the machine is equipped with one (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = false

-- Custom checkbox to enable auto_bed_leveling
add_checkbox_setting('reload_bed_mesh', 'Reload the last bed-mesh','Reload the last saved bed-mesh if available')
reload_bed_mesh = false

-- Custom checkbox to use a driect-drive extruder (ie: E3D's Hemera)
--add_checkbox_setting('direct_drive', 'Extruder in direct-drive',"Use proper retraction distances for a direct-drive extruder (ie E3D's Hemera)")
direct_drive = false

--#################################################

-- Build Area dimensions
bed_size_x_mm = 310
bed_size_y_mm = 310
bed_size_z_mm = 400

-- Printer Extruder
extruder_count = 1 -- number of extruders. Change this value if you want to use the virtual extruders feature for "simple multi-material" (using firmware's filament swap)
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- Retraction Settings
-- between 0.5mm and 0.8mm of retract/prime for direct-drive setup, between 3mm and 6mm for bowden (stock) setup
if direct_drive then
  filament_priming_mm = 0.4 
else
  filament_priming_mm = 5.0
end
priming_mm_per_sec = 45
retract_mm_per_sec = 45

-- Layer height
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.90

-- Printing temperatures
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speeds
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 200

perimeter_print_speed_mm_per_sec = 45
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 150

cover_print_speed_mm_per_sec = 45
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 200

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 60

travel_speed_mm_per_sec = 180
travel_speed_mm_per_sec_min = 5
travel_speed_mm_per_sec_max = 200

-- Misc default settings
add_brim = true
brim_distance_to_print_mm = 2.0
brim_num_contours = 3

travel_straight = true
enable_z_lift = true
z_lift_mm = 0.4

-- default filament infos (when using "custom" profile)
name_en = "PLA"
filament_density = 1.25 --g/cm3 PLA

--#################################################

-- Internal procedure to fill brushes / extruder settings
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
