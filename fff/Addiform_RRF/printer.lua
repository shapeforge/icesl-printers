-- RepRapFirmware Configurable Printer Profile (Addiform_RRF) for IceSL
-- created on 2020-APR-20 by Nathan Buxton for Addiform (https://addiform.com)

-- Version 1.0.1

-- printer.lua
-- Last modified:
-- Refactoring and bug fixes for 1.0.1. 2020-JUN-08 NaB
-- File created. 2020-APR-20 NaB

--     This file is not intended to be modified by the user, unless to implement new features, fix
--     bugs, or modify behaviour. Refer to features.lua for user-configurable printer parameters.


-- Global variable initializations:
previous_path_was = "nothing"
current_layer_zheight = 0
previous_layer_zheight = 0
current_layer_thickness = 0
previous_layer_thickness = 0
previous_x = 0
previous_y = 0
previous_z = 0
previous_move_calculated_extrusion_width = 0
current_move_calculated_extrusion_width = 0
current_feedrate = 0
previous_feedrate = 0
current_extruder = -1
previous_extruder = -1
selecting_tools_at_start = false
current_fan_speed = -1
previous_fan_speed = -1
already_extruded = {}

for i = 0, max_number_extruders - 1 do
    already_extruded[i] = 0
end


-- Error checks:
-- Absolute Extrusion not yet implemented:
if not relative_extrusion then print("\nWarning: Absolute extrusion is not yet implemented in this profile.\nNo extrusion values will be produced.\nVolumetric Extrusion requires Relative Extrusion to be enabled.") end

-- CraftWare Path Labeling and S3D Compatibility conflict:
if s3d_debug and craftware_debug then print("\nWarning: Both CraftWare Path Labeling and S3D Compatibility are enabled.\nS3D path labels will not be produced.") end

-- Firmware Retraction requires a non-zero retract/prime distance set in the GUI in order to produce retraction commands:
if type(filament_priming_mm) ~= "table" then filament_priming_mm = {} for i = 0, max_number_extruders - 1 do filament_priming_mm[i] = 0 end end -- This is to allow Firmware Retraction check below during IceSL first boot up.
if firmware_retraction and math.max(unpack(filament_priming_mm)) == 0 then print ("\nWarning: The use of Firmware Retraction requires a non-zero retract value.\nRetraction commands may not be produced.") end

-- 'Automatically spiralize' is untested with this profile. Enable with caution. Read the information at: https://groups.google.com/d/msg/icesl/SyA1akzbGjY/QtBB2kFfDwAJ
if auto_spiralize then print("\nWarning: 'Automatically spiralize' has not been tested extensively with this profile.") end


-- Additional helper functions:
function round(number,decimals)
    local power = 10^decimals
    return math.floor(number * power + 0.5) / power
end

function to_mm_cube(e,diameter)
    local r = diameter / 2
    return math.pi * r^2 * e
end

function get_template(template,options)
    local template_string = file(template)

    -- Common replacement variables:
    template_string = template_string:gsub("\r","")
    template_string = template_string:gsub("<z_lift>",f(z_lift_mm))
    template_string = template_string:gsub("<extruder_swap_retract_length>",ff(extruder_swap_retract_length_mm))
    template_string = template_string:gsub("<extruder_swap_retract_speed>",round(extruder_swap_retract_speed_mm_per_sec*60,0))
    template_string = template_string:gsub("<extruder_swap_z_lift>",f(extruder_swap_zlift_mm))
    template_string = template_string:gsub("<current_layer_zheight>",f(current_layer_zheight))
    template_string = template_string:gsub("<fan_percent>",round(current_fan_speed/100,2))
    template_string = template_string:gsub("<e_movement_speed>",round(e_movement_speed_mm_per_sec*60,0))
    template_string = template_string:gsub("<z_movement_speed>",round(z_movement_speed_mm_per_sec*60,0))
    template_string = template_string:gsub("<travel_speed>",round(travel_speed_mm_per_sec*60,0))
    template_string = template_string:gsub("<print_x_min>",f(min_corner_x))
    template_string = template_string:gsub("<print_x_max>",f(min_corner_x + extent_x))
    template_string = template_string:gsub("<print_y_min>",f(min_corner_y))
    template_string = template_string:gsub("<print_y_max>",f(min_corner_y + extent_y))
    template_string = template_string:gsub("<print_z_max>",f(extent_z))

    -- Situation-specific replacement variables:
    if type(options) == "table" then
        if not options.from and not options.to then
            template_string = template_string:gsub("<current_extruder>",current_extruder)
            template_string = template_string:gsub("<retract_length>",ff(filament_priming_mm[current_extruder]))
            template_string = template_string:gsub("<retract_speed>",round(priming_mm_per_sec[current_extruder]*60,0))
        else
            if options.from then
                template_string = template_string:gsub("<from_extruder>",options.from)
                template_string = template_string:gsub("<retract_length_from>",ff(filament_priming_mm[options.from]))
                template_string = template_string:gsub("<retract_speed_from>",round(priming_mm_per_sec[options.from]*60,0))
            end

            if options.to then
                template_string = template_string:gsub("<to_extruder>",options.to)
                template_string = template_string:gsub("<retract_length_to>",ff(filament_priming_mm[options.to]))
                template_string = template_string:gsub("<retract_speed_to>",round(priming_mm_per_sec[options.to]*60,0))
            end
        end

        if options.x then
            template_string = template_string:gsub("<x>",f(options.x))
        end

        if options.y then
            template_string = template_string:gsub("<y>",f(options.y))
        end

        if options.z then
            template_string = template_string:gsub("<z>",f(options.z))
        end

        if options.sec then
            template_string = template_string:gsub("<sec>",round(options.sec,0))
        end
    else
        template_string = template_string:gsub("<current_extruder>",current_extruder)
        template_string = template_string:gsub("<retract_speed>",round(priming_mm_per_sec[current_extruder]*60,0))
        template_string = template_string:gsub("<retract_length>",ff(filament_priming_mm[current_extruder]))
    end

    return template_string
end


-- IceSL printer functions:
function header()
    -- Function Diagnostic output:
    if function_debug then comment("header()") end

    -- GCode output:
    local filament_total_mm = 0

    for i = 0, number_of_extruders - 1 do
        filament_total_mm = filament_total_mm + filament_tot_length_mm[extruders[i]]
    end
    
    comment("'" .. filename .. "' generated by " .. slicer_name .. " " .. slicer_version .. " ../" .. printer_name .. "/")
    comment("on " .. os.date("%A, %B %d, %Y, at %H:%M:%S %Z"))
    comment("Layer height: " .. round(current_layer_thickness,2) .. " mm") -- current_layer_thickness is used because z_layer_height_mm is not reported correctly in the header if the first layer thickness is different. This may not be correct if variable z heights are used.
    comment("Build Time: " .. round(time_sec / 60,2) .. " minutes")
    comment("filament length: " .. round(filament_total_mm,2) .. " mm")
end

function footer()
    -- Function Diagnostic output:
    if function_debug then comment("footer()") end

    -- GCode output:
    if insert_end_gcode then output(get_template("end.g")) end
end

function comment(text)
    -- GCode output:
    output("; " .. text:gsub("\n","\n; "))
end

function layer_start(zheight)
    -- Function Diagnostic output:
    if function_debug then comment("layer_start(" .. zheight .. ")") end

    -- Function pre-calculations:
    previous_layer_zheight = current_layer_zheight
    current_layer_zheight = zheight
    previous_layer_thickness = current_layer_thickness
    current_layer_thickness = current_layer_zheight - previous_layer_zheight

    -- Start GCode first-layer insertion:
    if layer_id == 0 then
        if insert_startpre_gcode then output(get_template("startpre.g")) end

        output("G21")
        output("G90")

        if relative_extrusion then output ("M83") end -- Absolute extrusion is not yet implemented in this profile.

        if volumetric_extrusion and relative_extrusion then
            local d_string = "D" .. f(filament_diameter_mm[0])

            for i = 1, math.max(extruders[0],unpack(extruders)) do -- extruders[0] needs to be included in math.max() because lua defaults to tables starting at index 1, whereas extruders starts at 0. unpack does not check index 0.
                d_string = d_string .. ":" .. f(filament_diameter_mm[i])
            end

            output("M200 " .. d_string)
        end

        if firmware_retraction and not suppress_m207_start then
            local p_string = ""
            local z_string = ""
            local iterations = 0
            
            if enable_z_lift then z_string = " Z" .. f(z_lift_mm) end

            if rrf_3 then iterations = number_of_extruders - 1 end

            for i = 0, iterations do
                local s_string = " S" .. f(filament_priming_mm[extruders[i]])
                local f_string = " F" .. round(priming_mm_per_sec[extruders[i]] * 60,0)

                if rrf_3 then p_string = " P" .. extruders[i] end

                output("M207" .. p_string .. s_string .. f_string .. z_string)
            end
        end

        if insert_start_temp then
            local r_string = " R" .. round(default_standby_temp,1)

            for i = 0, number_of_extruders -1 do
                if enable_active_temperature_control then r_string = " R" .. round(_G["idle_extruder_temp_degree_c_" .. extruders[i]],1) end

                output("G10 P" .. extruders[i] .. " S" .. round(_G["extruder_temp_degree_c_" .. extruders[i]],1) .. r_string)
            end

            if bed_temp_degree_c ~= 0 then output("M140 S" .. round(bed_temp_degree_c,1)) end

            if wait_start_temp then output("M116") end
        end

        if insert_start_gcode then output(get_template("start.g")) end
    end

    -- Layer labeling:
    if s3d_debug then
        comment("layer " .. layer_id + 1 .. ", Z = " .. f(zheight))
    else
        comment("<layer " .. layer_id .. ">")
    end

    -- S3D Compatibility for toolpath visualization:
    if s3d_debug and f(current_layer_thickness) ~= f(previous_layer_thickness) then comment("tool H" .. f(current_layer_thickness) .. " W" .. f(_G["nozzle_diameter_mm_" .. current_extruder])) end

    -- Movement Diagnostic output:
    if move_debug and fff(current_layer_thickness) ~= fff(previous_layer_thickness) then comment("LH: " .. fff(previous_layer_thickness) .. " -> " .. fff(current_layer_thickness)) end

    -- GCode output:
    local f_string = ""

    if current_feedrate ~= z_movement_speed_mm_per_sec * 60 then
        set_feedrate(z_movement_speed_mm_per_sec * 60)
        f_string = " F" .. round(current_feedrate,0)
    end

    output("G1 Z" .. f(zheight) .. f_string)

    -- Function post-calculations:
    previous_z = zheight
end

function layer_stop()
    -- Function Diagnostic output:
    if function_debug then comment("layer_stop()") end
    -- Function not used by profile.
end

function extruder_start()
    -- Function Diagnostic output:
    if function_debug then comment("extruder_start()") end
    -- Function not used by profile.
end

function extruder_stop()
    -- Function Diagnostic output:
    if function_debug then comment("extruder_stop()") end
    -- Function not used by profile.
end

function select_extruder(extruder) -- An assumption is made that select_extruder() is only called by IceSL and only at the beginning of the GCode output.
    -- Function Diagnostic output:
    if function_debug then comment("select_extruder(" .. extruder .. ")") end

    -- GCode output:
    if suppress_rrf_tool_macros_at_start and not suppress_all_tool_selection_at_start then 
        output("T" .. extruder .. " P0")
    elseif not suppress_all_tool_selection_at_start then 
        output("T" .. extruder)
    end

    -- Function post-calculations:
    selecting_tools_at_start = true
    previous_extruder = current_extruder
    current_extruder = extruder
end

function swap_extruder(from,to,x,y,z)
    -- Function Diagnostic output:
    if function_debug then comment("swap_extruder(" .. from .. "," .. to .. "," .. x .. "," .. y .. "," .. z .. ")") end

    -- GCode output:
    if insert_swappre_gcode then output(get_template("swappre.g",{from=from,to=to,x=x,y=y,z=z})) end

    output("T" .. to)

    if insert_swap_gcode then output(get_template("swap.g",{from=from,to=to,x=x,y=y,z=z})) end

    -- Function post-calculations:
    previous_extruder = from
    current_extruder = to
end

function retract(extruder,e)
    -- Function Diagnostic output:
    if function_debug then comment("retract(" .. extruder .. "," .. e .. ")") end

    -- GCode output:
    if not selecting_tools_at_start then
        local g_string = "G1"
        local e_string = ""
        local f_string = ""

        if firmware_retraction then
            g_string = "G10"
        else
            if volumetric_extrusion and relative_extrusion then
                e_string = " E-" .. ff(to_mm_cube(filament_priming_mm[extruder],filament_diameter_mm[extruder]))
            elseif relative_extrusion then
                e_string = " E-" .. ff(filament_priming_mm[extruder])
            end

            set_feedrate(priming_mm_per_sec[extruder] * 60)
            f_string = " F" .. round(current_feedrate,0)
        end

        output(g_string .. e_string .. f_string)
    elseif function_debug then
        comment("retract() skipped due to start tool selection")
    end

    -- Function post-calculations:
    return e
end

function prime(extruder,e)
    -- Function Diagnostic output:
    if function_debug then comment("prime(" .. extruder .. "," .. e .. ")") end

    -- GCode output:
    if not selecting_tools_at_start then
        local g_string = "G1"
        local e_string = ""
        local f_string = ""

        if firmware_retraction then
            g_string = "G11"
        else
            if volumetric_extrusion and relative_extrusion then
                e_string = " E" .. ff(to_mm_cube(filament_priming_mm[extruder],filament_diameter_mm[extruder]))
            elseif  relative_extrusion then
                e_string = " E" .. ff(filament_priming_mm[extruder])
            end

            set_feedrate(priming_mm_per_sec[extruder] * 60)
            f_string = " F" .. round(current_feedrate,0)
        end

        output(g_string .. e_string .. f_string)
    elseif function_debug then
        comment("prime() skipped due to start tool selection")
    end

    -- Function post-calculations:
    if selecting_tools_at_start then selecting_tools_at_start = false end -- We know all tools have been selected by the time prime() is called, so reset state now.
    return e
end

function move_e(e)
    -- Function Diagnostic output:
    if function_debug then comment("move_e(" .. e .. ")") end

    -- Function pre-calculations:
    local filament_to_extrude_this_move = e-already_extruded[current_extruder]
    local move_volume = 0

    if move_debug or volumetric_extrusion and relative_extrusion then move_volume = to_mm_cube(filament_to_extrude_this_move,filament_diameter_mm[current_extruder]) end

    -- Movement Diagnostic output:
    if move_debug then comment("E: " .. fff(filament_to_extrude_this_move) .. " V: " .. fff(move_volume)) end

    -- GCode output:
    local e_string = ""
    local f_string = ""

    if volumetric_extrusion and relative_extrusion then
        e_string = " E" .. ff(move_volume)
    elseif relative_extrusion then
        e_string = " E" .. ff(filament_to_extrude_this_move)
    end

    if current_feedrate ~= e_movement_speed_mm_per_sec * 60 then
        set_feedrate(e_movement_speed_mm_per_sec * 60)
        f_string = " F" .. round(current_feedrate,0)
    end

    output("G1" .. e_string .. f_string)

    -- Function post-calculations:
    already_extruded[current_extruder] = e
end

function move_xyz(x,y,z)
    -- Function Diagnostic output:
    if function_debug then comment("move_xyz(" .. x .. "," .. y .. "," .. z .. ")") end

    -- Movement Diagnostic output:
    if move_debug then
        local move_length = 0
        local zd_string = ""

        if z ~= previous_z and not firmware_retraction then
            move_length = math.sqrt((x - previous_x)^2 + (y - previous_y)^2 + (z - previous_z)^2)
            zd_string = " Z: " .. fff(z)
        else 
            move_length = math.sqrt((x - previous_x)^2 + (y - previous_y)^2)
        end

        comment("X: " .. fff(x) .. " Y: " .. fff(y) .. zd_string .. " L: " .. fff(move_length))
    end

    -- GCode Output:
    local z_string = ""
    local f_string = ""

    if z ~= previous_z and not firmware_retraction then
        z_string = " Z" .. f(z)
        previous_z = z
    end

    if current_feedrate ~= previous_feedrate then
        set_feedrate(current_feedrate) -- To set previous_feedrate and suppress subsequent redundant F commands.
        f_string = " F" .. round(current_feedrate,0)
    end

    output("G1 X" .. f(x) .. " Y" .. f(y) .. z_string .. f_string)

    -- Function post-calculations:
    previous_x = x
    previous_y = y
end

function move_xyze(x,y,z,e)
    -- Function Diagnostic output:
    if function_debug then comment("move_xyze(" .. x .. "," .. y .. "," .. z .. "," .. e .. ")") end

    -- Function pre-calculations:
    local filament_to_extrude_this_move = e-already_extruded[current_extruder]
    local move_volume = 0
    local move_length = 0
    local nonplanar_move_thickness = 0

    if s3d_debug or move_debug or volumetric_extrusion and relative_extrusion then move_volume = to_mm_cube(filament_to_extrude_this_move,filament_diameter_mm[current_extruder]) end

    if s3d_debug or move_debug then
        move_length = math.sqrt((x - previous_x)^2 + (y - previous_y)^2 + (z - previous_z)^2)
        previous_move_calculated_extrusion_width = current_move_calculated_extrusion_width
        current_move_calculated_extrusion_width = move_volume / (current_layer_thickness * move_length)
        if z~= previous_z then nonplanar_move_thickness = move_volume / (move_length * _G["nozzle_diameter_mm_" .. current_extruder]) end
    end

    -- Path labeling:
    if path_is_perimeter and previous_path_was ~= "perimeter" then
        if      craftware_debug     then output(";segType:Perimeter")
        elseif  s3d_debug           then comment("feature outer perimeter")
        else                             comment("perimeter")
        end
        previous_path_was = "perimeter"
    elseif path_is_cover and path_is_shell and previous_path_was ~= "cover shell" then
        if      craftware_debug     then output(";segType:Infill")
        elseif  s3d_debug           then comment("feature solid layer concentric")
        else                             comment("curved cover")
        end
        previous_path_was = "cover shell"
    elseif path_is_cover and path_is_infill and previous_path_was ~= "cover infill" then
        if      craftware_debug     then output(";segType:Infill")
        elseif  s3d_debug           then comment("feature solid layer")
        else                             comment("cover")
        end
        previous_path_was = "cover infill"
    elseif path_is_shell and not path_is_cover and previous_path_was ~= "shell" then
        if      craftware_debug     then output(";segType:HShell")
        elseif  s3d_debug           then comment("feature inner perimeter")
        else                             comment("shell")
        end
        previous_path_was = "shell"
    elseif path_is_infill and not path_is_cover and previous_path_was ~= "infill" then
        if      craftware_debug     then output(";segType:Infill")
        elseif  s3d_debug           then comment("feature infill")
        else                             comment("infill")
        end
        previous_path_was = "infill"
    elseif path_is_brim and previous_path_was ~= "brim" then
        if      craftware_debug     then output(";segType:Skirt")
        elseif  s3d_debug           then comment("feature skirt")
        else                             comment("brim")
        end
        previous_path_was = "brim"
    elseif path_is_raft and previous_path_was ~= "raft" then
        if      craftware_debug     then output(";segType:Raft")
        elseif  s3d_debug           then comment("feature raft")
        else                             comment("raft")
        end
        previous_path_was = "raft"
    elseif path_is_shield and previous_path_was ~= "shield" then
        if      craftware_debug     then output(";segType:Pillar")
        elseif  s3d_debug           then comment("feature ooze shield")
        else                             comment("shield")
        end
        previous_path_was = "shield"
    elseif path_is_tower and previous_path_was ~= "tower" then
        if      craftware_debug     then output(";segType:Pillar")
        elseif  s3d_debug           then comment("feature prime pillar")
        else                             comment("tower")
        end
        previous_path_was = "tower"
    elseif path_is_support and previous_path_was ~= "support" then
        if      craftware_debug     then output(";segType:Support")
        elseif  s3d_debug           then comment("feature support")
        else                             comment("support")
        end
        previous_path_was = "support"
    elseif path_is_bridge and previous_path_was ~= "bridge" then
        if      craftware_debug     then output(";segType:Infill")
        elseif  s3d_debug           then comment("feature bridge")
        else                             comment("bridge")
        end
        previous_path_was = "bridge"
    end

    -- Path Feedrate Override:
    local scale_factor = 1

    if layer_id == 0 and first_layer_speed_scale_percent ~= 0 then scale_factor = first_layer_speed_scale_percent / 100 end

    if      path_is_perimeter                                                                   and current_feedrate > perimeter_print_speed_mm_per_sec * 60 * scale_factor     then current_feedrate = perimeter_print_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_support                                                                     and current_feedrate > support_print_speed_mm_per_sec * 60 * scale_factor       then current_feedrate = support_print_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_cover and path_is_shell         and cover_shell_max_speed_mm_per_sec ~= 0   and current_feedrate > cover_shell_max_speed_mm_per_sec * 60 * scale_factor     then current_feedrate = cover_shell_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_cover and path_is_infill        and cover_infill_max_speed_mm_per_sec ~= 0  and current_feedrate > cover_infill_max_speed_mm_per_sec * 60 * scale_factor    then current_feedrate = cover_infill_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_shell and not path_is_cover     and shell_max_speed_mm_per_sec ~= 0         and current_feedrate > shell_max_speed_mm_per_sec * 60 * scale_factor           then current_feedrate = shell_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_infill and not path_is_cover    and infill_max_speed_mm_per_sec ~= 0        and current_feedrate > infill_max_speed_mm_per_sec * 60 * scale_factor          then current_feedrate = infill_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_raft                            and raft_max_speed_mm_per_sec ~= 0          and current_feedrate > raft_max_speed_mm_per_sec * 60 * scale_factor            then current_feedrate = raft_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_shield                          and shield_max_speed_mm_per_sec ~= 0        and current_feedrate > shield_max_speed_mm_per_sec * 60 * scale_factor          then current_feedrate = shield_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_tower                           and tower_max_speed_mm_per_sec ~= 0         and current_feedrate > tower_max_speed_mm_per_sec * 60 * scale_factor           then current_feedrate = tower_max_speed_mm_per_sec * 60 * scale_factor
    elseif  path_is_brim                            and brim_override_speed_mm_per_sec ~= 0     and current_feedrate ~= brim_override_speed_mm_per_sec * 60                     then current_feedrate = brim_override_speed_mm_per_sec * 60 -- Brims appear only for one layer, so specify their speed discretely.
    elseif  path_is_bridge                          and bridge_override_speed_mm_per_sec ~= 0   and current_feedrate ~= bridge_override_speed_mm_per_sec * 60                   then current_feedrate = bridge_override_speed_mm_per_sec * 60 -- Bridges won't appear on the first layer, so don't scale them. Also, they will inherit the perimeter speed so set their speed discretely, not as a reduction.
    end

    -- S3D Compatibility for toolpath visualization:
    if s3d_debug then
        local hs_string = ""
        local ws_string = ""
        local suffix_string = ""

        if z ~= previous_z then
            hs_string = " H" .. f(nonplanar_move_thickness)
            ws_string = " W" .. f(_G["nozzle_diameter_mm_" .. current_extruder])
            suffix_string = " Caution: Toolpath visualization is currently incompatible with non-x/y-planar print moves. These values are best guesses only."
        elseif f(current_move_calculated_extrusion_width) ~= f(previous_move_calculated_extrusion_width) then
            hs_string = " H" .. f(current_layer_thickness)
            ws_string = " W" .. f(current_move_calculated_extrusion_width)
        end

        if hs_string .. ws_string .. suffix_string ~= "" then comment("tool" .. hs_string .. ws_string .. suffix_string) end
    end

    -- Movement Diagnostic output:
    if move_debug then
        local hd_string = " H: " .. fff(current_layer_thickness)
        local wd_string = " W: " .. fff(current_move_calculated_extrusion_width)
        local suffix_string = ""

        if z ~= previous_z then
            hd_string = " H: " .. fff(nonplanar_move_thickness)
            wd_string = " W: " .. fff(_G["nozzle_diameter_mm_" .. current_extruder])
            suffix_string = " Caution: Non-x/y-planar moves can cause Movement Diagnostic info to be incorrect. These values should be verified manually."
        end

        comment("X: " .. fff(x) .. " Y: " .. fff(y) .. " Z: " .. fff(z) .. " E: " .. fff(filament_to_extrude_this_move) .. hd_string .. wd_string .. " L: " .. fff(move_length) .. " V: " .. fff(move_volume) .. suffix_string)
    end

    -- GCode output:
    local z_string = ""
    local e_string = ""
    local f_string = ""

    if z ~= previous_z then z_string = " Z" .. f(z) end

    if volumetric_extrusion and relative_extrusion then
        e_string = " E" .. ff(move_volume)
    elseif relative_extrusion then
        e_string = " E" .. ff(filament_to_extrude_this_move)
    end

    if current_feedrate ~= previous_feedrate then
        set_feedrate(current_feedrate) -- To set previous_feedrate and suppress subsequent redundant F commands.
        f_string = " F" .. round(current_feedrate,0)
    end

    output("G1 X" .. f(x) .. " Y" .. f(y) .. z_string .. e_string .. f_string)

    -- Function post-calculations:
    already_extruded[current_extruder] = e
    previous_x = x
    previous_y = y
    previous_z = z
end

function progress(percent)
    -- Function Diagnostic output:
    if function_debug then comment("progress(" .. percent .. ")") end
    -- Function not yet implemented in profile.
end

function set_feedrate(feedrate)
    -- Function Diagnostic output:
    if function_debug then comment("set_feedrate(" .. feedrate .. ")") end

    -- Function calculations
    previous_feedrate = current_feedrate
    current_feedrate = feedrate
end

function set_fan_speed(speed)
    -- Function Diagnostic output:
    if function_debug then comment("set_fan_speed(" .. speed .. ")") end

    -- Function pre-calculations:
    previous_fan_speed = current_fan_speed
    current_fan_speed = speed

    -- GCode output:
    if current_fan_speed ~= previous_fan_speed then
        if suppress_fan_at_start and previous_fan_speed == -1 then
            previous_fan_speed = 0
        else
            output("M106 S" .. round(speed/100,2))
        end
    end
end

function set_extruder_temperature(extruder,temperature)
    -- Function Diagnostic output:
    if function_debug then comment("set_extruder_temperature(" .. extruder .. "," .. temperature .. ")") end

    -- GCode output:
    if enable_active_temperature_control and not selecting_tools_at_start then
        output("G10 P" .. extruder .. " R" .. round(temperature,1))
    elseif selecting_tools_at_start and function_debug then
        comment("set_extruder_temperature() skipped due to start tool selection")
    end
end    

function set_and_wait_extruder_temperature(extruder,temperature)
    -- Function Diagnostic output:
    if function_debug then comment("set_and_wait_extruder_temperature(" .. extruder .. "," .. temperature .. ")")end

    -- GCode output:
    if not suppress_temp_control then output("M116 P" .. extruder) end
end

function wait(sec,x,y,z)
    -- Function Diagnostic output:
    if function_debug then comment("wait(" .. sec .. "," .. x .. "," .. y .. "," .. z .. ")") end

    -- GCode output:
    output(get_template("wait.g",{sec=sec,x=x,y=y,z=z}))
end

function set_mixing_ratios(ratios)
    -- Function Diagnostic output:
    if function_debug then comment("set_mixing_ratios(ratios) Note: contents of table ratios not listed in this debug output.") end
    -- Function not yet implemented in profile.
end
-- End of file.