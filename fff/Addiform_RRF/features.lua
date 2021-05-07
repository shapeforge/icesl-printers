-- RepRapFirmware Configurable Printer Profile (Addiform_RRF) for IceSL
-- created on 2020-APR-20 by Nathan Buxton for Addiform (https://addiform.com)

-- Version 1.0.1

-- features.lua
-- Last modified:
-- Changes for 1.0.1. 2020-JUN-08 NaB
-- File created. 2020-APR-20 NaB

--     This file contains settings to be configured by the user according to their printer.
--     IceSL gives priority to an assignment of print settings according to the following list:
--
--     1. Default IceSL values -- bottom priority
--     2. Printer features (features.lua -- this file)
--     3. Print profile (e.g., fast print, high quality, etc.)
--     4. Material profile (e.g., abs, pla, etc.)
--     5. Lua script (user-made script loaded into IceSL for modelling and other purposes)
--     6. Graphical User Interface (GUI) -- top priority


-- ### Addiform_RRF Additional Settings:
--
--     These custom settings are for additional features built into Addiform_RRF printer.lua.
--     Do not remove them from features.lua unless you intend on modifying printer.lua.
--     To use these additional features, find them in the GUI Custom Settings tab, or change them
--     with a custom profile, material, or IceSL Lua script.
--

-- > Custom Settings:
s3d_debug = true
add_checkbox_setting("s3d_debug","S3D Compatibility","Create S3D-compatibile comments for toolpath visualization,\nas well as path and layer labeling.")

craftware_debug = false
add_checkbox_setting("craftware_debug","CraftWare Path Labeling","Create path labels similar to CraftWare's in place of IceSL\nor S3D style path labels.")

move_debug = false
add_checkbox_setting("move_debug","Movement Diagnostic","Enable diagnostic output of movement in GCode comments.")

function_debug = false
add_checkbox_setting("function_debug","Function Diagnostic","Enable diagnostic output of functions in GCode comments.")


relative_extrusion = true
add_checkbox_setting("relative_extrusion","Relative Extrusion","Create relative extruder movement commands in GCode output.\n\nIf disabled, no extrusion will be generated, since absolute\nextrusion is not yet implemented in this profile.")

volumetric_extrusion = false
add_checkbox_setting("volumetric_extrusion","Volumetric Extrusion","Create volumetric extrusion commands using the per-extruder\nfilament diameters configured in IceSL.\n\nRequires Relative Extrusion to be enabled.")


rrf_3 = true
add_checkbox_setting("rrf_3","RRF Version 3.01+","Generate RRF 3.01+ compatible GCode commands.\n\nCurrently this only affects M207 firmware retraction GCode.")

firmware_retraction = false
add_checkbox_setting("firmware_retraction","Firmware Retraction","Generate firmware retraction G10/G11 commands. Uses retraction\nsettings from GUI to set initial values in M207 command.\n\nNon-zero 'Filament retract' must be set in GUI to produce G10/\nG11 retraction commands!\n\nWhen using RRF Version 3.01 or higher, firmware retraction is\nset on a per-extruder basis. Otherwise, in order to comply\nwith limitations of older RRF versions, only the values from\nthe first-indexed extruder will be used in M207.")

suppress_m207_start = false
add_checkbox_setting("suppress_m207_start","Suppress M207 at Start","Suppress M207 command at start. This allows the user to set\ntheir own M207 firmware retraction parameters elsewhere.")


insert_start_gcode = true
add_checkbox_setting("insert_start_gcode","Insert Start GCode","Insert start.g into GCode output before the first layer has\nstarted.\n\nSettings from the GUI can be passed to the script to create\ntailored GCode.")

insert_startpre_gcode = true
add_checkbox_setting("insert_startpre_gcode","Insert Pre-Start GCode","Insert startpre.g into GCode output before temperatures and\nother options are set.\n\nSettings from the GUI can be passed to the script to create\ntailored GCode.")

insert_end_gcode = true
add_checkbox_setting("insert_end_gcode","Insert End GCode","Insert end.g into GCode output after the print is finished.\n\nSettings from the GUI can be passed to the script to create\ntailored GCode.")

insert_start_temp = true
add_checkbox_setting("insert_start_temp","Set Temperatures at Start","Set tool and bed temperatures at print start.")

wait_start_temp = true
add_checkbox_setting("wait_start_temp","Wait for Temperatures at Start","Wait at start for temperatures to be reached.")

suppress_rrf_tool_macros_at_start = true
add_checkbox_setting("suppress_rrf_tool_macros_at_start","Suppress RRF Tool Macros at Start","Suppress RRF tool change macros at starting tool selection.\n\nSends T* P0.")

suppress_all_tool_selection_at_start = false
add_checkbox_setting("suppress_all_tool_selection_at_start","Suppress All Tool Selections at Start","Allows for manual tool selection in Start GCode.")

suppress_fan_at_start = false
add_checkbox_setting("suppress_fan_at_start","Suppress Fan Command at Start","Allows for manual insertion of fan commands in Start GCode.")


insert_swap_gcode = true
add_checkbox_setting("insert_swap_gcode","Insert Swap GCode","Insert swap.g into GCode output after tool change commands.\nCommands will be executed after the RRF tool change macros.\n\nSettings from the GUI can be passed to the script to create\ntailored GCode.")

insert_swappre_gcode = true
add_checkbox_setting("insert_swappre_gcode","Insert Pre-Swap GCode","Insert swappre.g into GCode output immediately before tools\nare changed. Commands will be executed before the RRF tool\nchange macros.\n\nSettings from the GUI can be passed to the script to create\ntailored GCode.")


suppress_temp_control = true
add_checkbox_setting("suppress_temp_control","Suppress Temp Control at Tool Change","Suppress M116 calls after a tool is selected. This is to give\nfull control to the RRF tool change macros.")

default_standby_temp = 0
add_setting("default_standby_temp","Default Tool Standby Temperature", 0, 500,"Standby temperature for tools if active temperature control\nis not enabled.")


z_movement_speed_mm_per_sec = 7
add_setting("z_movement_speed_mm_per_sec","Z Axis Movement Speed", 0.01, 500,"Movement speed in mm/sec for all Z axis moves.")

e_movement_speed_mm_per_sec = 5
add_setting("e_movement_speed_mm_per_sec","Extruder-Only Movement Speed", 0.001, 100,"Movement speed in mm/sec for all extruder-only moves.")


shell_max_speed_mm_per_sec = 0
add_setting("shell_max_speed_mm_per_sec","Maximum Shell Speed", 0, 500,"Shell paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

infill_max_speed_mm_per_sec = 0
add_setting("infill_max_speed_mm_per_sec","Maximum Infill Speed", 0, 500,"Infill paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

raft_max_speed_mm_per_sec = 0
add_setting("raft_max_speed_mm_per_sec","Maximum Raft Speed", 0, 500,"Raft paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

shield_max_speed_mm_per_sec = 0
add_setting("shield_max_speed_mm_per_sec","Maximum Shield Speed", 0, 500,"Shield paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

tower_max_speed_mm_per_sec = 0
add_setting("tower_max_speed_mm_per_sec","Maximum Tower Speed", 0, 500,"Tower paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

cover_infill_max_speed_mm_per_sec = 0
add_setting("cover_infill_max_speed_mm_per_sec","Maximum Cover Speed", 0, 500,"Cover paths will have their print speed reduced to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

cover_shell_max_speed_mm_per_sec = 0
add_setting("cover_shell_max_speed_mm_per_sec","Maximum Curved Cover Speed", 0, 500,"Curved cover paths will have their print speed reduced to\nthis value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

first_layer_speed_scale_percent = 0
add_setting("first_layer_speed_scale_percent","First Layer Maximum Speed Scale %", 0, 100,"Percentage of the above max speeds to use for the first layer.\nAlso scales perimeter speed and support speed on first layer.\n\nDoes not scale Brim Speed Override nor the default speed for\nthe first layer: 'Print speed on first layer'.\n\nSet to 0 to disable scaling of maximum speeds for first layer.")

brim_override_speed_mm_per_sec = 0
add_setting("brim_override_speed_mm_per_sec","Brim Speed Override", 0, 500,"Brim paths will have their print speed set to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

bridge_override_speed_mm_per_sec = 0
add_setting("bridge_override_speed_mm_per_sec","Bridge Speed Override", 0, 500,"Bridge paths will have their print speed set to this value.\n\nSet to 0 to revert to default speed.\n\nunit: mm/sec")

--
-- ### End of Addiform_RRF Additional Settings.


-- ### Default IceSL GUI Settings:
--
--     Default GUI settings can be removed from features.lua because they can be set by the user,
--     or IceSL will provide defaults. All of the GUI settings below have their default values
--     unless otherwise noted. They are provided for convenience and completeness.
--

-- > Slicing Settings:
z_layer_height_mm = 0.2
--button_optimize_z_layer_height_mm         -- Field that can be set with a button in the GUI.
use_different_thickness_first_layer = false
z_layer_height_first_layer_mm = 0.3         -- Visible if use_different_thickness_first_layer == true.

save_layer_subset = false
first_layer_saved = 0                       -- Visible if save_layer_subset == true.
number_layers_saved = 1                     -- Visible if save_layer_subset == true.

perimeter_print_speed_mm_per_sec = 30
print_speed_mm_per_sec = 40
first_layer_print_speed_mm_per_sec = 20

process_thin_features = false
thickening_ratio = 1.25                     -- Visible if process_thin_features == true.

enable_fit_single_path = true
path_width_speed_adjustment_exponent = 3    -- Visible if enable_fit_single_path == true.


preserve_contour_orientations = true

auto_spiralize = false                      -- IceSL default is true.
auto_spiralize_tolerance_mm = -1            -- Visible if auto_spiralize == true.
--seam_location_field                       -- Field that can be set with a button in the GUI.

-- > Travel Settings:
path_priority_use_default = true
path_priority_perimeter = 3                 -- Visible if path_priority_use_default == false.
path_priority_shell = 4                     -- Visible if path_priority_use_default == false.
path_priority_infill = 2                    -- Visible if path_priority_use_default == false.
path_priority_bridge = 1                    -- Visible if path_priority_use_default == false.

travel_speed_mm_per_sec = 120
travel_max_length_without_retract = 20      -- Visible if travel_straight == false.
retract_inwards_perimeter_end = true
travel_straight = false
travel_avoid_top_covers = false             -- Visible if travel_straight == false.

enable_min_layer_time = false
min_layer_time_sec = 3                      -- Visible if enable_min_layer_time == true.
min_layer_time_method = "Tower"             -- Options are: "Tower", "Shield", and "Function 'wait'". Visible if enable_min_layer_time == true.

enable_z_lift = false
z_lift_mm = 1.0                             -- Visible if enable_z_lift == true.


--     A brush in IceSL is like a process in other slicers. It contains the geometry to print.
--     Brushes, numbered from 0 to max_number_brushes, can have settings specific to them. A suffix
--     '_0' after the variable name specifies which brush the setting applies to. If no suffix is
--     added, the value for all brushes globally is set.
--
--         Examples:
--         extruder = 0             sets the default extruder to use for all brushes to tool ID 0.
--         extruder_0 = 0           sets the default extruder to use for only brush 0 to tool ID 0.
--         extruder_1 = 0           sets the default extruder to use for only brush 1 to tool ID 0.

-- > Brush Settings:
extruder = 0
infill_extruder = 0
num_shells = 1
print_perimeter = true

enable_different_top_bottom_covers = false
cover_thickness_mm = 1.2                    -- Visible if enable_different_top_bottom_covers == false.
cover_thickness_top_mm = 1.2                -- Visible if enable_different_top_bottom_covers == true.
cover_thickness_bottom_mm = 1.2             -- Visible if enable_different_top_bottom_covers == true.
cover_filter_diameter_mm = 0
enable_curved_covers = false

enable_ironing = false
ironing_type = "Zigzag"                     -- Options are: "Zigzag", and "Contour parallel". Visible if enable_ironing == true.
ironing_nb_passes = 2                       -- Visible if enable_ironing == true and ironing_type == "Zigzag".
ironing_speed_mm_per_sec = 20               -- Visible if enable_ironing == true.
ironing_only_top = true                     -- Visible if enable_ironing == true.
ironing_thickness_mm = 0.2                  -- Visible if enable_ironing == true and ironing_only_top == false.
ironing_line_spacing_mm = 0.1               -- Visible if enable_ironing == true.
ironing_z_offset_mm = 0                     -- Visible if enable_ironing == true.
ironing_flow = 0.1                          -- Visible if enable_ironing == true.

fill_tiny_gaps = true
flow_multiplier = 1
shell_flow_multiplier = 1
speed_multiplier = 1

-- Note: It is possible to add a custom infill by writing its specification (see 'README.md' file in 'icesl-infillers' directory).
infill_type = "Default"                     -- Options are: "Default", "Progressive", "Cubic", "Polyfoam", "CircleGrid", "Gyroid", "Honeycomb", "Jigsaw", "SquareGrid", "TriangleGrid", "Voro2D".
infill_percentage = 20                      -- Visible if infill_type == "Default", "Polyfoam", "CircleGrid", "Gyroid", "Honeycomb", "SquareGrid", "TriangleGrid", or "Voro2D".

kgon_min_angle = 45                         -- Visible if infill_type == "Polyfoam".
kgon_norm_alpha = 0.5                       -- Visible if infill_type == "Polyfoam".
kgon_x_shrink = 1                           -- Visible if infill_type == "Polyfoam".
infill_angle = 0                            -- Visible if infill_type == "Polyfoam".
pfoam_min_percentage = 20                   -- Visible if infill_type == "Polyfoam".

max_backtrack_len_mm = 10                   -- Visible if infill_type == "Polyfoam", "CircleGrid", "Gyroid", "Honeycomb", "Jigsaw", "SquareGrid", "TriangleGrid", or "Voro2D".

labeling_mm_per_pixels = 0.01               -- Visible if infill_type == "Jigsaw".
labeling_x_offset_mm = 0                    -- Visible if infill_type == "Jigsaw".
labeling_y_offset_mm = 0                    -- Visible if infill_type == "Jigsaw".

--button_distance_density_field             -- Field that can be set with a button in the GUI.
distance_density_crust_mm = 10              -- Visible if a small icon/button is pressed which is located beside the above button.
distance_density_max_density = 90           -- Visible if a small icon/button is pressed which is located beside the above button.
--button_cover_density_field                -- Field that can be set with a button in the GUI.
cover_density_crust_mm = 1                  -- Visible if a small icon/button is pressed which is located beside the above button.
cover_density_max_density = 90              -- Visible if a small icon/button is pressed which is located beside the above button.


--     An extruder in IceSL is a tool in RRF. In IceSL terms extruder 0 = T0, extruder 1 = T1, etc.
--     Extruders, numbered from 0 to max_number_extruders, can have settings specific to them. A
--     suffix '_0' after the variable name specifies which extruder the setting applies to. If no
--     suffix is added, the value for all extruders globally is set.
--
--         Examples:
--         nozzle_diameter_mm = 0.4     sets the default nozzle diameter for all extruders to 0.4.
--         nozzle_diameter_mm_0 = 0.4   sets the default nozzle diameter for only extruder 0 to 0.4.
--         nozzle_diameter_mm_1 = 0.4   sets the default nozzle diameter for only extruder 1 to 0.4.

-- > Extruder Settings:
nozzle_diameter_mm = 0.4
filament_diameter_mm = 1.75
filament_priming_mm = 0
priming_mm_per_sec = 40
retract_mm_per_sec = 40
extruder_temp_degree_c = 205

extruder_degrees_per_sec = 2                -- Visible if enable_active_temperature_control == true.
idle_extruder_temp_degree_c = 100           -- Visible if enable_active_temperature_control == true.

-- > Supports Settings:
gen_supports = false
support_extruder = 0                        -- Visible if gen_supports == true.
support_print_speed_mm_per_sec = 20         -- Visible if gen_supports == true.
support_flow_multiplier = 1                 -- Visible if gen_supports == true.
support_algorithm = "Wings"                 -- Options are: "Bridges" and "Wings". Visible if gen_supports == true.
support_overhang_overlap_fraction = 0.5     -- Visible if gen_supports == true.
support_max_bridge_len_mm = 5               -- Visible if gen_supports == true.
support_spacing_min_mm = 2                  -- Visible if gen_supports == true.
support_anchor_diameter = 7.2               -- Visible if gen_supports == true.
support_min_connector_height = 2            -- Visible if gen_supports == true.
support_max_connector_height = 8            -- Visible if gen_supports == true.
support_infills = false                     -- Visible if gen_supports == true.

support_wing_min_width = 4                  -- Visible if gen_supports == true and support_algorithm == "Wings".
support_wing_angle = 25                     -- Visible if gen_supports == true and support_algorithm == "Wings".
support_wing_rib_width = 2                  -- Visible if gen_supports == true and support_algorithm == "Wings".

support_pillar_cross_length = 2.5           -- Visible if gen_supports == true and support_algorithm == "Bridges".

--support_interdiction_field                -- Field that can be set with a button in the GUI.
--button_overhangs                          -- Field that can be set with a button in the GUI.

-- > Cavity Settings:
gen_cavity = false
cavity_brush = 0                            -- Visible if gen_cavity == true.
cavity_tearing_method = "Cross"             -- Options are: "Cross" and "Skeletal". Visible if gen_cavity == true.
cavity_num_iterations = 5                   -- Visible if gen_cavity == true.

-- > Adhesion Settings:
bed_temp_degree_c = 110

add_brim = true
brim_distance_to_print_mm = 1               -- Visible if add_brim == true.
brim_num_contours = 4                       -- Visible if add_brim == true.

add_raft = false
raft_spacing = 1                            -- Visible if add_raft == true.

-- > Cooling Settings:
enable_fan = true
enable_fan_first_layer = false              -- Visible if enable_fan == true.
fan_speed_percent = 100                     -- Visible if enable_fan == true.
fan_speed_percent_on_bridges = 100          -- Visible if enable_fan == true.

-- > Shield Settings:
gen_shield = false
shield_distance_to_part_mm = 2              -- Visible if gen_shield == true.
shield_num_contours = 1                     -- Visible if gen_shield == true.
shield_brim_num_contours = 3                -- Visible if gen_shield == true.

-- > Tower Settings:
gen_tower = false
tower_side_x_mm = 10                        -- Visible if gen_tower == true.
tower_side_y_mm = 15                        -- Visible if gen_tower == true.
tower_brim_num_contours = 12                -- Visible if gen_tower == true.

-- > Multi material Settings:
enable_active_temperature_control = false   -- Controls visibility of some extruder settings.

extruder_swap_zlift_mm = 1
extruder_swap_retract_length_mm = 6
extruder_swap_retract_speed_mm_per_sec = 20

-- > Printer Settings:
--printer = "Addiform_RRF"                  -- The exact directory name of the printer profile. This seems redundant.
bed_size_x_mm = 0                           -- IceSL default is 100. Must be left at 0 if bed origin is at center. If front-left-corner is origin, set to bed size in order to center prints.
bed_size_y_mm = 0                           -- IceSL default is 100. Must be left at 0 if bed origin is at center. If front-left-corner is origin, set to bed size in order to center prints.

-- > Processing Settings:
slicing_algorithm = "Auto select"           -- Options are: "Auto select", "Discrete", and "Polygonal".
tile_size_mm = 30
xy_mm_per_pixels = 0.04                     -- IceSL default is 0.05.
xy_max_deviation_mm = 0.001                 -- IceSL default is 0.005.

--
-- # End of default GUI settings.


-- ### Internal IceSL settings which do not appear in the GUI:
--
--     In order for these values to be changed, they must be set in this file: features.lua, a .lua
--     profile found in the 'materials' or 'profiles' directories, or a .lua script in IceSL. They
--     cannot be set in the IceSL GUI.
--

-- * Optional Min/Max values for settings to limit some GUI inputs:
z_layer_height_mm_min = 0.005
z_layer_height_mm_max = 5
perimeter_print_speed_mm_per_sec_min = 1
perimeter_print_speed_mm_per_sec_max = 200
print_speed_mm_per_sec_min = 1
print_speed_mm_per_sec_max = 200
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 200
travel_speed_mm_per_sec_min = 1
travel_speed_mm_per_sec_max = 200
extruder_temp_degree_c_min = 150
extruder_temp_degree_c_max = 500
bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 300

-- * Misc. Internal Settings:
extruder_count = 14                         -- Number of tools installed in printer. IceSL default is 1. Stable maximum seems to be 14, although it should be possible to use 64.
--cycle_gap_mm = -1                         -- IceSL default is reported as -1, but this may not be true. Leave unset for auto calculation by IceSL.

extruder_swap_at_location = false
extruder_swap_location_x_mm = 0
extruder_swap_location_y_mm = 0

tower_at_location = false
tower_location_x_mm = 0
tower_location_y_mm = 0

bed_size_z_mm = 0                           -- Can be left at 0 or set to printer's Z max, but it is unclear to the profile author if this has any effect.

extruder_purge_volume_mm3 = 24              -- It remains unclear to the profile author how this is used internally.

retract_perimeter_safety_distance_mm = 1.2  -- Seems like permissable movement without retraction for perimeter moves.

print_speed_microlayers_mm_per_sec = 100    -- IceSL default is 200. Appears to be used when filling tiny gaps.
--kgon_num_vertices                         -- Variable listed in documentation but not referenced elsewhere. Defaults unknown.
--print_kickback_length_mm                  -- Variable listed in documentation but not referenced elsewhere. Defaults unknown.

--overhang_points                           -- Field that can be set somewhere, perhaps by one of the button fields found in GUI.

flow_dampener_e_length_mm = 3               -- Seems to be like retraction, but for mixing extruders.
flow_dampener_path_length_end_mm = 1        -- Legnth along end of path that the path a colour transition occurs.
flow_dampener_path_length_start_mm = 1      -- Legnth along start of path that the path a colour transition occurs.
material_mixing_enable_optimizer = true     -- Possibly the name of function which uses the above settings.
mixing_ratio_min_threshold = 0.07           -- Mixing ratios below this value are snapped to zero.
mixing_shield_speed_multiplier = 1.5
--micro_mixing_field                        -- Field that can be set somewhere, but doesn't seem to be accessible via GUI.
--mixing_wipe_length_mm                     -- Variable listed in documentation but not referenced elsewhere. Defaults unknown.

-- * Internal Brush Settings (can be used with _0 suffix):
cover_flow_multiplier = 1
--num_covers                                -- Variable listed in documentation but not referenced elsewhere. Defaults unknown. Could be deprecated.

-- * Internal Extruder Settings (can be used with _0 suffix):
extruder_mix_count = 1                      -- Number of elements in table extruder_mix_ratios.
--extruder_mix_ratios = {1}                 -- Table

--
-- # End of Internal IceSL settings.
-- End of file.
