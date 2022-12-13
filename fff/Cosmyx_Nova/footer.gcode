G92 E0
M104 S0 ; turn off temperature
M140 S0
G28 X Y ; move back carriage to origin (xy max)
M84     ; disable motors
M107    ; fan off
