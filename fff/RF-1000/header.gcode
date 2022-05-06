G21  ; set units to millimeters
G90  ; use absolute coordinates
M82  ; use absolute distances for extrusion
M107 ; fan off
M104 S<TOOLTEMP> ; set temperature
M190 S<HBPTEMP> ; wait for bed temperature to be reached
;--------------------------------------
G28 ; home all axes
G1 Z5 F500 ; lift nozzle
M109 S<TOOLTEMP> ; wait for temperature to be reached
G92 E0 ; start line
G1 F300 E-0.5
G1 X230 Y2 Z0.35 F5000
G1 F800 E13
G1 X20 E25 F1000
; Acceleration up to...
; Acc printing
M201 X3000 Y3000 Z100
; Acc travel
M202 X3000 Y3000 Z100
;--------------------------------------
G92 E0 ; set feed counter to 0