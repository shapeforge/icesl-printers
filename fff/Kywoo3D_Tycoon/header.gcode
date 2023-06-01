M104 S<TOOLTEMP> ; set temperature
M140 S<HBPTEMP>  ; set bed temperature 
T0
;FLAVOR:Kywoo3d_Tycoon
G21 
G90 
M82 ; extruder absolute mode
M107 ; fan off
G28 X0 Y0   
G28 Z0    
G1 Z15.0 F<MAX_SPEED> 
G92 E0       
G1 F200 E3      
G92 E0          
G1 F<MAX_SPEED> 
M109 S<TOOLTEMP> ; wait for temperature to be reached
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M117 Printing... 
M107 
