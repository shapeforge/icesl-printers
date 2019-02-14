M107    ; fan off
M104 S0 ; extruder off
M140 S0 ; bed off
G91         ; relative
G1 Z10 F300 ; move up a bit, slowly
G90         ; absolute
M84     ; disable motors
