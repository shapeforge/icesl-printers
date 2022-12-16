G21 ; set units to millimeters
G90 ; Set to Absolute Positioning
M82 ; absolute extrusion mode
T-1 ; unload tool
G28 ; homing
G29 S1 ; load the height map from file and activate mesh bed compensation
M190 S<HBPTEMP> ; wait for bed temperature to be reached
