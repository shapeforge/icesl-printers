name_en = "Fast print"
name_es = "Impresión rápida"
name_fr = "Impression rapide"
name_ch = "快速打印"

z_layer_height_mm = 0.3

print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 45
cover_print_speed_mm_per_sec = 60
travel_speed_mm_per_sec = 150

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 0
  _G['cover_thickness_mm_'..i] = 0.6
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 15
end

process_thin_features = false

