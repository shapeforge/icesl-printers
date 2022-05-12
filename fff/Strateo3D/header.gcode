M140 S<BED_TEMP>
M105
M141 S<CHAMBER_TEMP>

<TOOL_TEMP>
M82 ; absolute extrusion mode
G90 ; absolute positionning
G28 ; home all axis
M420 S1 ; enable bed leveling (was disabled y G28)
M420 L ; load previous mesh / bed level
M190 S<BED_TEMP>
