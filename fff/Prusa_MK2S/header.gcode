M862.3 P "MK2.5S" ; printer model check
;M862.1 P0.4 ; nozzle diameter check
M115 U3.8.1 ; tell printer latest fw version

M201 X9000 Y9000 Z500 E10000 ; sets maximum accelerations, mm/sec^2
M203 X500 Y500 Z12 E120 ; sets maximum feedrates, mm/sec
M204 P2000 R1500 T2000 ; sets acceleration (P, T) and retract acceleration (R), mm/sec^2
M205 X10.00 Y10.00 Z0.20 E2.50 ; sets the jerk limits, mm/sec
M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec

M104 S<TOOLTEMP> ; set extruder temp
M140 S<HBPTEMP> ; set bed temp
M190 S<HBPTEMP> ; wait for bed temp
M109 S<TOOLTEMP> ; wait for extruder temp
M107

G21 ; set units to millimeters
G28 W ; home all without mesh bed level
G80 ; mesh bed leveling
G90 ; use absolute coordinates

M83  ; extruder relative mode
G1 Y-3.0 F1000.0 ; go outside print area
G92 E0.0
G1 X60.0 E9.0  F1000.0 ; intro line
G1 X100.0 E12.5  F1000.0 ; intro line
G92 E0.0
M82  ; extruder absolute mode
M900 K<FILAMENT> ; Filament gcode
G92 E0.0
