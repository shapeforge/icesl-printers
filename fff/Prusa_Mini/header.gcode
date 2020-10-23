; <THUMBNAIL_SMALL> (thumbnail management not yet supported, placeholder macro for later use)
; <THUMBNAIL_BIG> (thumbnail management not yet supported, placeholder macro for later use)

M73 P0 R46

<ACCELERATIONS>

M107
G90 ; use absolute coordinates
M83 ; extruder relative mode

M104 S170 ; set extruder temp for bed leveling
M140 S<HBPTEMP> ; set bed temp
M109 R170 ; wait for bed leveling temp
M190 S<HBPTEMP> ; wait for bed temp
G28 ; home all without mesh bed level
G29 ; mesh bed leveling 
M104 S<TOOLTEMP> ; set extruder temp
G92 E0.0
G1 Y-2.0 X179 F2400
G1 Z3 F720
M109 S<TOOLTEMP> ; wait for extruder temp

; intro line
G1 X170 F1000
G1 Z0.2 F720
G1 X110.0 E8.0 F900
M73 P0 R46
G1 X40.0 E10.0 F700
G92 E0.0

G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G92 E0.0
M221 S<FLOW> ; set flow
M900 K<FILAMENT> ; Filament gcode
