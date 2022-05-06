G21 ; set units to millimeters
G28 X0 Y0 ; home X and Y
M104 S<TOOLTEMP> ; set temperature
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M109 S<TOOLTEMP> ; wait for temperature to be reached
G28 ;home all axes
G90 ; use absolute coordinates
<BEDLVL>
M82 ; use absolute distances for extrusion
G92 E0
G1 Z0.3
G1 X100.0 Y0 Z0.3 E50 F600.0 A0.20 B0.20 C0.20 D0.20 H0.20; start purge
G1 X190 Y0 Z0.3 E80 F1200.0 A0.20 B0.20 C0.20 D0.20 H0.20; finish purge line﻿
G92 E0
G1 X195 Y0 Z0.3 F4000 ; Quickly wipe away from the filament line
