# RepRapFirmware Configurable Printer Profile (Addiform_RRF) for IceSL
- [x] Created on 2020-APR-20 by Nathan Buxton for [Addiform](https://addiform.com)
- [x] Bugs fixed and code refactored for v1.0.1 on 2020-JUN-08
- [ ] Support for absolute extrusion coming in v1.1

### Addiform_RRF adds the following features:
- Support for firmware retraction.
- Support for volumetric extrusion.
- Support for relative extrusion.
- Compatibility with RRF tool changes.
- RRF-specific GCode output.
- RRF-compatible print info strings: object height, print time, etc.
- Toolpath visualization compatibility for S3D and CraftWare.

## IceSL is a state of the art slicer (STL → G-code) with advanced modeling capabilities.
### IceSL has the following novel slicing features, and more:
- Variable layer-height optimization.
- Robust multi-tool support.
- Active temperature control, which ensures tools are heated and cooled just in time for their use.
- Geometry-based print setting modifiers.
- Paint to specify seam locations.
- Advanced tree-like support structures.
- Supports based on toolpaths, not only meshes.
- Paint to specify support locations.
- Hollow prints with self-supporting cavities.
- Advanced and experimental infill options:
  - Progressive infill patterns that can smoothly vary in density along height.
  - Cubic, Tetrahedral and Hierarchical infills.
  - Ability to create [custom infill types](https://github.com/shapeforge/icesl-infillers/blob/master/README.md).
- High-precision slicing with controllable simplification.
- Minimum layer time, with customizable wait GCode.

### For more information about IceSL:

[IceSL Features](https://icesl.loria.fr/features/)

[IceSL Printer Profile Documentation](https://gitlab.inria.fr/mfx/icesl-documentation/-/wikis/Printer-profile)

[More IceSL Documentation](https://icesl.loria.fr/documentation/)

## Using this printer profile:

Addiform_RRF is a template for you to create a profile specific to your printer running RepRapFirmware. You should first make a copy of the `../Addiform_RRF/` directory and rename it for your printer, so that updates to the Addiform_RRF profile template do not overwrite your changes.

### IceSL printer profiles are made up of several components:
- `printer.lua` -- functions that produce GCode output
- `features.lua` -- printer parameters and default settings
- `profiles/*.lua` --  optional print parameters for different scenarios
- `materials/*.lua` -- optional print parameters for different materials
- `*.g` or `*.gcode` -- templates for insertion into final GCode

>***Note: The file `printer.lua` is not intended to be modified by the user, unless to implement new features, fix bugs, or modify behaviour. Refer to `features.lua` for user-configurable printer parameters.***

#### IceSL gives priority to an assignment of print settings according to the following list:
1. Default IceSL values -- bottom priority
2. Printer features (`features.lua`)
3. Print profile (e.g., fast print, high quality, etc.)
4. Material profile (e.g., abs, pla, etc.)
5. Lua script (user-made script loaded into IceSL for modelling and other purposes)
6. Graphical User Interface (GUI) -- top priority

## Print Profiles: `profiles/*.lua`
Print profiles are optional, can be created for different scenarios, and can be named anything the user wishes. A profile might be created for high quality settings, fast print settings, or settings for a specific type of job like miniatures or lithophanes. These pre-made profiles are selectable by a dropdown in the IceSL GUI.

They contain the name of the profile in different regional languages and any variable assignments to the desired values.

```lua
-- file: /profiles/high.lua
name_en = "High Quality"
name_es = "Calidad Alta"
name_fr = "Haute Qualité"
name_ch = "高质量"

-- This is only an example.
z_layer_height_mm = 0.05
print_speed_mm_per_sec = 30
```
## Material Profiles: `materials/*.lua`
Material profiles are optional and can be created to supplement the above-mentioned print profiles. These pre-made profiles are selectable by a dropdown in the IceSL GUI.

They contain the name of the material in different regional languages and any variable assignments to the desired values.

```lua
-- file: /materials/pla.lua
name_en = "PLA"
name_es = "PLA"
name_fr = "PLA"
name_ch = "PLA"

-- This is only an example.
extruder_temp_degree_c = 180
```

>**Note: The user may modify settings defined in pre-made `*.lua` profiles from within the IceSL GUI, but they can not save back directly to the pre-made profiles. Instead, they can save custom settings to XML files within the IceSL GUI.<br/><br/>If no print or material profiles are present, the 'Custom' profile will be used by default, which merely inherits all defaults from IceSL and `features.lua`.**

## GCode Insertion Templates: `start.g`, `wait.g`, `end.g`, ...
These GCode files can optionally be automatically inserted into final GCode output during specific print operations. They can contain any GCode the user wishes. There are variables which can be passed through to the GCode production process, allowing for print settings to be passed to the templates.

The file `wait.g` is inserted in order to achieve a minimum layer time when 'Enable minimum printing time for layers' is enabled and 'Function 'wait'' is selected as the method.

### The following is a list of the placeholders available for replacement:
| Placeholder | Availability | Description |
| ---: | :---: | --- |
| `<z_lift>` | All templates | travel Z-lift height |
| `<extruder_swap_retract_length>` | All templates | tool swap retraction length |
| `<extruder_swap_retract_speed>` | All templates | tool swap retraction speed, converted to mm/min |
| `<extruder_swap_z_lift>` | All templates | tool swap Z-lift height |
| `<current_layer_zheight>` | All templates | absolute Z height of the current layer |
| `<fan_percent>` | All templates | current fan speed percentage represented as 0.0 to 1.0 |
| `<e_movement_speed>` | All templates | extruder movement speed from custom settings, converted to mm/min |
| `<z_movement_speed>` | All templates | Z axis movement speed from custom settings, converted to mm/min |
| `<travel_speed>` | All templates | travel speed, converted to mm/min |
| `<print_x_min>` | All templates | minimum X coordinate of printed object(s) |
| `<print_x_max>` | All templates | maximum X coordinate of printed object(s) |
| `<print_y_min>` | All templates | minimum Y coordinate of printed object(s) |
| `<print_y_max>` | All templates | maximum Y coordinate of printed object(s) |
| `<print_z_max>` | All templates | maximum Z coordinate of printed object(s) |
| `<current_extruder>` | All except `swap*.g` | ID number of the current tool |
| `<retract_length>` | All except `swap*.g` | retraction length of the current tool |
| `<retract_speed>` | All except `swap*.g` | retraction speed of the current tool, converted to mm/min |
| `<from_extruder>` | Only `swap*.g` | ID number of the tool being deselected |
| `<to_extruder>` | Only `swap*.g` | ID number of the tool being selected |
| `<retract_length_from>` | Only `swap*.g` | retraction length of the tool being deselected |
| `<retract_length_to>` | Only `swap*.g` | retraction length of the tool being selected |
| `<retract_speed_from>` | Only `swap*.g` | retraction speed of the tool being deselected, converted to mm/min |
| `<retract_speed_to>` | Only `swap*.g` | retraction speed of the tool being selected, converted to mm/min |
| `<x>` | Only `swap*.g` and `wait.g` | X coordinate at beginning and end of template |
| `<y>` | Only `swap*.g` and `wait.g` | Y coordinate at beginning and end of template |
| `<z>` | Only `swap*.g` and `wait.g` | Z coordinate at beginning and end of template |
| `<sec>` | Only `wait.g` | number of whole seconds required to wait |

>**Dev. note: Additional templates and placeholders can be added to `printer.lua` with the `get_template()` function.**

## Printer Features: `features.lua`
IceSL provides default values for all of the settings of its built-in features. In `features.lua`, these defaults can be changed.

Addiform_RRF’s `features.lua` template provides a list of all settings/variables that can be set through `features.lua`, the IceSL GUI, Lua scripts, print profiles and/or material presets. This is only for convenience. None of the native IceSL settings need to be in `features.lua`, unless to change the default values for your printer.

>***Note: The template `features.lua` also contains additional settings/variables for features added by Addiform_RRF. These variables must all remain initialized in `features.lua`, but can be changed to have different starting values.***

### The features added to IceSL by the Addiform_RRF printer profile are as follows:
| Name | Type | Description |
| ----: | :----: | --- |
| S3D Compatibility<br/>`s3d_debug` | `bool` | Create S3D-compatibile comments for toolpath visualization, as well as path and layer labeling. |
| CraftWare Path Labeling<br/>`craftware_debug` | `bool` | Create path labels similar to CraftWare's in place of IceSL or S3D-compatibile path labels. |
| Movement Diagnostic<br/>`move_debug` | `bool` | Enable diagnostic output of movement in GCode comments. |
| Function Diagnostic<br/>`function_debug` | `bool` | Enable diagnostic output of functions in GCode comments. |
| Relative Extrusion<br/>`relative_extrusion` | `bool` | Create relative extruder movement commands in GCode output.<br/><br/>If disabled, no extrusion will be generated, since absolute extrusion is not yet implemented in this profile. |
| Volumetric Extrusion<br/>`volumetric_extrusion` | `bool` | Create volumetric extrusion commands using the per-extruder filament diameters configured in IceSL.<br/><br/>Requires Relative Extrusion to be enabled. |
| RRF Version 3.01+<br/>`rrf_3` | `bool` | Generate RRF 3.01+ compatible GCode commands.<br/><br/>Currently this only affects `M207` firmware retraction GCode. |
| Firmware Retraction<br/>`firmware_retraction` | `bool` | Generate firmware retraction `G10`/`G11` commands. Uses retraction settings from GUI to set initial values in `M207` command.<br/><br/>Non-zero 'Filament retract' must be set in GUI to produce `G10`/`G11` retraction commands!<br/><br/>When using RRF Version 3.01 or higher, firmware retraction is set on a per-extruder basis. Otherwise, in order to comply with limitations of older RRF versions, only the values from the first-indexed extruder will be used in `M207`. |
| Suppress M207 at Start<br/>`suppress_m207_start` | `bool` | Suppress `M207` command at start. This allows the user to set their own `M207` firmware retraction parameters elsewhere. |
| Insert Start GCode<br/>`insert_start_gcode` | `bool` | Insert `start.g` into GCode output before the first layer has started.<br/><br/>Settings from the GUI can be passed to the script to create tailored GCode. See `start.g` template for variables. |
| Insert Pre-Start GCode<br/>`insert_startpre_gcode` | `bool` | Insert `startpre.g` into GCode output before temperatures and other options are set.<br/><br/>Settings from the GUI can be passed to the script to create tailored GCode. See `startpre.g` template for variables. |
| Insert End GCode<br/>`insert_end_gcode` | `bool` | Insert `end.g` into GCode output after the print is finished.<br/><br/>Settings from the GUI can be passed to the script to create tailored GCode. See `end.g` template for variables. |
| Set Temperatures at Start<br/>`insert_start_temp` | `bool` | Set tool and bed temperatures at print start. |
| Wait for Temperatures at Start<br/>`wait_start_temp` | `bool` | Wait at start for temperatures to be reached. |
| Suppress RRF Tool Macros at Start<br/>`suppress_rrf_tool_macros_at_start` | `bool` | Suppress RRF tool change macros at starting tool selection.<br/><br/>Sends `T* P0`. |
| Suppress All Tool Selections at Start<br/>`suppress_all_tool_selection_at_start` | `bool` | Allows for manual tool selection in Start GCode. |
| Suppress Fan Command at Start<br/>`suppress_fan_at_start` | `bool` | Allows for manual insertion of fan commands in Start GCode. |
| Insert Swap GCode<br/>`insert_swap_gcode` | `bool` | Insert `swap.g` into GCode output after tool change commands. Commands will be executed after the RRF tool change macros.<br/><br/>Settings from the GUI can be passed to the script to create tailored GCode. See `swap.g` template for variables. |
| Insert Pre-Swap GCode<br/>`insert_swappre_gcode` | `bool` | Insert `swappre.g` into GCode output immediately before tools are changed. Commands will be executed before the RRF tool change macros.<br/><br/>Settings from the GUI can be passed to the script to create tailored GCode. See `swappre.g` template for variables. |
| Suppress Temp Control at Tool Change<br/>`suppress_temp_control` | `bool` | Suppress `M116` calls after a tool is selected. This is to give full control to the RRF tool change macros. |
| Default Tool Standby Temperature<br/>`default_standby_temp` | `float` | Standby temperature for tools if active temperature control is not enabled. |
| Z Axis Movement Speed<br/>`z_movement_speed_mm_per_sec` | `float` | Movement speed in mm/sec for all Z axis moves. |
| Extruder-Only Movement Speed<br/>`e_movement_speed_mm_per_sec` | `float` | Movement speed in mm/sec for all extruder-only moves. |
| Maximum Shell Speed<br/>`shell_max_speed_mm_per_sec` | `float` | Shell paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Infill Speed<br/>`infill_max_speed_mm_per_sec` | `float` | Infill paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Raft Speed<br/>`raft_max_speed_mm_per_sec` | `float` | Raft paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Shield Speed<br/>`shield_max_speed_mm_per_sec` | `float` | Shield paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Tower Speed<br/>`tower_max_speed_mm_per_sec` | `float` | Tower paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Cover Speed<br/>`cover_infill_max_speed_mm_per_sec` | `float` | Cover paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Maximum Curved Cover Speed<br/>`cover_shell_max_speed_mm_per_sec` | `float` | Curved cover paths will have their print speed reduced to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| First Layer Maximum Speed Scale %<br/>`first_layer_speed_scale_percent` | `float` | Percentage of the above max speeds to use for the first layer.<br/>Also scales perimeter speed and support speed on first layer.<br/><br/>Does not scale Brim Speed Override nor the default speed for the first layer: 'Print speed on first layer'.<br/><br/>Set to 0 to disable scaling of speeds for first layer. |
| Brim Speed Override<br/>`brim_override_speed_mm_per_sec` | `float` | Brim paths will have their print speed set to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |
| Bridge Speed Override<br/>`bridge_override_speed_mm_per_sec` | `float` | Bridge paths will have their print speed set to this value.<br/><br/>Set to 0 to revert to default speed.<br/><br/>unit: mm/sec |

For Miren :rainbow:

--

Copyright (c) 2020, X3D Technologies Inc dba Addiform.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
- Neither the names of Addiform and X3D Technologies Inc nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL X3D Technologies Inc dba Addiform BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.