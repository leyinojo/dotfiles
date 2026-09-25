local wezterm = require('wezterm')
local config = wezterm.config_builder()
local colors = require('colors')

require('events')

config.default_cwd = wezterm.home_dir
config.exit_behavior = 'Close'
config.status_update_interval = 1000
config.max_fps = 120
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.macos_window_background_blur = 10
config.initial_cols = 200
config.initial_rows = 55


config.color_scheme = colors.theme_name
config.inactive_pane_hsb = {
  saturation = 0.25,
  brightness = 0.25,
}

config.colors = {
  cursor_bg = colors.highlight,
  cursor_border = colors.highlight,
  split = colors.alpha(colors.selection_bg, 0.9),
  tab_bar = {
    background = 'none',
    inactive_tab_edge = 'none',
    new_tab = {
      bg_color = 'none',
      fg_color = colors.selection_bg,
    },
    new_tab_hover = {
      bg_color = 'none',
      fg_color = colors.highlight,
    },
    inactive_tab = {
      bg_color = 'none',
      fg_color = colors.selection_bg,
    },
    inactive_tab_hover = {
      bg_color = 'none',
      fg_color = colors.lighten_selection,
    },
    active_tab = {
      bg_color = 'none',
      fg_color = colors.highlight,
      intensity = 'Bold',
    },
  },
}

config.background = {
  {
    source = { Color = colors.bg_dark },
    width = '100%',
    height = '100%',
    opacity = 0.95,
  },
}

config.font = wezterm.font {
  family = 'Iosevka NF Light',
  style = 'Normal',
}
config.font_size = 16
config.command_palette_font_size = 16
config.cell_width = 1
config.line_height = 1

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations =
'RESIZE|MACOS_FORCE_DISABLE_SHADOW'
config.window_frame = {
  font = wezterm.font { family = 'Iosevka NF Light' },
  font_size = 16,
  active_titlebar_bg = 'none',
  inactive_titlebar_bg = 'none',
}

config.keys = require('keys')

return config
