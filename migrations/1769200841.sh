
echo "Fix TUI launchers to use xdg-terminal-exec"

find "$HOME/.local/share/applications" -name "*.desktop" | while read -r desktop_file; do
  if grep -qE '^Exec=xdg-terminal-exec -e ' "$desktop_file"; then
    # Update the Exec line to remove '-e'
    sed -i 's|^Exec=xdg-terminal-exec -e |Exec=xdg-terminal-exec |' "$desktop_file"
  fi
done