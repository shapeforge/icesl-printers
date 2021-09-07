name_en = "Standard quality"
name_es = "Calidad estándar"
name_fr = "Qualité standard"
name_ch = "标准质量"

z_layer_height_mm = 0.2

print_speed_mm_per_sec = 60
first_layer_print_speed_mm_per_sec = 20
perimeter_print_speed_mm_per_sec = 40
cover_print_speed_mm_per_sec = 40
travel_speed_mm_per_sec = 150

pressure_adv = 0.09

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 0.8
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 15
  _G['flow_multiplier_'..i] = 1.0
  _G['speed_multiplier_'..i] = 1.0
end

if mirror_mode == true or duplicate_mode == true then
  apply_restrictions()
end
