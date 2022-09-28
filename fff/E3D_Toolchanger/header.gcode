G21 ; set units to millimeters
G90 ; Set to Absolute Positioning
M82 ; absolute extrusion mode

G28 ; homing
G29 S1 ; load the height map from file and activate mesh bed compensation
T-1 ; unload tool
M190 S<HBPTEMP> ; wait for bed temperature to be reached
