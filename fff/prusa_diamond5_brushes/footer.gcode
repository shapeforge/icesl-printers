G92 E0
M104 S0 ; turn off hot end 
M140 S0 ; turn off hot bed
M107 ; turn off part cooling fan
G28 X0 Y0 ; home X and Y
G1 F6200 Y150 ; move Y to present finished part
M84 ; disable motors