G91 ;relative positioning
G1 Z1 E-1 F2400 ;move Z up a bit and retract filament
G90 ;absolute positioning
G28 X Y ;home X and Y
M104 S0 T0 ;left extruder heater off
M104 S0 T1 ;right extruder heater off
M140 S0 ;bed heater off
M107 ;fan off
M84  ;steppers off
M204 S<ACC>	;set default acceleration
M205 <JERK> ;set default jerk
