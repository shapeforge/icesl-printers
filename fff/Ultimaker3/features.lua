-- Ultimaker 3
-- Sylvain Lefebvre  2017-07-28

-- Build Area dimensions
bed_size_x_mm = 215 -- 233 (max build width) - extruder 1 offset (18)
bed_size_y_mm = 215
bed_size_z_mm = 200 -- 300 for extended

-- Extruders default settings
extruder_count = 2
filament_diameter_mm = 2.85
extruder_temp_degree_c = 210
nozzle_diameter_mm = 0.4

-- Retraction settings
filament_priming_mm = 6.50
priming_mm_per_sec = 40

-- Extruder 0
nozzle_diameter_mm_0 = nozzle_diameter_mm
filament_diameter_mm_0 = filament_diameter_mm
filament_priming_mm_0 = filament_priming_mm
extruder_temp_degree_c_0 = extruder_temp_degree_c

-- Extruder 1
nozzle_diameter_mm_1 = nozzle_diameter_mm
filament_diameter_mm_1 = filament_diameter_mm
filament_priming_mm_1 = filament_priming_mm
extruder_temp_degree_c_1 = extruder_temp_degree_c

-- Extruders offset
extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0
extruder_offset_x[1] = -18.0
extruder_offset_y[1] =   0.0

-- Printing temperatures limits
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 300

bed_temp_degree_c     = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Layer height limits
z_layer_height_mm = 0.2
-- Workaround to fix the layer height limits according to the nozzle diameter
if nozzle_diameter_mm_0 <= nozzle_diameter_mm_1 then
  z_layer_height_mm_min = nozzle_diameter_mm_1 * 0.15
  z_layer_height_mm_max = nozzle_diameter_mm_1 * 0.80
elseif nozzle_diameter_mm_0 >= nozzle_diameter_mm_1 then
  z_layer_height_mm_min = nozzle_diameter_mm_0 * 0.15
  z_layer_height_mm_max = nozzle_diameter_mm_0 * 0.80
else
  z_layer_height_mm_min = nozzle_diameter_mm * 0.15
  z_layer_height_mm_max = nozzle_diameter_mm * 0.80
end
----

-- Purge Tower
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0
tower_brim_num_contours = 12

tower_at_location = true -- Requires extruder to swap material at a given location,
-- this also forces the tower to appear at this same location.
tower_location_x_mm = 201
tower_location_y_mm = 179

extruder_swap_retract_length_mm = 16.0
extruder_swap_retract_speed_mm_per_sec = 30.0

enable_active_temperature_control = true

-- Printing speed limits
print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 120

for i = 0, max_number_extruders, 1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
