version = 2

-- custom settings in the UI
tooltip_z_caching = 'G1 commands will not emit Z when it does not change\nthe only effect is having a smaller gcode file'
tooltip_xy_caching = 'G1 commands will not emit X and Y when they do not change\nthe only effect is having a smaller gcode file'
tooltip_qidi_z_offset = 'Z axis offset [mm]\nfixed extra distance between nozzle and heated bed\nand can be either positive or negative'
tooltip_qidi_z_extra_height = 'Z height inflation [%]\ndoes not affect extruded volume and act a Z height multiplier:\nFinal Z height = Z height * 0.01 (Z height inflation)\ncan be positive or negative and the effect is kind of similar to flow multiplier\n(flow multiplier affects flow and leaves Z height untouched, here is the opposite)'
tooltip_qidi_retract_after_z = 'Minimum Z height for retraction [mm]\nRetraction will happen only for higher Z values\nuseful to disable retractions for the first layer(s)\nQuality should not be affected but adhesion should be better (depending on the number of retractions)'
tooltip_extruder_e_restart = 'Extra extrusion distance [mm]\napplied after each retract, can be positive or negative\nuseful to remove respectively voids or blobs caused by retractions'

add_checkbox_setting('z_caching', 'Enable Z caching', tooltip_z_caching)
add_checkbox_setting('xy_caching', 'Enable XY caching', tooltip_xy_caching)
add_setting('qidi_z_offset', 'Z axis offset [mm]', -0.1, 2, tooltip_qidi_z_offset)
add_setting('qidi_z_extra_height', 'extra Z inflation [%] (not affecting flow) ', -50, 50, tooltip_qidi_z_extra_height)
add_setting('qidi_retract_after_z', 'minimum Z height for retraction [mm]', 0, 1, tooltip_qidi_retract_after_z)
add_setting('extruder_e_restart', 'extra restart distance after retraction [mm]', -1, 1, tooltip_extruder_e_restart)

-- default values for the custom settings ...could be added at the end of the add_setting commands
z_caching = true  -- GCODE dimensions reduced by default
xy_caching = true  -- GCODE dimensions reduced by default
qidi_z_offset = 0.0  --extra distance between build plate and head on first layer
                             --  it does not affect the layer height or extruded amount
qidi_z_extra_height = 0.0  -- Z inflation/compression applied on each layer. Useful for tuning purposes if
                              -- the layers need to be squeezed or spaced more to get better quality
                              --  it does not affect the layer height or extruded amount
                              -- it's a very similar setting to extrusion flow multiplier
qidi_retract_after_z = 0.0  -- retract only after this height
                             --  retraction on the first layer can result in adhesion problems
                             --  not having retraction on the first layer doesn't USUALLY affect print quality
extruder_e_restart = 0.0 -- extra restart distance to fix eventual blobs or voids due to retraction
                          -- can be positive or negative: positive useful to fix voids, negative to fix blobs

-- slicing algorithm settings
xy_mm_per_pixels = 0.05
xy_max_deviation_mm = 0.05
tile_size_mm = 30

-- geometric settings for printer
bed_size_x_mm = 230
bed_size_y_mm = 145
bed_size_z_mm = 150

-- nozzle & extruder settings
nozzle_diameter_mm = 0.4
extruder_count = 2
extruder_swap_at_location = false
extruder_swap_retract_length_mm = 3.0
extruder_swap_retract_speed_mm_per_sec = 60.0
extruder_offset_x = {}      --configured on the printer
extruder_offset_y = {}
extruder_offset_x[0] =   0.0
extruder_offset_y[0] =   0.0
-- extruder_offset_x[1] =  34.0
-- extruder_offset_y[1] =   0.0

-- prime tower setting
gen_tower = false
tower_side_x_mm = 10.0
tower_side_y_mm = 5.0

-- calibration settings
calibre_x = 0.0 
calibre_y = 0.0 

-- various default option settings
enable_curved_covers_0 = false
enable_curved_covers_1 = false
enable_curved_covers_2 = false
enable_curved_covers_3 = false
priming_mm_per_sec = 120

z_layer_height_mm_min = 0.1
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 80

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 80

first_layer_print_speed_mm_per_sec = 25
first_layer_print_speed_mm_per_sec_min = 5
first_layer_print_speed_mm_per_sec_max = 60

for i=0,63,1 do -- default parameters for newly created extruders
  _G['filament_diameter_mm_'..i] = 1.75
  _G['filament_priming_mm_'..i] = 1.5
  _G['extruder_temp_degree_c_' ..i] = extruder_temp_degree_c_0
  _G['extruder_temp_degree_c_'..i..'_min'] = 150
  _G['extruder_temp_degree_c_'..i..'_max'] = 270
  _G['extruder_mix_count_'..i] = 1
end