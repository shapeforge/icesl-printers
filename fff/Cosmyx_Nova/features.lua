-- Cosmyx Nova Profile
-- Bedell Pierre 13/12/2022

-- Custom checkbox to use Klipper's strat/stop macros
add_checkbox_setting('use_klipper_start_stop_macros', "Use Klipper's start/stop macros", "Use Klipper's macros to start/stop the print instead of the classic gcode header/footer")
use_klipper_start_stop_macros = false

-- Klipper macros names for start/stop
macro_start = "START_PRINT"
macro_stop = "END_PRINT"

--#################################################

-- Build Area dimensions
bed_size_x_mm = 300
bed_size_y_mm = 200
bed_size_z_mm = 270

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.80

-- Retraction Settings
-- between 0.5mm and 0.8mm of retract/prime for direct-drive setup
filament_priming_mm = 0.8
priming_mm_per_sec = 35
retract_mm_per_sec = 35

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 290

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 120
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 400

perimeter_print_speed_mm_per_sec = 60
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 400

cover_print_speed_mm_per_sec = 120
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 400

first_layer_print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 100

travel_speed_mm_per_sec = 200
travel_speed_mm_per_sec_min = 20
travel_speed_mm_per_sec_max = 500

-- Misc default settings
add_brim = true
brim_distance_to_print_mm = 2.0
brim_num_contours = 3

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
