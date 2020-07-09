M82 		 ;absolute extrusion mode

G21          ;metric values
G90          ;absolute positioning
M204 S<ACC> ;set default acceleration
M205 <JERK> ;set default jerk
M107         ;start with the fan off
G28 X0 Y0    ;move X/Y to min endstops
G28 Z0       ;move Z to min endstops
G1 Z5 F200   ;safety Z axis movement
<BUCKET_PURGE>
<PRINT_MODE>
G4 P1
G4 P2
G4 P3
