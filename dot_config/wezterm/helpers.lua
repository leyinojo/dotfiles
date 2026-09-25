local wezterm = require('wezterm')

local function split_path(path)
  local parts = {}
  for part in path:gmatch('[^/]+') do
    table.insert(parts, part)
  end
  return parts
end

local function abbreviate_part(part, is_last)
  if is_last then
    return part
  end
  if part:sub(1, 1) == '.' and #part > 1 then
    return '.' .. part:sub(2, 2)
  end
  return part:sub(1, 1)
end

local function shorten_path(path)
  local home = wezterm.home_dir
  local prefix = ''

  if path:sub(1, #home) == home then
    prefix = '~'
    path = path:sub(#home + 1):gsub('^/', '')
  end

  if path == '' then
    return prefix
  end

  local full = prefix ~= '' and prefix .. '/' .. path or path
  if #full <= 50 then
    return full
  end

  local parts = split_path(path)
  if #parts == 0 then
    return prefix
  end

  local abbreviated = {}
  for i, part in ipairs(parts) do
    table.insert(
      abbreviated,
      abbreviate_part(part, i == #parts)
    )
  end

  local joined = table.concat(abbreviated, '/')
  return prefix ~= '' and prefix .. '/' .. joined or joined
end

local process_icons = {
  ['bash'] = '', ['fish'] = '',
  ['sh'] = '', ['zsh'] = '',
  ['alacritty'] = '', ['iterm'] = '󰄛',
  ['kitty'] = '󰄛', ['terminal'] = '󰄛',
  ['nvim'] = '', ['vim'] = '',
  ['emacs'] = '', ['nano'] = '',
  ['micro'] = '󰅩',
  ['node'] = '', ['python'] = '',
  ['python3'] = '', ['lua'] = '',
  ['ruby'] = '', ['php'] = '',
  ['java'] = '', ['swift'] = '',
  ['gcc'] = '', ['clang'] = '',
  ['g++'] = '', ['clang++'] = '',
  ['cargo'] = '', ['rustc'] = '',
  ['go'] = '',
  ['make'] = '', ['cmake'] = '',
  ['yazi'] = '󰝰', ['lf'] = '󰝰',
  ['ranger'] = '󰝰', ['eza'] = '󰝰',
  ['lsd'] = '󰝰',
  ['bat'] = '󰋄', ['cat'] = '󰋄',
  ['less'] = '󰋄', ['more'] = '󰋄',
  ['htop'] = '󰓅', ['btop'] = '󰓅',
  ['top'] = '󰓅',
  ['docker'] = '', ['kubectl'] = '󱃾',
  ['ssh'] = '󰣀', ['git'] = '',
  ['lazygit'] = '󰊢',
  ['psql'] = '', ['mysql'] = '',
  ['redis-cli'] = '',
  ['code'] = '󰨞', ['tmux'] = '',
  ['wezterm'] = '󰖟',
}

local function get_process_icon(pane)
  local name = pane:get_foreground_process_name()
  if not name or #name == 0 then
    return nil
  end
  for pattern, icon in pairs(process_icons) do
    if name:find(pattern) then
      return icon
    end
  end
  return nil
end

local function get_ssh_host(pane)
  local domain = pane:get_domain_name()
  if domain and domain:find('^SSH:') then
    return domain:gsub('^SSH:', '')
  end

  local info = pane:get_foreground_process_info()
  if not info or not info.argv then
    return nil
  end

  for i, arg in ipairs(info.argv) do
    if arg:match('ssh$') then
      local host = info.argv[i + 1]
      if host and not host:match('^%-') then
        return host
      end
      break
    end
  end

  return nil
end

return {
  shorten_path = shorten_path,
  get_process_icon = get_process_icon,
  get_ssh_host = get_ssh_host,
}

