G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion


G28 ; home all axes
<BEDLVL>


G92 E0
G1 Z1.0 F3000 ; move z up little to prevent scratching of surface
G1 X20 Y10 Z0.3 F5000.0 ; move to start-line position
G1 X150 Y10 Z0.3 F1500.0 E15 ; draw 1st line
G1 X150 Y10 Z0.3 F5000.0 ; move to side a little
G1 X20 Y10.3 Z0.3 F1500.0 E30 ; draw 2nd line
G92 E0 ; reset extruder
; done purging extruder
