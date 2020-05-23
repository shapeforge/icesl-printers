; Replace the contents of end.g with desired end gcode.
;
; The profile will replace the following variable placeholders in this file:
;
; <retract_length>                  retraction length of the current tool
; <retract_speed>                   retraction feedrate of the current tool, converted to mm/min
; <extruder_swap_retract_length>    tool swap retraction length
; <extruder_swap_retract_speed>     tool swap retraction speed, converted to mm/min
; <z_lift>                          travel Z-lift height
; <extruder_swap_z_lift>            tool swap Z-lift height
; <current_layer_zheight>           absolute Z height of the current layer
; <current_extruder>                ID number of the current tool
; <z_movement_speed>                Z axis movement speed from custom settings, converted to mm/min
; <e_movement_speed>                Extruder movement speed from custom settings, converted to mm/min
; <travel_speed>                    travel speed, converted to mm/min
; <print_x_min>                     minimum X coordinate of printed object(s)
; <print_x_max>                     maximum X coordinate of printed object(s)
; <print_y_min>                     minimum Y coordinate of printed object(s)
; <print_y_max>                     maximum Y coordinate of printed object(s)
; <print_z_max>                     maximum Z coordinate of printed object(s)
; <fan_percent>                     current fan speed percentage represented as 0.0 to 1.0