
echo "Setting up xdg-terminal-exec for gtk-launch terminal support"

# Remove old symlink if it exists -- if someone ran the previous migration early
if [ -L /usr/local/bin/xdg-terminal-exec ]; then
  sudo rm /usr/local/bin/xdg-terminal-exec
fi

omakub-pkg-add xdg-terminal-exec

# Update TERMINAL variable in bash environment
omakub-env-set TERMINAL "xdg-terminal-exec"

# Set up xdg-terminals.list based on current $TERMINAL (if not set, then set to alacritty later)
TERMINAL=${TERMINAL:-alacritty}
if [ -n "$TERMINAL" ]; then
  case "$TERMINAL" in
    alacritty)
      desktop_id="Alacritty.desktop"
      ;;
    kitty)
      desktop_id="kitty.desktop"
      ;;
  esac

  if [ -n "$desktop_id" ]; then
    mkdir -p ~/.config

    # Delete existing config file if it exists
    rm -f ~/.config/xdg-terminals.list
    rm -f ~/.config/ubuntu-xdg-terminals.list
    rm -f ~/.config/GNOME-xdg-terminals.list

    # Create the current config file with only the selected terminal
    cat > "~/.config/ubuntu-xdg-terminals.list" << EOF
# Terminal emulator preference order for xdg-terminal-exec
# The first found and valid terminal will be used
$desktop_id
EOF
  fi
fi

# Copy custom desktop entries with proper X-TerminalArg* keys
if command -v alacritty > /dev/null 2>&1; then
  mkdir -p ~/.local/share/xdg-terminals ~/.local/share/applications
  cp /usr/share/applications/Alacritty.desktop "$HOME/.local/share/xdg-terminals/Alacritty.desktop"
  cp /usr/share/applications/Alacritty.desktop "$HOME/.local/share/applications/Alacritty.desktop"
fi

# Update Hotkeys to use xdg-terminal-exec
omakub-keybinding-remove 'New Terminal Window'
omakub-keybinding-add 'New Terminal Window' 'xdg-terminal-exec' '<Primary><Alt>t'