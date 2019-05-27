M107
M115 U3.7.1 ; tell printer latest fw version
G21 ; set units to millimeters
M104 S<TOOLTEMP> ; set extruder temp
M140 S<HBPTEMP> ; set bed temp
M190 S<HBPTEMP> ; wait for bed temp
M109 S<TOOLTEMP> ; wait for extruder temp
G28 W ; home all without mesh bed level
G80 ; mesh bed leveling
