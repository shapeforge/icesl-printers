M107     ; fan off
M104 S0  ; turn off temperature
M140 S0  ; turn off bed temperature
; go up 2 mm
G91
G1 Z2.0
G90
G92 E0
; go home
G28 X0 Y0
G1 Z15.0 F<MAX_SPEED> 
; prime the extruder
G1 F300 E3
G92 E0

