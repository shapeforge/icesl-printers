name_en = "Fast print"
name_es = "Impresión rápida"
name_fr = "Impression rapide"
name_ch = "快速打印"

z_layer_height_mm = 0.3

print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec = 10
perimeter_print_speed_mm_per_sec = 40
travel_speed_mm_per_sec = 80
priming_mm_per_sec = 30

add_raft = false
raft_spacing = 1.0

gen_supports = false
support_extruder = 0

add_brim = true
brim_distance_to_print = 1.0
brim_num_contours = 4

process_thin_features = false

extruder_0 = 0
infill_extruder_0 = 0
extruder_1 = 1
infill_extruder_1 = 1

for i = 0, max_number_extruders, 1 do
  _G['num_shells_' .. i] = 0
  _G['cover_thickness_mm_' .. i] = 0.6
  _G['print_perimeter_' .. i] = true
  _G['infill_percentage_' .. i] = 15
  _G['flow_multiplier_' .. i] = 1.0
  _G['speed_multiplier_' .. i] = 1.0
end
