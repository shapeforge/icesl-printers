G21 ; set units to millimeters
G28 X0 Y0 ; home X and Y
M104 S<TOOLTEMP> ; set temperature
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M109 S<TOOLTEMP> ; wait for temperature to be reached
G28 ;home all axes
G90 ; use absolute coordinates
<BEDLVL>
M82 ; use absolute distances for extrusion
G92 E0
G1 X5.0 Y5.0 Z0.3
G1 X65.0 Y5.0 E9.0  F1000.0 ; purge line
G1 X105.0 Y5.0 E12.5  F1000.0 ; purge line
G92 E0
