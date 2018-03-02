M190 S<HBPTEMP>; Heated bed temp
M104 S<TOOLTEMP>; Material print temperature
M109 S<TOOLTEMP>; Material print temperature
M82; Absolute extrusion mode

G21;(metric values)
G90;(absolute positioning)
M82;(set extruder to absolute mode)
M107;(start with the fan off)
G28;(Home the printer)
G92 E0;(Reset the extruder to 0)
G0 Z5 E5 F500;(Move up and prime the nozzle)
G0 X-1 Z0;(Move outside the printable area)
G1 Y60 E8 F500;(Draw a priming/wiping line to the rear)
G1 X-1;(Move a little closer to the print area)
G1 Y10 E16 F500;(draw more priming/wiping)
G1 E15 F250;(Small retract)
G92 E0;(Zero the extruder)
