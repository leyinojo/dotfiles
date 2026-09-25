#!/bin/bash
set -euo pipefail

info()  { echo "==> $*"; }
check() { command -v "$1" &>/dev/null; }


# Homebrew
if ! check brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  info "Homebrew already installed"
fi

# Install packages from Brewfile
brewfile="$HOME/.config/brew/brewfile"
if [[ -f "$brewfile" ]]; then
  info "Installing packages..."
  brew bundle install --file="$brewfile"
fi

# WezTerm custom icon
wezterm_icns="$HOME/.config/wezterm/wezterm.icns"
if check wezterm; then
  info "Setting WezTerm custom icon..."
  fileicon set /Applications/WezTerm.app $wezterm_icns
  Killall Dock 2>/dev/null || true
  info "WezTerm icon updated"
fi

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  info "Oh My Zsh already installed"
fi

# Zsh plugins
info "Installing Zsh plugins..."
plugins_dir="$HOME/.oh-my-zsh/custom/plugins"

if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$plugins_dir/zsh-autosuggestions"
fi

if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$plugins_dir/zsh-syntax-highlighting"
fi

# Zsh custom theme
info "Installing custom Zsh theme..."
themes_dir="$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$themes_dir"
cp "$HOME/.local/share/chezmoi/dot_oh-my-zsh/custom/themes/lambda-minimal.zsh-theme" \
   "$themes_dir/lambda-minimal.zsh-theme"

# Set zsh as default shell
if [[ "$SHELL" != *"zsh" ]]; then
  info "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

info "Done!"

