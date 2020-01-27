-- Original Prusa MK2S
-- 13/09/2018

-- Build Area dimensions
bed_size_x_mm = 250
bed_size_y_mm = 210
bed_size_z_mm = 200

-- Printer Extruder
extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm_0 = 1.75
filament_linear_adv_factor = 0 -- default

-- Retraction Settings
filament_priming_mm_0 = 0.8 -- min 0.5 - max 2
priming_mm_per_sec = 35

enable_z_lift = true
z_liftmm = 0.6

-- Layer height limits
z_layer_height_mm = 0.2
z_layer_height_mm_min = nozzle_diameter_mm * 0.10
z_layer_height_mm_max = nozzle_diameter_mm * 0.90

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 50
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 45
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 180

--#################################################

-- Internal procedure to fill brushes / extruder settings

for i = 0, 63 ,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm_0
  _G['filament_priming_mm_'..i] = filament_priming_mm_0
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
