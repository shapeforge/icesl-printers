name_en = "Draft"
name_es = "Impresión rapidísima"
name_fr = "Impression très rapide"

z_layer_height_mm = 0.25

print_speed_mm_per_sec = 270
first_layer_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec = 250
cover_print_speed_mm_per_sec = 250
travel_speed_mm_per_sec = 480

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 1.25
  _G['infill_percentage_'..i] = 15
end
