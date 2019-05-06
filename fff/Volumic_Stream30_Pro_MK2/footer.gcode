
; End GCode
M107 ; Turn fan off
G91 ; Relative positioning
T0
G1 E-1 ; Retract a little before moving the nozzle away
M104 T0 S0 ; Extruder heater off
G90 ; Absolute ositioning
G0 X1 Y190 F5000
G92 E0
M140 S0 ; Heated bed heater off
M84 ; Steppers off
M300
