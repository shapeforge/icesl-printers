M136 (enable build progress)
M73 P0 
G21 (set units to mm)
G90 (set positioning to absolute)

(**** begin homing ****)
G162 X Y F2500 (home XY axes maximum)
G161 Z F1100 (home Z axis minimum)
G92 Z-5 (set Z to -5)
G1 Z0.0 (move Z to "0")
G161 Z F100 (home Z axis minimum)
M132 X Y Z A B (Recall stored home offsets for XYZAB axis)
(**** end homing ****)

G1 X-110.5 Y-74 Z50 F3300.0 (move to waiting position)
G130 X20 Y20 Z20 A20 B20 (Lower stepper Vrefs while heating)

M140 S<HBPTEMP> (set HBP temperature)
M134 T0 (wait for bed temp)
M135 T0 (switch to tool)
M104 S<TOOLTEMP> T<TOOL> (set extruder temperature)
M133 T<TOOL> (wait for tool temp)
M6 T<TOOL> (wait for toolhead, and HBP to reach temperature)

G130 X127 Y127 Z40 A127 B127 (Set Stepper motor Vref to defaults)

G0 X-110.5 Y-74 (Position Nozzle)
G0 Z0.6      (Position Height)
G92 E0 (Set E to 0)
G1 E4 F300 (Extrude 4mm of filament)
G92 E0 (Set E to 0 again)
(**** end of start.gcode ****)

