
echo "Disabling Night Light by default and adding manual schedule settings..."

# Disable the night light feature by default
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
# Set night light schedule to manual (so it doesn't turn on automatically)
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 0.0