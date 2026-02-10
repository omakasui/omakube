
echo "Copy configs for kitty so they're available as alternative terminal options"

if [[ ! -f ~/.config/kitty/kitty.conf ]]; then
  mkdir -p ~/.config/kitty
  cp -Rpf $OMAKUB_PATH/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
fi

echo "Fix opening in nvim from files manager"
cp -f $OMAKUB_PATH/applications/nvim.desktop ~/.local/share/applications/nvim.desktop

echo "Install Omabuntu theme on Obsidian vaults"
omakub-theme-set-obsidian

echo "Copy over updated application icons"
cp -f $OMAKUB_PATH/applications/desktop/icons/GitHub.png ~/.local/share/applications/icons/
cp -f $OMAKUB_PATH/applications/desktop/icons/ChatGPT.png ~/.local/share/applications/icons/
cp -f $OMAKUB_PATH/applications/desktop/icons/X.png ~/.local/share/applications/icons/

echo "Remove any active eza theme"
rm -f ~/.config/eza/theme.yml

echo "Add shift+insert for kitty"
# Add shift+insert paste keybinding to kitty.conf if it doesn't exist
KITTY_CONF="$HOME/.config/kitty/kitty.conf"

if ! grep -q "map shift+insert paste_from_clipboard" "$KITTY_CONF"; then
  sed -i '/map ctrl+insert copy_to_clipboard/a map shift+insert paste_from_clipboard' "$KITTY_CONF"
fi

echo "Copy hooks examples"
cp -r $OMAKUB_PATH/config/omakub/* $HOME/.config/omakub/