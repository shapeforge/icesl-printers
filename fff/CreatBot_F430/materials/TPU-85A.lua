name_en = "TPU-85A"
name_fr = "TPU-85A"
name_es = "TPU-85A"

for i = 0, extruder_count-1, 1 do
  _G['extruder_temp_degree_c_'..i] = 240
  _G['filament_priming_mm_'..i] = 0
  _G['priming_mm_per_sec_'..i] = 30
  _G['retract_mm_per_sec_'..i] = 30
end

enable_fan = true
fan_speed_percent = 100
fan_speed_percent_on_bridges = 100

print_speed_mm_per_sec = 25
perimeter_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec = 15

flow_multiplier_0 = 1.40
speed_multiplier_0 = 1.40
