G21 ; set units to millimeters
M140 S<HBPTEMP> ; set bed temperature
M104 S<TOOLTEMP> ; set extruder temperature
G28 ; home all axes
G92 ; define all axis to 0
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M109 S<TOOLTEMP> ; wait for temperature to be reached
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G1 Z5.0 F6000 ; move the extruder up 5mm
G92 E0 ; reset extruder to 0
G1 F800 E5.000000 ; prime the extruder
G92 E0 ; reset extruder to 0
;M900 K<LINADVANCE> ; set linear advance K parameter