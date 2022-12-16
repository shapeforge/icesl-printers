name_en = "Extra-Fast print"
name_fr = "Impression Ultra-Rapide"
name_es = "Impresión ultrarrápida"

z_layer_height_mm = 0.3

print_speed_mm_per_sec = 150
perimeter_print_speed_mm_per_sec = 110
cover_print_speed_mm_per_sec = 100
first_layer_print_speed_mm_per_sec = 40
travel_speed_mm_per_sec = 180

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 1
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 0.6
  _G['infill_percentage_'..i] = 15
end
