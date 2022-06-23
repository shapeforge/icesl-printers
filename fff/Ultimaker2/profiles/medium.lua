name_en = "Standard quality"
name_es = "Calidad estándar"
name_fr = "Qualité standard"
name_ch = "标准质量"

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 35
cover_print_speed_mm_per_sec = 60
travel_speed_mm_per_sec = 150

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 1.2
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 20
end

process_thin_features = false
