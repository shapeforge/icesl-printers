G92 E0
M107       ; fan off
; turn off heaters
M104 S0
M140 S0
M107
G28 X Y       ; move back X and Y to origin
G0 F6200 Y280 ; present bed for part removal
M84           ; disable motors
