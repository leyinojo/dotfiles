local wezterm = require('wezterm')
local act = wezterm.action
local nop = act.Nop

local keys = {
  {
    key = '|',
    mods = 'CMD|SHIFT',
    action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },
  {
    key = '_',
    mods = 'CMD|SHIFT',
    action = act.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },
  {
    key = 'w',
    mods = 'CMD',
    action = act.CloseCurrentPane { confirm = false },
  },
  {
    key = '"',
    mods = 'CMD|SHIFT',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'Home' },
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'End' },
  },
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = act.SendString('\x1bb'),
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.SendString('\x1bf'),
  },
  {
    key = 'Backspace',
    mods = 'ALT',
    action = act.SendString('\x1b\x7f'),
  },
  {
    key = 'Delete',
    mods = 'ALT',
    action = act.SendString('\x1bd'),
  },
  {
    key = 'LeftArrow',
    mods = 'SHIFT',
    action = act.ActivatePaneDirection('Left'),
  },
  {
    key = 'RightArrow',
    mods = 'SHIFT',
    action = act.ActivatePaneDirection('Right'),
  },
  {
    key = 'UpArrow',
    mods = 'SHIFT',
    action = act.ActivatePaneDirection('Up'),
  },
  {
    key = 'DownArrow',
    mods = 'SHIFT',
    action = act.ActivatePaneDirection('Down'),
  },
  {
    key = '[',
    mods = 'CMD',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = ']',
    mods = 'CMD',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 't',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
    },
  },
  {
    key = 'r',
    mods = 'CMD',
    action = act.ReloadConfiguration,
  },
  {
    key = 'p',
    mods = 'CMD',
    action = act.ActivateCommandPalette,
  },
  {
    key = 'e',
    mods = 'CMD|SHIFT',
    action = act.CharSelect,
  },
  {
    key = 'k',
    mods = 'CMD',
    action = act.ClearScrollback(
      'ScrollbackAndViewport'
    ),
  },
  {
    key = ',',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab {
      args = {
        '/opt/homebrew/bin/nvim',
        wezterm.config_file,
      },
      cwd = wezterm.home_dir,
    },
  },
  {
    key = '<',
    mods = 'CMD|SHIFT',
    action = act.SpawnCommandInNewTab {
      args = {
        'zsh',
        '-c',
        '/opt/homebrew/bin/nvim '
        .. wezterm.home_dir
        .. '/.zshrc && source '
        .. wezterm.home_dir
        .. '/.zshrc',
      },
      cwd = wezterm.home_dir,
    },
  },
}

local disabled = {
  { 'e',     'CTRL|SHIFT' },
  { 'k',     'CTRL|SHIFT' },
  { 'n',     'CMD' },
  { 'n',     'CTRL|SHIFT' },
  { 'q',     'CMD' },
  { 'Space', 'CTRL' },
  { 'Space', 'CTRL|SHIFT' },
  { 'w',     'CTRL|SHIFT' },
  { 'x',     'CTRL|SHIFT' },
}

for _, k in ipairs(disabled) do
  table.insert(keys, {
    key = k[1],
    mods = k[2],
    action = nop,
  })
end

return keys
