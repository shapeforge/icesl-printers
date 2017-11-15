G90
M82
M106 S0 ; turn fan off
G28     ; home
G92 E0  
M140 S<HBPTEMP> ; warm bed
M190 S<HBPTEMP>
M104 S<TOOLTEMP> T0 ; warm extruder
M109 S<TOOLTEMP> T0
G1 Z1.0 F9000 ; move close to bed
T0      ; select tool 0
