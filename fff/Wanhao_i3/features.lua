--Wanhao Duplicator i3
--13.11.2017 Colin Hudson

bed_size_x_mm = 200
bed_size_y_mm = 200
bed_size_z_mm = 180

extruder_count = 1
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
z_offset = 0.0

filament_priming_mm = 4.0
extra_length_on_prime = 0.05   -- similar to slic3r feature; usually set to either 0, or some other small value. Tries to make up for the material lost by oozing during a travel move
priming_mm_per_sec = 40        --  default retraction speed; overwritten by the gui settings
retract_mm_per_sec = 40
priming_speed_pct = 20         -- reduce the prime speed after the retraction to x percent of the retract speed

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

extruder_temp_degree_c = 210
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 270

bed_temp_degree_c = 50
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

print_speed_mm_per_sec = 40
print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

perimeter_print_speed_mm_per_sec = 30
perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

travel_speed_mm_per_sec = 100

-- Values for rudimentary fan control
-- Really needs to know when when bridging is occurring
-- Also should be a material setting but placing these values at the material level does not seem to work

-- Fan speed 0..255
default_fan_speed = 128
first_layer_flag = -1000 -- a magic value

-- Control the fan speed by adjusting based on the amount of filament extruded in the previous layer
-- Should not turn on the cooling fan in header.gcode
-- {filament_extruded, fan speed}
fan_speed = {
  {first_layer_flag, 0}, -- first layer fan speed
  {10, 255}, -- if 10mm or less was extruded then set the fan speed to 255
  {20, 155} -- if extrusion was >10 but less than 20 set the fan speed to 155
} -- otherwise use the default_fan_speed

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
