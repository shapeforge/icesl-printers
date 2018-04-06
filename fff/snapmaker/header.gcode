M190 S<HBPTEMP>; Heated bed temp
M104 S<TOOLTEMP>; Material print temperature
M109 S<TOOLTEMP>; Material print temperature
M82; Absolute extrusion mode

G21;(metric values)
G90;(absolute positioning)
M82;(set extruder to absolute mode)
M107;(start with the fan off)

G28 ;Home
G1 Z15.0 F6000 ;Move the platform down 15mm
G0 X-4 Y-1 Z0
G92 E0
G1 F200 E20
G92 E0
