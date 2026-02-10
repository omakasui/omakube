
echo "Remove Activity ..."

rm -rf "$HOME/.local/share/applications/icons/Activity.png"
rm -rf "$HOME/.local/share/applications/Activity.desktop"
update-desktop-database ~/.local/share/applications

gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'Activity.desktop', //; s/, 'Activity.desktop'//; s/'Activity.desktop'//")"