M104 S0		;extruder heater off
M106 S255	;start fan full power
M140 S0		;heated bed heater off (if you have it)
G91		    ;relative positioning
G1 E-1 F300	;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+3 E-2 F300	;move Z up a bit and retract filament even more
G28 X0 Y0	;move X/Y to min endstops, so the head is out of the way;
G4 P360000
M908	;stop fan
M84		;shut down motors