G92 E0
M107       ; fan off
M104 S0    ; turn off temperature
M140 S0
M107
G1 X0      ; move back X to origin
M84        ; disable motors
