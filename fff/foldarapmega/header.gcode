G21 ; set units to millimeters
M107
M190 S<HBPTEMP> ; wait for bed temperature to be reached
M104 S<TOOLTEMP> ; set temperature
M109 S<TOOLTEMP> ; wait for temperature to be reached
M106 S204 ; turn fan on
