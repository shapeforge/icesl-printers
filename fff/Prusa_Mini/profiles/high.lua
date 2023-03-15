name_en = "High quality"
name_fr = "Haute qualité"
name_es = "Alta calidad"

z_layer_height_mm = 0.15

print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec = 40

travel_speed_mm_per_sec = 120

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 2
  _G['cover_thickness_mm_'..i] = 1.2
  _G['infill_percentage_'..i] = 20
end