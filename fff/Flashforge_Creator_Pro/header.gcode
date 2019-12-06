(*** FlashForge Creator Pro start.gcode ***)
M73 P0 (enable build progress)
G21 (set units to mm)
G90 (set positioning to absolute)
M82 (set extrusion mode to absolute)

(*** begin homing ***)
G162 X Y F2500 (home XY axes maximum)
G161 Z F1100 (home Z axis minimum)
G92 Z-5 (set Z to -5)
G1 Z0.0 (move Z to "0")
G161 Z F100 (home Z axis minimum)
M132 X Y Z A B (recall stored home offsets for XYZAB axis)
(*** end homing ***)

<EXTRUDERS_PARK>
G130 X20 Y20 Z20 A20 B20 (lower stepper Vrefs while heating)

M127 (disable fan)
M140 S<HB_TEMP> (set HB temperature)
<EXTRUDERS_TEMP>

M134 T0 (wait for bed temp)

G130 X127 Y127 Z40 A127 B127 (set Stepper motor Vref to defaults)

G92 A0 B0 (zero extruders)
G0 Z0.4 (position nozzle to begin purge)

<EXTRUDERS_PURGE>
G92 A0 B0 (zero extruders)

M73 P1 (notify GPX body has started)
(*** end of start.gcode ***)