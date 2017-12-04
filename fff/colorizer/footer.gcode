G92 E0
G1 F2000 X200 Y0 Z100 E-6
M107 ; fan off
M104 S0 ; turn off temperature
M140 S0
M107 
G28
M84     ; disable motors
