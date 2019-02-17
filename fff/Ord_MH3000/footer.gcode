G92 E0
M107 ; fan off
M104 S0 ; turn off temperature
M140 S0
M107 
G1 X5 Y130 F4000  ; home X axis
M84     ; disable motors
