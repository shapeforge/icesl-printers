G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion

G28 ; home all axes
G0 F600 Z10.0 ; go up a bit

M190 S<HBPTEMP> ; wait for bed temperature to be reached
<TOOLTEMPS>

G92 E0 ; zero filament axis
