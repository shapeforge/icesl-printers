G21 ; set units to millimeters
G90 ; use absolute coordinates
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
G28 ; home all axes
G0 F600 Z5.0
G0 X1.0 Y1.0 F7200
M109 S<TOOLTEMP> ; wait for temperature to be reached
M82 ; use absolute distances for extrusion
G92 E0