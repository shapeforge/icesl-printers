version = 1

bed_size_x_mm = 284.2
bed_size_y_mm = 301.88
bed_size_z_mm = 200
nozzle_diameter_mm = 0.35

extruder_count = 1

z_offset   = 0.0

tool0_offset_x = -10.0
tool0_offset_y = -10.0

tool1_offset_x = -72.95
tool1_offset_y = -12.05

tool2_offset_x = -29.35
tool2_offset_y = -37.7

tool3_offset_x = -52.18
tool3_offset_y = -38.35

tool4_offset_x = -41.6
tool4_offset_y = -37.66

-- add these offsets to recenter on plate
offset_x = -60.0
offset_y = 0.0

-- http://support.ordsolutions.com/support/discussions/topics/1000023841

-- Bed size
-- X: 284.2
-- Y: 301.88

-- Print Center
-- X: 142.1
-- Y: 150.94

-- Extruder 1 Offset
-- X: 10
-- Y: 10

-- Extruder 2 Offset
-- X: 72.95
-- Y: 12.05

-- Extruder 3 Offset
-- X: 29.35
-- Y: 37.7

-- Extruder 4 Offset
-- X: 52.18
-- Y: 38.35

-- Extruder 5 Offset
-- X: 41.6
-- Y: 37.66

priming_mm_per_sec = 40

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 210
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end
