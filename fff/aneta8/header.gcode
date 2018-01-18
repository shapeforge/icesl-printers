M104 S<TOOLTEMP> ; set extruder temperature
M140 S<HBPTEMP> ; set bed temperature
M109 S<TOOLTEMP> ; wait for extruder temperature to be reached
M190 S<HBPTEMP> ; wait for bed temperature to be reached
G28 ; home all axes
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G92 E0 ; zero the extruded length
G1 Z15.0 F3600 ; move the platform down 15mm
G1 F200 E10 ; extrude 10mm of feed stock
G92 E0 ; zero the extruded length again
G1 F3600 ; 
