-- Printer dimmensions
bed_size_x_mm = 220
bed_size_y_mm = 220
bed_size_z_mm = 240

-- Printer Extruder
extruder_count = 1
filament_diameter = 1.75
nozzle_diameter_mm = 0.4
z_offset = 0.0

-- Default Retraction Settings
filament_priming_mm = 4
priming_mm_per_sec = 50
retract_mm_per_sec = 50

-- Layer height limits
z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Printing speed limits
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80
cover_print_speed_mm_per_sec_min = 5
cover_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

-- Printing temperatures limits
extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

-- Auto-levelling toggle checkbox
add_checkbox_setting('auto_bed_leveling', 'Auto Bed Levelling sensor','Enable this option if you have any Auto Levelling Sensor (BLTouch, Pinda, capacitive sensor, etc.)')
auto_bed_leveling = false

for i = 0, max_number_extruders, 1 do
  _G['nozzle_diameter_mm_'..i] = nozzle_diameter_mm
  _G['filament_diameter_mm_'..i] = filament_diameter_mm
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['priming_mm_per_sec_'..i] = priming_mm_per_sec
  _G['retract_mm_per_sec_'..i] = retract_mm_per_sec
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = 1
end
