-- Qidi Avatar IV
-- mm1980 11.12.2017

--
--qidi profile custom variables, can be overwritten by profile.lua and material.lua
--
qidi_swap_extruders = false  --swap extuders
                             --  if false extruder 0=right, 1=left (default)
                             --  if true  extruder 0=left, 1=right
                             --  works when using only one and both extruders
                             --  I have ABS on 0, and PETG on B - no need to to swap materials
qidi_extra_z_distance = 0.0  --extra distance between build plate and head on first layer
                             --  it does not affect the layer height or extuded amount
                             --  it simply increases the gap between plate and head
                             --  I set to 0.1mm for PETG and SoftPLA/TPU
qidi_retract_after_z = 0.2   --retract only after this height
                             --  retraction on the first layer can result in adhesion problems
                             --  not having retraction on the first layer doesn't affect print quality
                             --  I set it to 0.2mm

bed_size_x_mm = 225          --actually it's 240mm but not heated
bed_size_y_mm = 145          --actually it's 150mm but not heated
bed_size_z_mm = 150

extruder_count = 2
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75

extruder_offset_x = {}       --configured on the printer
extruder_offset_y = {}
extruder_offset_x[0] = 0.0
extruder_offset_y[0] = 0.0

filament_priming_mm = 3.0
priming_mm_per_sec = 120    --retraction and prime speed
retract_mm_per_sec = 120

z_layer_height_mm_min = 0.1
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 60

cover_print_speed_mm_per_sec = 30
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 60

travel_speed_mm_per_sec = 100

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
