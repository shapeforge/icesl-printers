name_en = "Standard quality"
name_es = "Calidad estándar"
name_fr = "Qualité standard"

-- These settings are based on Voron's recommended printing settings
-- https://docs.vorondesign.com/sourcing.html#print-settings

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 120
first_layer_print_speed_mm_per_sec = 40
perimeter_print_speed_mm_per_sec = 60
cover_print_speed_mm_per_sec = 120
travel_speed_mm_per_sec = 200

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 3
  _G['cover_thickness_mm_'..i] = 2.0
  _G['infill_percentage_'..i] = 35
end
