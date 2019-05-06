; GCODE HEADER

; setting some defaults
G90  ; use absolute coordinates
M82  ; use absolute distances for extrusion
G21 ; sets space unit to mm
M73 P0 ; set build percentage to zero

; homing all the axes and moving to wait position
G28 X Y ; home XY axes
G0 X-1000 Y-1000 F1800
G28 Z ; home Z axis
G1 X0 Y0 Z50 F3600

; pre-heating sequence
G130 X20 Y20 A20 B20  ; Lower stepper Vrefs while heating
M140 S<HBPTEMP>
<TOOLTEMP0>
<TOOLTEMP1>
M134
<WAITTEMP0>
<WAITTEMP1>
G130 X127 Y127 A127 B127  ; Set Stepper motor Vref to defaults

; priming sequence (using 5 mm on all the active extruders)
<TOOLCHOICE>
G92 E0 A0 B0
G0 X35 Y4 Z<PRIMINGHEIGHT> F2400
<PRIMINGTOOL0>
G1 X220 Y5 F2400
<PRIMINGTOOL1>
G92 E0 A0 B0 ; resetting all extruders counters even if printer lua will use only E