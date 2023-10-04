M107       ; fan off
M104 T0 S0 ; turn off hot end
M104 T1 S0 ; turn off hot end
M104 T2 S0 ; turn off hot end
M104 T3 S0 ; turn off hot end
M104 S0    ; turn off temperature
G1 X0 Y0 F9000 ; move back X and Y to origin
T-1        ; remove tool
M84        ; disable motors
