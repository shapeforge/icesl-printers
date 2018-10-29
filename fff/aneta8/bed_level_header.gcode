G21 ; set units to millimeters
G28 X0 Y0 ; home X and Y
M104 S<TOOLTEMP> ; set temperature
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M109 S<TOOLTEMP> ; wait for temperature to be reached
G28 ; home all axes
G90 ; use absolute coordinates
G29 ; auto bed levelling
G0 F6200 X0 Y0 ; back to the origin to begin the purge
M82 ; use absolute distances for extrusion
G92 E0
G1 Z0.3
G1 X100.0 Y0 Z0.3 F600.0 E50; start purge
G1 X190 Y0 Z0.3 F1200.0 E80; finish purge line﻿
G1 F25000 70; Retract a little
G1 X195 Y0 Z0.3 F4000; Quickly wipe away from the filament line
G92 E0
