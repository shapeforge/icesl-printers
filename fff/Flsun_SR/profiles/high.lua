name_en = "High quality"
name_fr = "Haute qualité"
name_es = "Alta calidad"

z_layer_height_mm = 0.1

print_speed_mm_per_sec = 100
perimeter_print_speed_mm_per_sec = 60
cover_print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 35
travel_speed_mm_per_sec = 180

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 3
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 1.2
  _G['infill_percentage_'..i] = 35
end
