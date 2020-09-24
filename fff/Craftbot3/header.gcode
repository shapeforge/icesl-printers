G21 ;metric values
M82 ;absolute extrusion mode
G90 ;absolute positioning

M204 S<ACC> ;set default acceleration
M205 <JERK> ;set default jerk

G28 X Y ;home X and Y
G28 Z   ;home Z

M425 S1 ;enable Wiping Strip

<PRINT_MODE>
<TOOLSTEMP>
M190 S<BEDTEMP> ;bed temperature

G92 E0
M107 ;fan off
