name_en = "High quality"
name_es = "Alta calidad"
name_fr = "Haute qualité"
name_ch = "高质量"

z_layer_height_mm = 0.1

print_speed_mm_per_sec = 45
first_layer_print_speed_mm_per_sec = 10
perimeter_print_speed_mm_per_sec = 15
cover_print_speed_mm_per_sec = 15
travel_speed_mm_per_sec = 80

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 3
  _G['cover_thickness_mm_'..i] = 1.0
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 20
  _G['flow_multiplier_'..i] = 1.0
  _G['speed_multiplier_'..i] = 1.0
end

if mirror_mode == true or duplicate_mode == true then
  apply_restrictions()
end
