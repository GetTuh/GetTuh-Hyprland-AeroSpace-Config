-- Lua port of the old UserConfigs/UserKeybinds.conf (removed once hyprland.lua
-- became the sole entrypoint on this machine).
local user_keybinds_helper = nil
do
  local source = (debug.getinfo(1, "S") or {}).source or ""
  local source_path = source:match("^@(.+)$")
  local source_dir = source_path and source_path:match("^(.*)/[^/]+$") or nil
  local home = os.getenv("HOME") or ""
  local candidate_paths = {
    source_dir and (source_dir .. "/../lua/user_keybinds_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/lua/user_keybinds_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/user_keybinds_helper.lua") or nil,
  }

  local tried_paths = {}
  for _, helper_path in ipairs(candidate_paths) do
    if helper_path then
      table.insert(tried_paths, helper_path)
      local f = io.open(helper_path, "r")
      if f then
        f:close()
        local loaded_ok, loaded_helpers = pcall(dofile, helper_path)
        if loaded_ok and type(loaded_helpers) == "table" and loaded_helpers.bind then
          user_keybinds_helper = loaded_helpers
          break
        end
      end
    end
  end

  if not user_keybinds_helper then
    error("Failed to load user_keybinds_helper.lua from: " .. table.concat(tried_paths, ", "))
  end
end

local exec_cmd = user_keybinds_helper.exec_cmd
local bind = user_keybinds_helper.bind
local unbind = user_keybinds_helper.unbind
local dispatch = user_keybinds_helper.dispatch

local mainMod = "SUPER"
local home = os.getenv("HOME") or ""
local scriptsDir = home .. "/.config/hypr/scripts"
local userScripts = home .. "/.config/hypr/UserScripts"

--------------
--  Rebinds  --
--------------

-- Tap bare Super -> app launcher (drun). Not an override of an existing bind
-- (base config ships this commented out), so no unbind needed first.
bind(mainMod, "SUPER_L", exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"), { release = true })

-- OPTIONAL upgrade: type math into the same launcher and get an inline result,
-- instead of using the Calculator entry in the extras menu below. Requires the
-- rofi-calc plugin (package name "rofi-calc"; AUR on Arch, may need building
-- from https://github.com/svenstaro/rofi-calc elsewhere) plus `qalc` (libqalculate).
-- If you install both, replace the bind above with:
-- bind(mainMod, "SUPER_L", exec_cmd("pkill rofi || rofi -show combi -combi-modi \"drun,calc\""), { release = true })

-- Single menu for everything unbound below -- add new entries in the script,
-- not new binds here.
bind(mainMod, "X", exec_cmd(userScripts .. "/ExtrasMenu.sh"), { description = "Extras menu" })

-- Clipboard manager: Super+Alt+V -> Super+V (Super+Alt+V stays bound to vertical scroll down)
unbind(mainMod .. " ALT", "V") -- Clipboard manager
bind(mainMod, "V", exec_cmd(scriptsDir .. "/ClipManager.sh"), { description = "Clipboard manager" })

-- Desktop overview: Super+A -> Super+D. Super+D's old app launcher is redundant
-- with the bare-Super-tap drun rebind above, so it's freed up rather than swapped.
unbind(mainMod, "D") -- App launcher
unbind(mainMod, "A") -- Desktop overview
bind(mainMod, "D", exec_cmd(scriptsDir .. "/OverviewToggle.sh"), { description = "Desktop overview" })

--------------
--  unbinds  --
--------------

-- --- Wallpaper: all moved to the extras menu (Super+X), no dedicated hotkey. ---
unbind(mainMod, "W") -- Wallpaper picker
unbind(mainMod .. " SHIFT", "W") -- Wallpaper effects menu
unbind("CTRL ALT", "W") -- Random wallpaper

-- --- Pure novelty / theming gimmicks -- all moved to the extras menu (Super+X) ---
unbind(mainMod .. " SHIFT", "M") -- RofiBeats (online music via rofi)
unbind(mainMod .. " SHIFT", "O") -- Oh-my-zsh theme switcher
unbind(mainMod .. " SHIFT", "B") -- Static rainbow border toggle
unbind(mainMod .. " SHIFT", "A") -- Animations preset menu
unbind(mainMod .. " ALT", "E") -- Emoji picker
unbind(mainMod .. " CTRL", "G") -- Ghostty theme selector
unbind(mainMod .. " CTRL SHIFT", "R") -- Rofi theme selector (modified) -- dup of Super+Ctrl+R
unbind(mainMod .. " CTRL", "B") -- Waybar style menu
unbind(mainMod .. " ALT", "B") -- Waybar layout menu
bind(mainMod .. " ALT", "B", exec_cmd("pkill -SIGUSR1 waybar"), { description = "Hide waybar" })

-- Toggle split (dwindle): Super+Shift+I -> Super+/
unbind(mainMod .. " SHIFT", "I") -- Toggle split (dwindle)
bind(mainMod, "slash", dispatch("layoutmsg", "togglesplit"), { description = "Toggle split (dwindle)" })

-- Monitor sleep (screen off only, not full system suspend -- that's xf86Sleep)
bind(mainMod, "L", dispatch("dpms", "off"), { description = "Sleep monitors" })

-- Move workspace to monitor: re-pin via MoveWorkspaceToMonitor.sh so the static
-- monitor: assignment in workspaces.conf doesn't snap the workspace back.
unbind(mainMod .. " CTRL", "F9") -- Move workspace to left monitor
unbind(mainMod .. " CTRL", "F10") -- Move workspace to right monitor
unbind(mainMod .. " CTRL", "F11") -- Move workspace to up monitor
unbind(mainMod .. " CTRL", "F12") -- Move workspace to down monitor
bind(mainMod .. " CTRL", "F9", exec_cmd(userScripts .. "/MoveWorkspaceToMonitor.sh l"), { description = "Move workspace to left monitor" })
bind(mainMod .. " CTRL", "F10", exec_cmd(userScripts .. "/MoveWorkspaceToMonitor.sh r"), { description = "Move workspace to right monitor" })
bind(mainMod .. " CTRL", "F11", exec_cmd(userScripts .. "/MoveWorkspaceToMonitor.sh u"), { description = "Move workspace to up monitor" })
bind(mainMod .. " CTRL", "F12", exec_cmd(userScripts .. "/MoveWorkspaceToMonitor.sh d"), { description = "Move workspace to down monitor" })

-- For passthrough keyboard into a VM
-- bind(mainMod .. " ALT", "P", dispatch("submap", "passthru"))
-- submap = passthru
-- to unbind
-- bind(mainMod .. " ALT", "P", dispatch("submap", "reset"))
-- submap = reset
