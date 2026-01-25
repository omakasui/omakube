#!/bin/bash

# Create a variable for interactive mode
INTERACTIVE_MODE=${INTERACTIVE_MODE:-true}

echo "Migrate from Omakub Menu Topbar Extension to Icon Launcher Extension"

# Update branding
cp ~/.local/share/omakub/logo.png ~/.config/omakub/branding/icon-launcher.png

# Install Icon Launcher extension
gext install icon-launcher@omakasui.org

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/icon-launcher\@omakasui.org/schemas/org.gnome.shell.extensions.icon-launcher.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Configure Icon Launcher extension
ICON_PATH="$HOME/.config/omakub/branding/icon-launcher.png"
gsettings set org.gnome.shell.extensions.icon-launcher custom-icon-path "$ICON_PATH"
gsettings set org.gnome.shell.extensions.icon-launcher custom-command 'omakub-menu'

# Remove Omakub Menu Topbar extension
gext uninstall omakub-menu-topbar@omakasui.org