-- Blur behind the bar's flyouts when the bar is glassy. The flyouts draw in
-- the shell's keyboard-panel layer. Service.qml runs this file when it starts
-- and after every Hyprland reload, which forgets layer rules. Omarchy reloads
-- Hyprland whenever the glassy toggle file comes or goes.
local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local glassy = io.open(state_home .. "/omarchy/toggles/hypr/bar-glassy.lua")
if glassy then
  glassy:close()
  hl.layer_rule({ match = { namespace = "^omarchy-keyboard-panel$" }, blur = true, ignore_alpha = 0.3 })
end
