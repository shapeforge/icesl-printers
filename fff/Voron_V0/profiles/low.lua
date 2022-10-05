name_en = "Fast print"
name_es = "Impresión rápida"
name_fr = "Impression rapide"

z_layer_height_mm = 0.3

print_speed_mm_per_sec = 100
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 50
cover_print_speed_mm_per_sec = 50
travel_speed_mm_per_sec = 200

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 0.9
  _G['infill_percentage_'..i] = 10
end
