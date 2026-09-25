local wezterm = require('wezterm')
local mux = wezterm.mux
local helpers = require('helpers')
local colors = require('colors')

local function apply_padding(gui)
  local min_padding = 20
  local pane = gui:active_pane()
  local dims = gui:get_dimensions()
  local pane_dims = pane:get_dimensions()
  local cell_width = pane_dims.pixel_width / pane_dims.cols
  local cols = math.floor(
    (dims.pixel_width - 2 * min_padding) / cell_width
  )
  local padding = math.floor(
    (dims.pixel_width - cols * cell_width) / 2
  )

  gui:set_config_overrides({
    window_padding = {
      left = padding,
      right = padding,
      top = 10,
      bottom = 0,
    },
    window_decorations = 'MACOS_FORCE_DISABLE_SHADOW',
  })
end

local function update_right_status(window, pane)
  if not pane then
    pane = window:active_pane()
  end
  if not pane then return end

  local status = ''
  local is_ssh = false

  local ssh_host = helpers.get_ssh_host(pane)
  if ssh_host then
    status = ssh_host
    is_ssh = true
  else
    local cwd = pane:get_current_working_dir()
    if cwd and cwd.file_path then
      status = helpers.shorten_path(cwd.file_path)
    end
  end

  local color = is_ssh and colors.status_ssh or colors.status_default

  window:set_right_status(wezterm.format {
    { Foreground = { Color = color } },
    { Text = status },
    { Text = '  ' },
  })
end

wezterm.on('format-tab-title', function(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return { { Text = ' ' .. title .. ' ' } }
  end

  local pane = mux.get_pane(tab.active_pane.pane_id)
  if pane then
    local icon = helpers.get_process_icon(pane)
    if icon then
      return { { Text = ' ' .. icon .. ' ' } }
    end
  end

  return { { Text = '  ' } }
end)

wezterm.on('update-status', function(window, pane)
  update_right_status(window, pane)
end)

wezterm.on('window-focus-changed', function(window, pane)
  update_right_status(window, pane)
end)

wezterm.on('window-config-reloaded', function(window)
  apply_padding(window)
end)

wezterm.on('window-resized', apply_padding)

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  local gui = window:gui_window()
  gui:toggle_fullscreen()
  apply_padding(gui)
end)

