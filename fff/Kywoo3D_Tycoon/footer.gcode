M107     ; fan off
M104 S0  ; turn off temperature
M140 S0  ; turn off bed temperature
; go home
G28 X0 Y0
G1 Z15.0 F6000
; prime the extruder
G92 E0
G1 F300 E3
G92 E0

