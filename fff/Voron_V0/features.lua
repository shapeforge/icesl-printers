-- Voron V0 Profile
-- Hugron Pierre-Alexandre 29/06/2021
-- Updated by Bedell Pierre 05/10/2022

-- Custom checkbox to use Klipper's strat/stop macros
add_checkbox_setting('use_klipper_start_stop_macros', "Use Klipper's start/stop macros", "Use Klipper's macros to start/stop the print instead of the classic gcode header/footer")
use_klipper_start_stop_macros = false

-- Klipper macros names for start/stop
macro_start = "START_PRINT"
macro_stop = "END_PRINT"

-- Custom checkbox to use a direct-drive extruder (for most V0.1)
--add_checkbox_setting('direct_drive', 'Extruder in direct-drive',"Use proper retraction distances for a direct-drive extruder (for most V0.1)")
direct_drive = false

--#################################################

-- Build Area dimensions
bed_size_x_mm = 120
bed_size_y_mm = 120
bed_size_z_mm = 120

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.80

-- Retraction Settings
-- between 0.5mm and 0.8mm of retract/prime for direct-drive setup (V0.1), 
-- between 1mm and 3mm for bowden (V0) setup
if direct_drive then
  filament_priming_mm = 0.4 
else
  filament_priming_mm = 2.0
end
priming_mm_per_sec = 30
retract_mm_per_sec = 50

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

-- Acceleration settings
-- max settings are provided for reference only, as they should remain as set up on the machine
-- x_max_speed = 500 -- mm/s
-- y_max_speed = 500 -- mm/s
-- z_max_speed = 20 -- mm/s
-- e_max_speed = 30 -- mm/s

-- x_max_acc = 20000 -- mm/s²
-- y_max_acc = 20000 -- mm/s²
-- z_max_acc = 500 -- mm/s²
-- e_max_acc = 5000 -- mm/s²

default_acc = 8500 -- mm/s²
--e_prime_max_acc = 5000 -- mm/s²
perimeter_acc = 5000 -- mm/s²
infill_acc = 8500 -- mm/s²
first_layer_acc = 2000 -- mm/s²

-- default_jerk = 9 -- mm/s

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

-- Custom checkox to enable per-path acceleration control
add_checkbox_setting('use_per_path_accel', 'Uses Per-Path Acceleration', 'Manage Accelerations depending of the current path type')
use_per_path_accel = true

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
