G21        ;metric values
G90        ;absolute positioning
M82        ;set extruder to absolute mode
M107       ;start with the fan off
M104 S<TOOLTEMP> ; set temperature
G28 X0 Y0  ;move X/Y to min endstops
G28 Z0     ;move Z to min endstops
G1 Z15.0 F{travel_speed} ;move the platform down 15mm
M109 S<TOOLTEMP> ; wait for temperature to be reached
G92 E0                  ;zero the extruded length
G1 F200 E3              ;extrude 3mm of feed stock
G92 E0                  ;zero the extruded length again
G1 F1200
;Put printing message on LCD screen
M117 Printing...