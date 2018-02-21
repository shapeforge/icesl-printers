version = 2

bed_size_x_mm = 140
bed_size_y_mm = 135
bed_size_z_mm = 100
nozzle_diameter_mm = 0.4

extruder_count = 1

z_offset   = 0.0

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

bed_temp_degree_c = 110
bed_temp_degree_c_min = 90
bed_temp_degree_c_max = 150

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 3.0
  _G['extruder_temp_degree_c_' ..i] = 400
  _G['extruder_temp_degree_c_'..i..'_min'] = 360
  _G['extruder_temp_degree_c_'..i..'_max'] = 450
  _G['extruder_mix_count_'..i] = 1
end
