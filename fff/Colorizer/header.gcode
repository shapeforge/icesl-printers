G21 ; set units to millimeters
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
G28 ; home all axes
M109 S<TOOLTEMP> ; wait for temperature to be reached
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G92 E0
G1 E6 F1200 ; extrude a bit
G92 E0
