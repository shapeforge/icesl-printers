name_en = "Fast print"
name_fr = "Impression rapide"
name_es = "Impresión rápida"

z_layer_height_mm = 0.3

print_speed_mm_per_sec = 80
perimeter_print_speed_mm_per_sec = 60
cover_print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20

travel_speed_mm_per_sec = 180

add_raft = false
raft_spacing = 1.0

gen_supports = false
support_extruder = 0

add_brim = true
brim_distance_to_print_mm = 1.0
brim_num_contours = 4

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['extruder_' .. i] = 0
  _G['num_shells_' .. i] = 1
  _G['cover_thickness_mm_' .. i] = 0.6
  _G['infill_percentage_' .. i] = 20
  _G['print_perimeter_' .. i] = true
end

procees_thin_features = false
