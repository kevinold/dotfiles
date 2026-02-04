-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--config.automatically_inject_wezterm_shell_integration = false
config.default_prog = { "/bin/zsh" }

config.font_size = 22

config.audible_bell = "Disabled"

--wezterm.on("gui-startup", function(cmd)
-- allow `wezterm start -- something` to affect what we spawn
-- in our initial window
--local args = {}
--if cmd then
--	args = cmd.args
--end

-- Set a workspace for coding on a current project
--local project_dir = wezterm.home_dir .. "/giggs"
--local tab, build_pane, window = mux.spawn_window({
--	workspace = "giggs",
--	cwd = project_dir,
--	args = args,
--})
--local web_tab, web_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--web_tab:set_title("Giggs Web")
--web_pane:send_text("pnpm run dev:web\n")

--local backend_tab, backend_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--backend_tab:set_title("Giggs Backend")
--backend_pane:send_text("pnpm run dev:backend\n")

--local partners_tab, partners_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--partners_tab:set_title("Giggs Partners")
--partners_pane:send_text("cd apps/partners; pnpm run dev:partners\n")

--local admin_tab, admin_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--admin_tab:set_title("Giggs Admin")
--admin_pane:send_text("cd apps/admin; pnpm run dev:admin\n")

--local typesense_tab, typesense_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--typesense_tab:set_title("TypeSense")
--typesense_pane:send_text("./scripts/run-typesense.sh\n")

--local git_tab, git_pane = window:spawn_tab({
--	cwd = project_dir,
--})
--git_tab:set_title("Git")

-- We want to startup in the giggs workspace
--mux.set_active_workspace("giggs")
--end)

--wezterm.on('gui-startup', function(window)
--  local tab, pane, window = mux.spawn_window(cmd or {})
--end)
--  local gui_window = window:gui_window();
--  gui_window:maximize()

-- config.native_macos_fullscreen_mode = true

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm
config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

return config
