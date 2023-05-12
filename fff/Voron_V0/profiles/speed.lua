name_en = "Speed"

-- These settings are based on 247Printing's settings for a quality 3DBenchy
-- as presented on his comparaison testing
-- https://youtu.be/D8GQlliYrZ4?t=628

-- Speeds in mm/s
-- Perimeters: 320
-- External perimeters: 225
-- Infill: 350
-- Top solid infill: 175
-- 1st layer: 150?
-- Travels: 400?

-- Accelerations in mm/s²
-- Perimeters: 8500
-- Infill: 10000
-- 1st layer: 2000
-- Default: 8500

z_layer_height_mm = 0.25

print_speed_mm_per_sec = 350
first_layer_print_speed_mm_per_sec = 150
perimeter_print_speed_mm_per_sec = 225
cover_print_speed_mm_per_sec = 120
travel_speed_mm_per_sec = 400

-- affecting settings to all brushes
for i = 0, max_number_brushes, 1 do
  _G['print_perimeter_'..i] = true
  _G['num_shells_' ..i] = 1
  _G['cover_thickness_mm_'..i] = 0.75
  _G['infill_percentage_'..i] = 10
end

enable_z_lift = false
