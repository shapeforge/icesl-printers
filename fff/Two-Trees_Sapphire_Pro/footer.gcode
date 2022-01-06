M104 S0 ; Turn off extruder
M140 S0 ; Turn off bed
G92 E1 ; Reset extruder distance
G1 E-5.0 F1200
G28 X0 Y0 ; Home X/Y axies
G91 ; Relative positioning
G1 Z5.0 F6000 ; Move the platform by 5mm down
M84 ; Turn off motors

G1 X0 Y{machine_depth} ;Present print
M106 S0 ;Turn-off fan
M104 S0 ;Turn-off hotend
M140 S0 ;Turn-off bed

M84 X Y E ;Disable all steppers but Z
