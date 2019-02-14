G21  ; set units to millimeters
G90  ; use absolute coordinates
M82  ; use absolute distances for extrusion
M107 ; fan off
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
G28  ; home all axes
G92 E0
M109 S<TOOLTEMP> ; wait for temperature to be reached
M106 S204 ; turn fan on
