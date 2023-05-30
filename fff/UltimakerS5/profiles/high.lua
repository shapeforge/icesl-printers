name_en = "High quality"
name_es = "Alta calidad"
name_fr = "Haute qualité"
name_ch = "高质量"

z_layer_height_mm = 0.1

print_speed_mm_per_sec = 30
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 20
cover_print_speed_mm_per_sec = 20
travel_speed_mm_per_sec = 120

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 2
  _G['cover_thickness_mm_'..i] = 1.2
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 20
end

process_thin_features = false
