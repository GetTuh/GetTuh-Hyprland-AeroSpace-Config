-- Lua port of UserConfigs/WindowRules.conf.
local user_window_rules_helper = nil
do
  local source = (debug.getinfo(1, "S") or {}).source or ""
  local source_path = source:match("^@(.+)$")
  local source_dir = source_path and source_path:match("^(.*)/[^/]+$") or nil
  local home = os.getenv("HOME") or ""
  local candidate_paths = {
    source_dir and (source_dir .. "/../lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/user_window_rules_helper.lua") or nil,
  }

  local tried_paths = {}
  for _, helper_path in ipairs(candidate_paths) do
    if helper_path then
      table.insert(tried_paths, helper_path)
      local f = io.open(helper_path, "r")
      if f then
        f:close()
        local loaded_ok, loaded_helpers = pcall(dofile, helper_path)
        if loaded_ok and type(loaded_helpers) == "table" and loaded_helpers.apply_window_rule then
          user_window_rules_helper = loaded_helpers
          break
        end
      end
    end
  end

  if not user_window_rules_helper then
    error("Failed to load user_window_rules_helper.lua from: " .. table.concat(tried_paths, ", "))
  end
end

local apply_window_rule = user_window_rules_helper.apply_window_rule

-- Force full opacity on every window. Sourced after configs/system_window_rules.lua,
-- which has a bunch of per-tag/per-class opacity rules (browser, terminal,
-- file-manager, PiP, wallpaper picker, etc.) -- this catch-all matches every
-- window and, coming later, wins for all of them.
-- NOTE: opacity takes the raw hyprlang "opacity <active> <inactive>" string,
-- not a table -- verified live via hyprctl eval (a table throws "field opacity
-- string type requires a string").
apply_window_rule({
    name = "user-force-full-opacity",
    match = { class = ".*" },
    opacity = "1.0 1.0",
})
