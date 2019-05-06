version = 2

-- custom settings in the UI
tooltip_verbose_ON = 'enables comments to identify function calls inside the GCODE\n can be turned off smaller GCODE files'
tooltip_low_motor_current = 'forces low motor current mode:\nactivates M906 E400 in order to set motor current at 400mA\ninstead of the default 650mA.\nThis is especially good for low temperature PLA or\nany material subject to heat creep'
tooltip_CompHeaderActiveExtRectraction = 'compensates header retraction on active extruder:\n- if enabled then the print starts with the active extruder\nexactly at E=0 (material should be exactly at nozzle end)\n- if disabled then the retraction happened during header is not compensated\nand thus there will be less oozing at start but there could be lack of material\n\nIT IS BEST TO KEEP IT DISABLED IF BRIM OR SKIRT ARE USED'
tooltip_z_caching = 'G1 commands will not emit Z when it does not change\nthe only effect is having a smaller gcode file'
tooltip_xy_caching = 'G1 commands will not emit X and Y when they do not change\nthe only effect is having a smaller gcode file'
tooltip_z_offset = 'Z axis offset [mm]\nfixed extra distance between nozzle and heated bed\nand can be either positive or negative'
tooltip_z_extra_height = 'Z height inflation [%]\ndoes not affect extruded volume and act a Z height multiplier:\nFinal Z height = Z height * 0.01 (Z height inflation)\ncan be positive or negative and the effect is kind of similar to flow multiplier\n(flow multiplier affects flow and leaves Z height untouched, here is the opposite)'
tooltip_retract_after_z = 'Minimum Z height for retraction [mm]\nRetraction will happen only for higher Z values\nuseful to disable retractions for the first layer(s)\nQuality should not be affected but adhesion should be better (depending on the number of retractions)'
tooltip_extra_extruder_e_restart = 'Extra extrusion distance [mm]\napplied after each retract, can be positive or negative\nuseful to remove respectively voids or blobs caused by retraction\nAPPLIED TO BOTH EXTRUDERS'
tooltip_extra_extruder_e_swap_restart = 'Extra extrusion distance [mm]\napplied after each retract, can be positive or negative\nuseful to remove respectively voids or blobs caused by extruder swap\nAPPLIED TO BOTH EXTRUDERS'
tooltip_swap_length_multi = 'swap retraction/priming multiplier\nThis value is multiplied by the priming length\nenables a custom retraction length on extruder swap\nAPPLIED TO BOTH EXTRUDERS'

add_checkbox_setting('verbose_ON', 'Enables comment lines in the gcode file', tooltip_verbose_ON)
add_checkbox_setting('low_motor_current', 'Forces low extruder motor current', tooltip_low_motor_current)
add_checkbox_setting('CompHeaderActiveExtRectraction', 'Compensate header retraction on active extruder', tooltip_CompHeaderActiveExtRectraction)
add_checkbox_setting('z_caching', 'Enable Z caching', tooltip_z_caching)
add_checkbox_setting('xy_caching', 'Enable XY caching', tooltip_xy_caching)
add_setting('z_offset', 'Z axis offset [mm]', -0.1, 2, tooltip_z_offset)
add_setting('z_extra_height', 'extra Z inflation [%] (not affecting flow) ', -50, 50, tooltip_z_extra_height)
add_setting('retract_after_z', 'minimum Z height for retraction [mm]', 0, 1, tooltip_retract_after_z)
add_setting('extra_extruder_e_restart', 'extra restart distance after retraction [mm]', -1, 1, tooltip_extra_extruder_e_restart)
add_setting('extra_extruder_e_swap_restart', 'extra restart distance after extruder swap [mm]', -2, 2, tooltip_extra_extruder_e_swap_restart)
add_setting('swap_length_multi','swap retraction/priming multiplier',0,10,tooltip_swap_length_multi)

-- default values for the custom settings ...could be added at the end of the add_setting commands
verbose_ON = true -- enabled by default since GCODE file dimensions should not be an issue
low_motor_current = false  -- not enabled by default as it can be enabled from printer settings
CompHeaderActiveExtRectraction = false -- not compensating header retraction on active extruder
z_caching = true  -- GCODE dimensions reduced by default
xy_caching = false  -- GCODE dimensions reduced by default
z_offset = 0.0  --extra distance between build plate and head on first layer
                             --  it does not affect the layer height or extruded amount
z_extra_height = 0.0  -- Z inflation/compression applied on each layer. Useful for tuning purposes if
                              -- the layers need to be squeezed or spaced more to get better quality
                              --  it does not affect the layer height or extruded amount
                              -- it's a very similar setting to extrusion flow multiplier
retract_after_z = 0.0  -- retract only after this height
                             --  retraction on the first layer can result in adhesion problems
                             --  not having retraction on the first layer doesn't USUALLY affect print quality
extra_extruder_e_restart = 0.0 -- extra restart distance to fix eventual blobs or voids due to retraction
                          -- can be positive or negative: positive useful to fix voids, negative to fix blobs
extra_extruder_e_swap_restart = 0.0 -- extra restart distance to fix eventual blobs or voids due to extruder swap
                          -- can be positive or negative: positive useful to fix voids, negative to fix blobs
swap_length_multi = 3 -- on extruder swap, a retraction 3 times bigger than normal is usually enough

-- slicing algorithm settings
xy_mm_per_pixels = 0.05
xy_max_deviation_mm = 0.05
tile_size_mm = 30

-- geometric settings for printer
bed_size_x_mm = 305
bed_size_y_mm = 305
bed_size_z_mm = 300

-- nozzle & extruder settings
nozzle_diameter_mm = 0.4
extruder_count = 2

-- prime tower and swap setting
gen_tower = false
tower_brim_num_contours = 5
tower_side_x_mm = 10
tower_side_y_mm = 10
extruder_swap_at_location = true
extruder_swap_location_x_mm = bed_size_x_mm - 10 - tower_side_x_mm - tower_brim_num_contours * nozzle_diameter_mm
extruder_swap_location_y_mm = bed_size_y_mm - 10 - tower_side_y_mm - tower_brim_num_contours * nozzle_diameter_mm

-- various default option settings
support_print_speed_mm_per_sec = 50

enable_curved_covers_0 = false
enable_curved_covers_1 = false
enable_curved_covers_2 = false
enable_curved_covers_3 = false
priming_mm_per_sec = 30

z_offset   = 0.0
z_layer_height_mm_min = 0.01
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 300

bed_temp_degree_c = 55
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 110

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 10
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 80

for i=0,63,1 do
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 4.0
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c_0
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 285
  _G['extruder_mix_count_'..i] = 1
end
