; Replace the entire contents of swappre.g with desired pre-swap gcode.
;
; Since this file is inserted before T*, it will be be executed before RRF's own
; tool change macros: i.e. before RRF's tfree*.g and tpost*.g macros.
;
; The profile will replace the following variable placeholders in this file:
;
; <x>                               X coordinate of the beginning and end of the swap
; <y>                               Y coordinate of the beginning and end of the swap
; <z>                               Z coordinate of the beginning and end of the swap
; <retract_length_from>             retraction length of the tool being deselected
; <retract_length_to>               retraction length of the tool being selected
; <retract_speed_from>              retraction feedrate of the tool being deselected, converted to mm/min
; <retract_speed_to>                retraction feedrate of the tool being selected, converted to mm/min
; <extruder_swap_retract_length>    tool swap retraction length
; <extruder_swap_retract_speed>     tool swap retraction speed, converted to mm/min
; <z_lift>                          travel Z-lift height
; <extruder_swap_z_lift>            tool swap Z-lift height
; <current_layer_zheight>           absolute Z height of the current layer
; <from_extruder>                   ID number of the tool being deselected
; <to_extruder>                     ID number of the tool being selected
; <z_movement_speed>                Z axis movement speed from custom settings, converted to mm/min
; <e_movement_speed>                Extruder movement speed from custom settings, converted to mm/min
; <travel_speed>                    travel speed, converted to mm/min
; <print_x_min>                     minimum X coordinate of printed object(s)
; <print_x_max>                     maximum X coordinate of printed object(s)
; <print_y_min>                     minimum Y coordinate of printed object(s)
; <print_y_max>                     maximum Y coordinate of printed object(s)
; <print_z_max>                     maximum Z coordinate of printed object(s)
; <fan_percent>                     current fan speed percentage represented as 0.0 to 1.0