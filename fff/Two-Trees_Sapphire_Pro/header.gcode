G21 ; set units to millimeters
G28 ; home all without mesh bed level
G90 ; Absolute positioning
G1 X0.5 Y210.0 Z15 ; Move to left back corner with 15mm
M140 S<HBPTEMP>; set bed temp
M104 S<TOOLTEMP>; set extruder temp
M190 S<HBPTEMP>; wait for bed temp
M109 S<TOOLTEMP>; wait for extruder temp
M107
M117 Purge extruder
G92 E0 ; Reset Extruder
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X0.1 Y20 Z0.3 F5000.0 ; Move to start position
G1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw the first line
G1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to side a little
G1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw the second line
G90 ; Absolute positioning
