M107 ; fan off
M190 S100 ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature

G28  ; home all axes

M109 S<TOOLTEMP> ; wait for temperature to be reached

G21  ; set units to millimeters
G90  ; use absolute coordinates
M82  ; use absolute distances for extrusion

G92 E0 ; reset filament axis
