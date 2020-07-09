M104 S0 T0               ;left extruder heater off
M104 S0 T1               ;right extruder heater off
M140 S0                  ;heated bed heater off
M204 S<ACC>				 ;set default acceleration
M205 <JERK> 		 ;set default jerk
G91                      ;relative positioning
G1 Z+0.5 E-5 Y+10 F12000 ;move Z up a bit and retract filament
G28 X0 Y0                ;move X/Y to min endstops so the head is out of the way
M84                      ;steppers off
G90                      ;absolute positioning
