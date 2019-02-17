;Gcode by Cura Neva V15.04.6
G90 ;absolute positioning
G28
M109 S100
G29
M104 S<TOOLTEMP>
G0 X0 Y-85
G0 Z0.26
M109 S<TOOLTEMP>
M82 ;set extruder to absolute mode
G92 E0 ;zero the extruded length
G1 F200 E6 ;extrude 10mm of feed stock
G92 E0 ;zero the extruded length again
G1 F200 E-3.5
G0 Z0.15
G0 X10
G0 Z3
M117 Printing...