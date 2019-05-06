M18 A B ; Turn off A and B steppers
G1 Z155 F900 ; move platform down
G162 X Y F2000 ; home XY axes
M18 X Y Z ; Turn off steppers after a build
M84 ; remove hold idle (might make some noise otherwise)

; cool everything down
M140 S0
M104 S0 T0
M104 S0 T1
M104 S0

; finalize build
M70 P5  ; We <3 Making Things!
M72 P1   ;  Play Ta-Da song 
M73 P100  ; end  build progress 
M137  ; build end