name_en = "Ultra High quality"
name_es = "Alta calidad"
name_fr = "Trés Haute qualité"

z_layer_height_mm = 0.06

print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec = 20
cover_print_speed_mm_per_sec = 30
travel_speed_mm_per_sec = 160

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 3
  _G['cover_thickness_mm_'..i] = 1.8
  _G['infill_percentage_'..i] = 30
end
