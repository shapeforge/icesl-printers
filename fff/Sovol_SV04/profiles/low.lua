name_en = "Fast print"
name_es = "Impresión rápida"
name_fr = "Impression rapide"

z_layer_height_mm = 0.28

print_speed_mm_per_sec = 60
perimeter_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20
travel_speed_mm_per_sec = 150

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 0
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 0.84
  _G['infill_percentage_'..i] = 20
end
