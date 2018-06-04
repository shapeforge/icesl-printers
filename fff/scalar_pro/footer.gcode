;End GCode
M104 S0                     ;extruder heater off
M140 S0                     ;heated bed heater off (if you have it)
G91                                    ;relative positioning
G1 E-1 F300                            ;retract the filament a bit before lifting the nozzle
 to release some of the pressure
G1 Z+0.5 E-5 X-20 Y-20 F5400 ;move Z up a bit and retract filament even more
G28 X0
G90                         ;absolute positioning                           ;move X/Y to min endstops
 so the head is out of the way
G1 Y370

M84                         ;steppers off
G90                         ;absolute positioning
;{profile_string}
;{profile_string}
;victory
M300 S2349 P53
M300 S0 P53
M300 S2349 P53
M300 S0 P53
M300 S2349 P53
M300 S0 P53
M300 S2349 P428
M300 S932 P428
M300 S2093 P428
M300 S2349 P107
M300 S0 P214
M300 S2093 P107
M117 Waiting cooldown
M106 S255         ; Activate blower fan
M109 R60.000000          ;wait for  temperature to reach 60
M190 R60.000000
M106 S0           ; shut down blower fan
M81                  ;ShutDown PSU
M117  Shutdown