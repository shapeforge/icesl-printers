name_en = "Standard quality"
name_es = "Calidad estándar"
name_fr = "Qualité standard"

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 60
perimeter_print_speed_mm_per_sec = 35
cover_print_speed_mm_per_sec = 35
first_layer_print_speed_mm_per_sec = 20
travel_speed_mm_per_sec = 150

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 1
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 1.0
  _G['infill_percentage_'..i] = 20
end
