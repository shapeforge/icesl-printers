; end of print

G91 ; relative coordinates
G1 E-1 F300 ; retract filament a bit before lifting
G1 Z+5 E-5 F6000 ; raise platform from current position
G90 ; absolute coordinates

G28; home 

G92 E0 ; reset extruder
G1 E8 ; DH added

M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan

M84 ; disable motors
