M83 ; extruder relative mode
G1 E-1 F2100 ; retract
G1 X178 Y180 F4200 ; park print head
G4 ; wait
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
M221 S100 ; reset flow
M84 ; disable motors
M73 P100 R0
