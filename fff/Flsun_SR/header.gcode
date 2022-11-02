G21 ; set units to millimeters
M104 S<TOOLTEMP> ; set extruder temp
M140 S<HBPTEMP> ; set bed temp
G28 ; home head
G90 ; use absolute coordinates
M82 ; use absolute extrusion
M190 S<HBPTEMP> ; wait for bed temp
M109 S<TOOLTEMP> ; wait for extruder temp

G92 E0

G1 F3000 Z150 ; lower Z
G1 F3000 X-130 Y0 Z0.4 ; move to purge location
G3 X0 Y-130 I130 Z0.3 E40 F2700 ; Extrude about 40 mm by printing a 90 degree arc
; Retract and move nozzle up
G92 E0
G1 E-1.5 F1800
G0 Z0.5
G1 E0 F300
G1 F3000 ; fix speed for the first move if not done in the print part

; start of print
