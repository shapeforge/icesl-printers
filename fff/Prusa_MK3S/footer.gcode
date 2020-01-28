G4 ; wait
M221 S100
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
G1 F6200 X0 Y200; home X axis
M84 ; disable motors
