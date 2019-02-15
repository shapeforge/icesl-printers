G91		;relative positioning
G1 Z7
G90		;absolute positioning
G28 X
M106 S255
M109 S180			; wait Hotend temperature
M104 S<TOOLTEMP>	; set Hotend temperature
;M190 S60 			; wait Bed temperature
G28 X
G28 Y
G01 X20 Y100
G28 Z
;bloc palpeur
;{palpeur}
;bloc Offset
G92 Z10
G91		;relative positioning  
G1 Z<Z_OFFSET>
G90 
G92 Z0
G1 Z3
G1 X100 Y200 F3000
G1 Z2
M104 S<TOOLTEMP>
M82 ;set extruder to absolute mode
M107 ;start with the fan off
G92 E0 ;zero the extruded length
G1 F200 E3 ;extrude 10mm of feed stock
G92 E0 ;zero the extruded length again
G1 F9000