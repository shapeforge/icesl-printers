G92 E0
M107       ; fan off
M104 S0    ; turn off temperature
M140 S0
M107
G1 X0 Y0   ; move back X and Y to origin
G1 Y200	   ; move Y to front to "present" the print 
M84        ; disable motors
