local wezterm = require('wezterm')

local theme_name = 'Catppuccin Macchiato'
local scheme = wezterm.color.get_builtin_schemes()[theme_name]
local highlight = '#ffcc66'
local selection_bg = scheme.selection_bg
local lighten_selection =
  wezterm.color.parse(selection_bg):lighten(0.3)
local bg_dark =
  wezterm.color.parse(scheme.background):darken(0.25)

local function alpha(c, a)
  local h, s, l = wezterm.color.parse(c):hsla()
  return tostring(wezterm.color.from_hsla(h, s, l, a))
end

return {
  theme_name = theme_name,
  scheme = scheme,
  highlight = highlight,
  selection_bg = selection_bg,
  lighten_selection = lighten_selection,
  bg_dark = bg_dark,
  alpha = alpha,
  status_default = '#91d7e3',
  status_ssh = '#b7bdf8',
}

