name_en = "Fast print"
name_es = "Impresión rápida"
name_fr = "Impression rapide"
name_ch = "快速打印"

z_layer_height_mm = 0.25

print_speed_mm_per_sec = 70
first_layer_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec = 50
travel_speed_mm_per_sec = 150

pressure_adv = 0.05

for i = 0, max_number_brushes, 1 do
  _G['extruder_'..i] = i
  _G['infill_extruder_'..i] = i
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 0.75
  _G['print_perimeter_'..i] = true
  _G['infill_percentage_'..i] = 10
  _G['flow_multiplier_'..i] = 1.0
  _G['speed_multiplier_'..i] = 1.0
end

if mirror_mode == true or duplicate_mode == true then
  apply_restrictions()
end
