G92 E0
M107 ; fan off
M104 S0 ; turn off temperature
M140 S0
M107
G28 X0 Y0 ; move X/Y to min endstops
M84     ; disable motors
