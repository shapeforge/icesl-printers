-- LulzBot TAZ 6 Single Extruder
-- Cloned from generic reprap and borrowed from numerous others
-- (the load order is features first, then profiles, then materials)
--
-- 2019-06-07 Brad Morgan              Initial Release

name_en = "ABS"
name_es = "ABS"
name_fr = "ABS"
name_ch = "ABS"

filament_diameter_mm_0 = 2.85
filament_priming_mm_0 = 1.0

extruder_temp_degree_c_0 = 230
--
-- LulzBot TAZ 6 specifics:
-- The wiper pad and auto-leveling probes can have separate temps.
-- Allow for the first layer to have different temperatures.
-- A bed removal temperature because of the PEI on the bed.
--
extruder_first_degree_c_0 = 235
extruder_soft_degree_c_0 = 170
extruder_wipe_degree_c_0 = 170
extruder_probe_degree_c_0 = 170

bed_temp_degree_c = 110
bed_temp_first_c = 115
bed_temp_remove_c = 45
