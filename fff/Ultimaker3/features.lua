-- Ultimaker 3
-- Sylvain Lefebvre  2017-07-28

-- Build Area dimensions
bed_size_x_mm = 215 -- 233 (max build width) - extruder 1 offset (18)
bed_size_y_mm = 215
bed_size_z_mm = 200 -- 300 for extended

-- Extruders default settings
extruder_count = 2
filament_diameter_mm = 2.85
-- default nozzle diameter
nozzle_diameter_mm = 0.4
-- specific nozzle diameter (for different printcore use)
-- nozzle and printcore management will be added in a future release
nozzle_diameter_mm_0 = 0.4 -- extruder 0
nozzle_diameter_mm_1 = 0.4 -- extruder 1

-- Extruders offset
extruder_offset_x = {}
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0
extruder_offset_x[1] = -18.0
extruder_offset_y[1] =   0.0

-- Retraction settings
filament_priming_mm = 6.50
priming_mm_per_sec = 40
retract_mm_per_sec = 40

-- Layer height limits
z_layer_height_mm = 0.2
z_layer_height_mm_min = math.min(nozzle_diameter_mm, nozzle_diameter_mm_0, nozzle_diameter_mm_1) * 0.15 -- uses the smallest nozzle as reference
z_layer_height_mm_max = math.max(nozzle_diameter_mm, nozzle_diameter_mm_0, nozzle_diameter_mm_1) * 0.80 -- uses the biggest nozzle as reference

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 300

bed_temp_degree_c     = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

cover_print_speed_mm_per_sec = 30
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 50

travel_speed_mm_per_sec = 120

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

-- Misc Settings
add_brim = true
brim_distance_to_print_mm = 1.0
brim_num_contours = 4

add_raft = false
raft_spacing = 1.0

gen_supports = false
support_extruder = 0

z_lift_mm = 0.6

--#################################################

-- Internal procedure to fill brushes / extruder settings
for i = 0, max_number_extruders, 1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = priming_mm_per_sec
  _G['retract_mm_per_sec_'..i] = retract_mm_per_sec
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end

-- Defaults nozzle_diameter for extruder_count > 2 
for i = 2, max_number_extruders, 1 do
  _G['nozzle_diameter_mm_'..i] = nozzle_diameter_mm
end
