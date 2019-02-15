M107 ; fan off
M104 S0 ; turn off extruder temperature
M140 S0 ; turn off bed temperature
G92 E0
G1 E-3 F300 ; Retract the filament
G1 X0 Y200 F6000 ; home X and move platter to the front
M84 ; disable motors

;Play Mozart tune
M300 S1244 P120
M300 S1108 P120
M300 S1046 P120
M300 S1108 P120
M300 S1318 P240
M300 S0 P240
M300 S1479 P120
M300 S1318 P120
M300 S1244 P120
M300 S1318 P120
M300 S1661 P240
