M907 E750 ; set motor current
G92 E0
M83 ; extruder relative mode
G92 E0
; retract sequence
G1 F4000 E0.8
G1 F6000 E-15.0
G1 F1200 E-24.5
G1 F600 E-7.0
G1 F360 E-3.5
; cooling move
G1 F448 E20.0
G1 F326 E-20.0
; retract to parking position (85)
G1 F2000 E-35.0
G4 S0
; change extruder
<NEW_TOOL>
G4 S0
; load sequence
G1 F1200 E15.0
G1 F6000 E45.0
G1 F4000 E20.0
G1 F713	E5.0
M907 E550; set motor current
G4 S0
G92 E0
M82 ; extruder absolute mode
G92 E0
; End of Filament change
