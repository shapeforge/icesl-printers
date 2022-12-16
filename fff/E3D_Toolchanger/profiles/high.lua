name_en = "High quality"
name_es = "Alta calidad"
name_fr = "Haute qualité"

z_layer_height_mm = 0.12

print_speed_mm_per_sec = 70
perimeter_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec = 20
travel_speed_mm_per_sec = 120

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 3
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 1.2
  _G['infill_percentage_'..i] = 20
end
