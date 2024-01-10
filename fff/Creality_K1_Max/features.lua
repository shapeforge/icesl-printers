-- Creality K1 Max based on Seckit Sk-G0 universal profile
-- Hugron Pierre-Alexandre 18/06/2020
-- Updated by Bedell Pierre 30/11/2022
-- Updated by Hugron Pierre-Alexandre 05/12/2023

-- Firmware used : 0 -> Marlin; 1 -> RRF; 2 -> Klipper
firmware = 2

-- support for classic jerk junction deviation
if firmware == 0 then
  classic_jerk = false
end

--Generate gcode thumbnails for klipper, RFF or Marlin
export_gcode_thumbnails = true

-- Build Area dimensions
bed_size_x_mm = 300
bed_size_y_mm = 300
bed_size_z_mm = 300

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4 -- 0.25, 0.4, 0.6
filament_diameter_mm = 1.75
filament_linear_adv_factor = 0.03 

-- Retraction Settings
filament_priming_mm = 0.5 -- min 0.5 - max 2
priming_mm_per_sec = 40
retract_mm_per_sec = 60

-- Layer height
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.90

-- Printing temperatures
extruder_temp_degree_c = 220
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 285

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speeds
print_speed_mm_per_sec = 270
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 400

perimeter_print_speed_mm_per_sec = 200
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 400

cover_print_speed_mm_per_sec = 200
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 400

first_layer_print_speed_mm_per_sec = 80
first_layer_print_speed_mm_per_sec_min = 10
first_layer_print_speed_mm_per_sec_max = 150

travel_speed_mm_per_sec = 500
travel_speed_mm_per_sec_min = 5
travel_speed_mm_per_sec_max = 500

-- Acceleration settings
x_max_speed = 500 -- mm/s
y_max_speed = 500 -- mm/s
z_max_speed = 30 -- mm/s
e_max_speed = 100 -- mm/s

x_max_acc = 20000 -- mm/s²
y_max_acc = 20000 -- mm/s²
z_max_acc = 500 -- mm/s²
e_max_acc = 20000 -- mm/s²

default_acc = 20000 -- mm/s²
e_prime_max_acc = 5000 -- mm/s²
perimeter_acc = 5000 -- mm/s²
infill_acc = 20000 -- mm/s²

default_jerk = 9 -- mm/s
infill_jerk = 20 -- mm/s

-- Misc default settings
add_brim = true
brim_distance_to_print_mm = 2.0
brim_num_contours = 3

enable_z_lift = true
z_lift_mm = 0.4

enable_travel_straight = true

-- default filament infos (when using "custom" profile)
name_en = "PLA"
filament_density = 1.25 --g/cm3 PLA

--#################################################

-- Custom checkbox to enable auto_bed_leveling
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Leveling','Use G29 Auto Leveling if the machine is equipped with one (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = false

-- Custom checkox to enable auto_bed_leveling
add_checkbox_setting('reload_bed_mesh', 'Reload the last bed-mesh','Reload the last saved bed-mesh if available')
reload_bed_mesh = false

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
