-- E3D Toolchanger
-- Hugron Pierre-Alexandre  2021-09-21

extruder_e         = {} -- absolute E value as seen by IceSL
extruder_e_restart = {} -- absolute E at which we issued a G92 E0
for i=0,3 do
  extruder_e[i]         = 0
  extruder_e_restart[i] = 0
end

-- initially we set to false to indicate that we did not dock the extruders
-- ourselves, which allow us to skip the 'prime' after undocking
extruder_docked = {false,false,false,false}

changed_frate = false

current_z         = 0
current_frate     = 0
current_extruder  = - 1
current_fan_speed = -1
last_setup_extruder = -1

--##################################################

function comment(text)
  output('; ' .. text)
end

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function header()
  local h = file('header.gcode')
  h = h:gsub( '<HBPTEMP>', bed_temp_degree_c )
  output(h)
  comment('---- modified ----')
end

function footer()
  local h = file('footer.gcode')
  output(h)
end

function retract(extruder,e)
  output(';retract')
  local len     = filament_priming_mm[extruder]
  local speed   = retract_mm_per_sec[extruder] * 60
  local e_value = e - len - extruder_e_restart[extruder]
  output('G1 F' .. speed .. ' E' .. ff(e_value))
  extruder_e[extruder] = e - len
  current_frate = speed
  changed_frate = true
  return e - len
end

function prime(extruder,e)
  output(';prime')
  local len   = filament_priming_mm[extruder]
  local speed = priming_mm_per_sec[extruder] * 60
  local e_value = e + len - extruder_e_restart[extruder]
  output('G1 F' .. speed .. ' E' .. ff(e_value))
  extruder_e[extruder] = e + len
  current_frate = speed
  changed_frate = true
  return e + len
end

function layer_start(zheight)
  output('; <layer ' .. layer_id .. '>')
  local frate = 600
  if not layer_spiralized then
    if layer_id == 0 then
      output('G0 F' .. frate .. ' Z' .. ff(zheight))
    else
      frate = 100
      output('G0 F' .. frate .. ' Z' .. ff(zheight))
    end
  end
  current_z     = zheight
  current_frate = frate
  changed_frate = true
end

function layer_stop()
  output('; </layer>')
end

-- this is called once for each used extruder at startup
num_selected = 0
function select_extruder(extruder)
  -- heat up nozzle
  output('M109 T' .. extruder .. ' S' .. extruder_temp_degree_c[extruder])
  last_setup_extruder = extruder
  num_selected = num_selected + 1
  if num_selected == number_of_extruders then
    -- we will be using this one now
    current_extruder = extruder
    undock_extruder(extruder)
  end
end

function dock_extruder(extruder)
  output(';dock_extruder')
  -- reset E
  output('G92 E0')
  extruder_e_restart[extruder] = extruder_e[extruder]
  -- store filament (large retract)
  local len   = extruder_swap_retract_length_mm
  local speed = extruder_swap_retract_speed_mm_per_sec * 60;
  output('G0 F' .. speed .. ' E' .. -len) -- we just reset E
  output('G92 E0')
  extruder_docked[extruder] = true
end

function undock_extruder(extruder)
  output(';undock_extruder')
  output('T' .. extruder)
  -- reset E axis
  output('G92 E0')
  extruder_e_restart[extruder] = extruder_e[extruder]
  if extruder_docked[extruder] then
    -- unstore filament (large prime)
    local len   = extruder_swap_retract_length_mm
    local speed = extruder_swap_retract_speed_mm_per_sec * 60;
    output('G0 F' .. speed .. ' E' .. len) -- we just reset E
    output('G92 E0')
  end
  extruder_docked[extruder] = false
  current_z = 0.0 -- invalidate z
end

function set_fan_speed(speed)
  local fan={2,4,6,8} -- fan names
  if current_extruder > -1 then
    output('M106 S'.. math.floor(255 * speed/100) .. ' P' .. fan[1+current_extruder])
  end
end

-- this is called during print when changing extruder
function swap_extruder(from,to,x,y,z)
  if from == to then
    return
  end
  -- note: current_extruder == from
  output(';swap_extruder')
  set_fan_speed(0)
  if current_extruder > -1 then
    dock_extruder(current_extruder)
  end
  current_extruder = to
  undock_extruder(to)
  set_fan_speed(255)
  -- done
  current_frate = travel_speed_mm_per_sec * 60
  changed_frate = true
end

function set_mixing_ratios(ratios)
end

function move_xyz(x,y,z)
  if z == current_z then
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y))
    end
  else
    if changed_frate == true then
      output('G0 F' .. f(current_frate) .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
      changed_frate = false
    else
      output('G0 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    end
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  local e_value = e - extruder_e_restart[current_extruder]

  if current_extruder == 1 then
    -- HACK: calibration
    y = y - 0.35
  end

  if z == current_z then
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e_value))
    end
  else
    if changed_frate == true then
      output('G1 F' .. current_frate .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
      changed_frate = false
    else
      output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e_value))
    end
    current_z = z
  end
end

function move_e(e)
  local e_value = e - extruder_e_restart[current_extruder]
  if changed_frate == true then
    output('G1 F' .. current_frate .. ' E' .. ff(e_value))
    changed_frate = false
  else
    output('G1 E' .. ff(e_value))
  end
end

function set_feedrate(feedrate)
  if feedrate ~= current_frate then
    current_frate = feedrate
    changed_frate = true
  end
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 T' .. extruder .. ' S' .. f(temperature))
end

function set_and_wait_extruder_temperature(extruder,temperature)
  output('M109 T' .. extruder .. ' S' .. f(temperature))
end

function wait(sec,x,y,z)
  output("; WAIT --" .. sec .. "s remaining" )
  output("G4 S" .. sec .. "; wait for " .. sec .. "s")
end
