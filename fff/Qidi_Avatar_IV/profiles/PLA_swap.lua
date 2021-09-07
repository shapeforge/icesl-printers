name_en = "PLA swap"
name_es = "PLA swap"
name_fr = "PLA swap"
name_ch = "PLA swap"

--qidi custom
qidi_swap_extruders = true
qidi_extra_z_distance = 0.0
qidi_retract_after_z = 0.2

--Slicing
z_layer_height_mm = 0.2
use_different_thickness_first_layer=false
z_layer_heigth_first_layer_mm=0.2
print_speed_mm_per_sec=40
perimeter_print_speed_mm_per_sec=30
cover_print_speed_mm_per_sec=30
first_layer_print_speed_mm_per_sec=30
process_thin_features=false
enable_fit_single_path=false
path_width_speed_adjustment_exponent=3

--Brush 0
extruder_0=0
num_shells_0=3
cover_thickness_mm_0=1.2
infill_percentage_0=20
print_perimeter_0=true
flow_multiplier_0=1.0  
speed_multiplier_0=1.0

--Extruder 0
filament_priming_mm=3.0
priming_mm_per_sec=120   --retraction/priming after retraction speed
retract_mm_per_sec=120

--Supports
gen_supports=false
supports_max_bridge_len_mm=10
support_spacing_min_mm=2.0
support_extruder=0
support_print_speed_mm_per_sec=20
support_flow_multiplier=1.0

--Raft
add_raft=false
raft_spacing=1.0

--Brim
add_brim=false
brim_distance_to_print_mm=1.0
brim_num_contours=2

--Travel
travel_speed_mm_per_sec=40
travel_straight=false
travel_max_length_without_retract=20
travel_avoid_top_covers=false

--Shield
gen_shield=false
shield_distance_to_part_mm=2.0
shield_num_contours=1

--Mulit-Material
enable_active_temperature_control=false
extruder_degrees_per_sec_0=2            --1st extruder
idle_extruder_temp_degree_c_0=100
extruder_degrees_per_sec_1=2            --2nd extruder
idle_extruder_temp_degree_c_1=100
extruder_swap_zlift_mm=1.0
extruder_swap_retract_length_mm=6.0
gen_tower=false


--default material properties
extruder_temp_degree_c_0 = 210
filament_diameter_mm_0 = 1.75
filament_priming_mm_0 = 3.0

bed_temp_degree_c = 65
