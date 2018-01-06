G92 E0
M107       ; fan off
M104 S0    ; turn off temperature
M140 S0
M107
G91        ; relative coords
G0 Z10     ; move up a bit 
G90        ; absolute coords
M84        ; disable motors
