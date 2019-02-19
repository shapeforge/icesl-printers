version = 2

-- Printer dimmensions
bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 160

-- Printer Extruder
filament_diameter = 1.75
nozzle_diameter_mm = 0.4
extruder_count = 5 -- number of inputed filament in the nozzle

gen_tower = false
enable_active_temperature_control = false
gen_shield = true

z_offset   = 0.0

-- Default Retraction Settings
filament_priming_mm = 6
priming_mm_per_sec = 50

-- Layer height limits
z_layer_height_mm_min = nozzle_diameter_mm * 0.125
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

-- Printing speed limits
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

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

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = filament_diameter
  _G['filament_priming_mm_'..i] = filament_priming_mm
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c
  _G['extruder_temp_degree_c_'..i..'_min'] = extruder_temp_degree_c_min
  _G['extruder_temp_degree_c_'..i..'_max'] = extruder_temp_degree_c_max
  _G['extruder_mix_count_'..i] = extruder_count
end


add_checkbox_setting('auto_bed_leveling', 'Auto Bed Levelling sensor','Auto Levelling Sensor (BLTouch, Pinda, capacitive sensor, etc.)')

--add_checkbox_setting('filament_diameter_management', 'Manage Filament Diameters','Manage the diameter of your filaments (if you use custum made filaments)')
filament_diameter_management = false

if filament_diameter_management == true then
	add_setting('filament_diameter_A','filament diameter extruder A',1.0,2.0)
	filament_diameter_A = 1.75
	
	add_setting('filament_diameter_B','filament diameter extruder B',1.0,2.0)
	filament_diameter_B = 1.75
	
	add_setting('filament_diameter_C','filament diameter extruder C',1.0,2.0)
	filament_diameter_C = 1.75
	
	add_setting('filament_diameter_D','filament diameter extruder D',1.0,2.0)
	filament_diameter_D = 1.75
	
	add_setting('filament_diameter_H','filament diameter extruder H',1.0,2.0)
	filament_diameter_H = 1.75
end
