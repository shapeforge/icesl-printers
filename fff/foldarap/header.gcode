G21 ; set units to millimeters
M107
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
G28 ; home all axes
G92 E0
M109 S<TOOLTEMP> ; wait for temperature to be reached
G90 ; use absolute coordinates
G92 E0
M82 ; use absolute distances for extrusion
G1 F2400.000 E-2.70000
G92 E0
M106 S204 ; turn fan on
