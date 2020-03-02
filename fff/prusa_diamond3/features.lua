-- Common Prusa I3 with Diamond 3 filaments
-- Bedell Pierre 18/07/2019

-- Build Area dimensions
bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 160

-- Printer Extruder
extruder_count = 1 -- number of extruders. If you want to use the virtual extruders feature for "simple multi-material", you can change this number to comply with the number of mixs
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
nb_input = 3 -- number of inputed filament in the nozzle. Maximum supported is 5
extruder_purge_volume_mm3 = 10 -- volume of the needed purge between each material change

-- Retraction Settings
filament_priming_mm = 3.0 -- between 2 and 5mm
priming_mm_per_sec = 100
extruder_swap_retract_mm = filament_priming_mm

-- Layer height limits
z_layer_height_mm = 0.3
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.8

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Printing speed limits
print_speed_mm_per_sec = 20
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 30

travel_speed_mm_per_sec = 80

print_speed_microlayers_mm_per_sec = 40
mixing_shield_speed_multiplier = 1

-- Specific mixing/multi-material settings
travel_max_length_without_retract = 1
extruder_swap_zlift_mm = 0

flow_dampener_path_length_start_mm = 1
flow_dampener_path_length_end_mm = 1
flow_dampener_e_length_mm = 3

-- Misc default settings
enable_fit_single_path = true
path_width_speed_adjustement_exponent = 1

gen_shield = true
shield_distance_to_part_mm = 2

-- diamond_brushes mode (virtual extruders)
if extruder_count > 1 then 
  gen_shield = false

  gen_tower = true
  tower_at_location = false -- Sent the tool head to the specified location to swap materials and create the purge tower
  tower_side_x_mm = 10.0
  tower_side_y_mm = 25.0
  tower_brim_num_contours = 12
  
  purge_tower_offset = 5 -- Offset between the side of the build plate and the purging tower
  if tower_at_location then
    tower_location_x_mm = bed_size_x_mm - (tower_side_x_mm / 2) - ((tower_brim_num_contours * z_layer_height_mm) * 2) - purge_tower_offset
    tower_location_y_mm = bed_size_y_mm - (tower_side_y_mm / 2) - ((tower_brim_num_contours * z_layer_height_mm) * 2) - purge_tower_offset
  end
end

-- Custom checkox to enable auto_bed_leveling
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Leveling','Use G29 Auto Leveling if the machine is equipped with one (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = true

-- Filament diameter management
-- if enabled, custom fields will be created to specify specific diameter for each input
filament_diameter_management = true
--add_checkbox_setting('filament_diameter_management', 'Manage Filament Diameters','Manage the diameter of your filaments (if you use custum made filaments)')

extruder_letters = {"A", "B", "C", "D", "H"} -- array to store extruder letter for the Filament diameter management settings generation

  --filament_diameter = {}
if filament_diameter_management == true then
  for i = 1, nb_input do
    -- generating a new dynamic global to store the filament diameter
    _G['filament_diameter_' .. extruder_letters[i]] = 1.75
    add_setting('filament_diameter_' .. extruder_letters[i], 'Filament diameter extruder ' .. extruder_letters[i], 1.0, 2.0)


    --filament_diameter[i] = filament_diameter_mm
    --add_setting('filament_diameter[' .. i .. ']', 'Filament diameter for extruder ' .. extruder_letters[i], 1.0, 2.0)
    --print(filament_diameter[i])
  end
end

--#################################################

-- Internal procedure to fill brushes / extruder settings
for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = nb_input
end
