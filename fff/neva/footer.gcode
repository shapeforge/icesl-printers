M104 S0
M106 S255 ;start fan full power
M140 S0 ;heated bed heater off (if you have it)
G91 ;relative positioning
G1 E-1 F300 ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+3 E-2 F9000  ;move Z up a bit and retract filament even more
G90
G28