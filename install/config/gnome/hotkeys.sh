#!/bin/bash

# Alt+F4 is very cumbersome
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

# Make it easy to maximize like you can fill left/right
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"

# Make it easy to resize undecorated windows
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"

# For keyboards that only have a start/stop button for music, like Logitech MX Keys Mini
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"

# Full-screen with title/navigation bar
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

# Remove default app hotkeys, we set our own later
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys www "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys help "[]"

# Cancel input capture with Super+Shift+Escape
gsettings set org.gnome.mutter.keybindings cancel-input-capture "['<Super><Shift>Escape']"

# Open Tactile settings with Super+Control+T
gsettings set org.gnome.shell.extensions.tactile show-settings "['<Super><Control>t']"

# Use alt for pinned apps
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

# Use super for workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

# Reserve slots for input source switching
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"

# Empty the custom keybindings to start fresh
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]"

# Set apps launcher (wofi) to Super+Space
omakub-keybinding-add 'Apps Launcher' 'omakub-apps' '<Super>space'

# Set omakub menu to Alt+Super+Space
omakub-keybinding-add 'Omabuntu Menu' 'omakub-menu' '<Alt><Super>space'

# Set omakub theme switcher to Super+Shift+Control+Space
omakub-keybinding-add 'Omabuntu Themes' 'omakub-menu theme' '<Super><Shift><Control>space'

# Set omakub next background to Super+Shift+Control
omakub-keybinding-add 'Omabuntu Background Next' 'omakub-theme-bg-next' '<Super><Control>space'

# Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
omakub-keybinding-add 'Flameshot' 'sh -c -- "flameshot gui"' '<Control>Print'

# Turn brightness down on Apple monitor (requires ASDControl installed)
omakub-keybinding-add 'Apple Brightness Down (ASDControl)' "omakub-cmd-apple-display-brightness -5000" '<Control>F1'

# Turn brightness up on Apple monitor (requires ASDControl installed)
omakub-keybinding-add 'Apple Brightness Up (ASDControl)' "omakub-cmd-apple-display-brightness +5000" '<Control>F2'

# Turn brightness up to max on Apple monitor (requires ASDControl installed)
omakub-keybinding-add 'Apple Brightness Max (ASDControl)' "omakub-cmd-apple-display-brightness +60000" '<Control><Shift>F2'

# Set night light toggle to Super+Control+N
omakub-keybinding-add 'Night Light Toggle' 'omakub-toggle-nightlight' '<Super><Control>n'

# Set screen lock to Super+L
omakub-keybinding-add 'Omabuntu System' 'omakub-menu system' '<Super>Escape'

# Set applications hotkeys
omakub-keybinding-add 'Terminal' 'xdg-terminal-exec' '<Super>Return'
omakub-keybinding-add 'Default Terminal' 'x-terminal-emulator' '<Control><Alt>t'
omakub-keybinding-add 'Browser' 'omakub-launch-browser --new-window' '<Shift><Super>b'
omakub-keybinding-add 'Browser (Alt)' 'omakub-launch-browser --new-window' '<Shift><Super>Return'
omakub-keybinding-add 'Incognito Browser' 'omakub-launch-browser --private' '<Shift><Alt><Super>b'
omakub-keybinding-add 'File Manager' 'nautilus --new-window' '<Shift><Super>f'
omakub-keybinding-add 'Activity' 'omakub-launch-tui btop' '<Super><Shift>t'
omakub-keybinding-add 'Docker' 'omakub-launch-tui lazydocker' '<Super><Shift>d'
omakub-keybinding-add 'Spotify' 'spotify' '<Super><Shift>m'
omakub-keybinding-add 'Editor' 'omakub-launch-editor' '<Super><Shift>n'

# Set webapps hotkeys
omakub-keybinding-add 'ChatGPT' 'omakub-launch-webapp "https://chatgpt.com" "ChatGPT"' '<Super><Shift>a'
omakub-keybinding-add 'WhatsApp' 'omakub-launch-webapp "WhatsApp" "https://web.whatsapp.com/" "WhatsApp"' '<Super><Shift><Alt>g'
omakub-keybinding-add 'YouTube' 'omakub-launch-webapp "https://youtube.com/" "YouTube"' '<Super><Shift>y'
omakub-keybinding-add 'GitHub' 'omakub-launch-webapp "https://github.com/" "GitHub"' '<Super><Shift>h'
omakub-keybinding-add 'X' 'omakub-launch-webapp "https://x.com/" "X"' '<Super><Shift>x'

# Enable Compose key on Caps Lock
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"