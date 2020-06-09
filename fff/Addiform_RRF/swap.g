; Replace the entire contents of swap.g with desired swap gcode.
; 
; Since this file is inserted after T*, it will be be executed after RRF's own
; tool change macros: i.e. after RRF's tpost*.g macros.
;
; The profile will replace the following variable placeholders in this file:
;
; ID number of the tool being deselected                                <from_extruder>
; ID number of the tool being selected                                  <to_extruder>
; retraction length of the tool being deselected                        <retract_length_from>
; retraction length of the tool being selected                          <retract_length_to>
; retraction speed of the tool being deselected, converted to mm/min    <retract_speed_from>
; retraction speed of the tool being selected, converted to mm/min      <retract_speed_to>
;
; X coordinate at beginning and end of template                         <x>
; Y coordinate at beginning and end of template                         <y>
; Z coordinate at beginning and end of template                         <z>
;
; travel Z-lift height                                                  <z_lift>
; tool swap retraction length                                           <extruder_swap_retract_length>
; tool swap retraction speed, converted to mm/min                       <extruder_swap_retract_speed>
; tool swap Z-lift height                                               <extruder_swap_z_lift>
; absolute Z height of the current layer                                <current_layer_zheight>
; current fan speed percentage represented as 0.0 to 1.0                <fan_percent>
; extruder movement speed from custom settings, converted to mm/min     <e_movement_speed>
; Z axis movement speed from custom settings, converted to mm/min       <z_movement_speed>
; travel speed, converted to mm/min                                     <travel_speed>
; minimum X coordinate of printed object(s)                             <print_x_min>
; maximum X coordinate of printed object(s)                             <print_x_max>
; minimum Y coordinate of printed object(s)                             <print_y_min>
; maximum Y coordinate of printed object(s)                             <print_y_max>
; maximum Z coordinate of printed object(s)                             <print_z_max>