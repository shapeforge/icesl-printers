name_en = "High quality"
name_es = "Alta calidad"
name_fr = "Haute qualité"
name_ch = "高质量"

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 30
cover_print_speed_mm_per_sec = 30
travel_speed_mm_per_sec = 100

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 1.4
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 20
  _G['flow_multiplier_'..i] = 1.0
  _G['speed_multiplier_'..i] = 1.0
end
