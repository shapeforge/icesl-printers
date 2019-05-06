
G90 ; use absolute coordinates
M83 ; extruder relative mode

;go outside print area
G1 Y-3.0 F1000.0
G1 Z0.4 F1000.0
; select extruder
T<FIRST_EXTRUDER>
; initial load
G1 X55.0 E29.0 F1073.0
G1 X5.0 E29.0 F1800.0
G1 X55.0 E8.0 F2000.0
G1 Z0.3 F1000.0
G92 E0.0
G1 X240.0 E25.0  F2200.0
G1 Y-2.0 F1000.0
G1 X55.0 E25 F1400.0
G1 Z0.20 F1000.0
G1 X5.0 E4.0 F1000.0
G92 E0.0

M82 ; extruder absolute mode
G92 E0.0
<FLOW>
