-- LulzBot TAZ 6 Single Extruder
-- Cloned from generic reprap and borrowed from numerous others
-- (the load order is features first, then profiles, then materials)
--
-- 2019-06-07 Brad Morgan              Initial Release

name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"
name_ch = "PLA"

filament_diameter_mm_0 = 2.85
filament_priming_mm_0 = 3.0

extruder_temp_degree_c_0 = 200
--
-- LulzBot TAZ 6 specifics:
-- The wiper pad and auto-leveling probes can have separate temps.
-- Allow for the first layer to have different temperatures.
-- A bed removal temperature because of the PEI on the bed.
--
extruder_first_degree_c_0 = 205  -- First layer can be different
extruder_soft_degree_c_0 = 140
extruder_wipe_degree_c_0 = 170
extruder_probe_degree_c_0 = 170

bed_temp_degree_c = 60
bed_temp_first_c = 65            -- First layer can be different
bed_temp_remove_c = 45
