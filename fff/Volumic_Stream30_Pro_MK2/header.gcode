M117 Demarrage ; Starting LCD message
M106 S0 ; Set fan speed to 0
M140 S<HBPTEMP> ; Set bed temperature
M104 T0 S<TOOLTEMP> ; Set hot end temperature
G28 ; Home all axes
G90 ; Use absolute coordinates
M82 ; Use absolute distances for extrusion
G92 E0 ; Reset the distance value for extrusion
G1 Z3 F600
M190 S<HBPTEMP> ; Wait for the bed temperature to be reached
M109 T0 S<TOOLTEMP> ; Wait for the hot end temperature to be reached
M300 P350 ; Play tone before starting purge
M117 Purge ; Purge LCD message
G1 Z0.15 F600
G1 E10 F400
G92 E0
M117 Impression ; Print started LCD message
