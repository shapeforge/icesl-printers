M104 S0
M140 S0
G91
; retract filament
G1 E-2 F300
; Output Object
M400
M3079
M400
;Steppers off
M84                                            
;Acceleration to default...
;Acc printing
M201 X1000 Y1000 Z1000
;Acc travel
M202 X1000 Y1000 Z1000