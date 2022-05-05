G21 ; set units to millimeters
G90 ; use absolute coordinates
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
G28 ; home all axes
G0 X1.0 Y1.0 Z5.0 F600
M109 S<TOOLTEMP> ; wait for temperature to be reached
M82 ; use absolute distances for extrusion
G92 E0
G1 Z1.0 F3000 ; move z up little to prevent scratching of surface
G1 X20.0 Y1.0 Z0.3 F5000.0 ; move to start-line position
G1 X100.0 Y1.0 Z0.3 F1500.0 E15 ; draw 1st line
G1 X100.0 Y1.3 Z0.3 F5000.0 ; move to side a little
G1 X20.0 Y1.3 Z0.3 F1500.0 E30 ; draw 2nd line
G92 E0 ; reset extruder
; done purging extruder