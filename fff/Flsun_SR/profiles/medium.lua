name_en = "Standard quality"
name_fr = "Qualité standard"
name_es = "Calidad estándar"

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 150
perimeter_print_speed_mm_per_sec = 75
cover_print_speed_mm_per_sec = 70
first_layer_print_speed_mm_per_sec = 35
travel_speed_mm_per_sec = 180

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['num_shells_' ..i] = 3
  _G['print_perimeter_'..i] = true
  _G['cover_thickness_mm_'..i] = 0.8
  _G['infill_percentage_'..i] = 20
end
