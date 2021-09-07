-- Original Prusa Mini
-- 23/10/2020

-- Build Area dimensions
bed_size_x_mm = 180
bed_size_y_mm = 180
bed_size_z_mm = 180

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4 -- 0.25, 0.4, 0.6
filament_diameter_mm = 1.75
filament_linear_adv_factor = 0 -- default

-- Retraction Settings
filament_priming_mm = 3.2
priming_mm_per_sec = 50
retract_mm_per_sec = 50

enable_z_lift = true
z_lift_mm = 0.2

-- Layer height
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.90

-- Printing temperatures
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speeds
print_speed_mm_per_sec = 60
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 120

perimeter_print_speed_mm_per_sec = 45
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 45
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 180

-- Acceleration settings
x_max_speed = 180 -- mm/s
y_max_speed = 180 -- mm/s
z_max_speed = 12 -- mm/s
e_max_speed = 80 -- mm/s

x_max_acc = 1250 -- mm/s²
y_max_acc = 1250 -- mm/s²
z_max_acc = 400 -- mm/s²
e_max_acc = 5000 -- mm/s²
ex_max_acc = 1250 -- mm/s²
e_prime_max_acc = 1250 -- mm/s²

perimeter_acc = 800 -- mm/s²
infill_acc = 1000 -- mm/s²
default_acc = 1250 -- mm/s²

x_max_jerk = 8.00 -- mm/s
y_max_jerk = 8.00 -- mm/s
z_max_jerk = 2.00 -- mm/s
e_max_jerk = 10.00 -- mm/s

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
