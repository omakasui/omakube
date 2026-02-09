#!/bin/bash

# Ensure we have gum available
if ! command -v gum &> /dev/null; then
  cd /tmp
  GUM_VERSION="0.17.0"
  wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_amd64.deb"
  sudo apt-get install -y --allow-downgrades ./gum.deb
  rm gum.deb
  cd -
fi


export LOGO_PATH="$OMAKUB_PATH/logo.txt"

# Tell gum/lipgloss/termenv the terminal has a dark background (fg=15, bg=0).
# Without this, gum sends OSC 11 queries (\033]11;?\007) to detect the
# background color. Terminal responses leak into the input buffer and corrupt
# subsequent gum input prompts on retry (the ^[]11;rgb:... garbage).
export COLORFGBG="15;0"

# Minimal padding for desktop terminal
export PADDING_LEFT=2
export PADDING_LEFT_SPACES=$(printf "%*s" $PADDING_LEFT "")

# Tokyo Night theme for gum confirm
export GUM_CONFIRM_PROMPT_FOREGROUND="6"     # Cyan for prompt
export GUM_CONFIRM_SELECTED_FOREGROUND="0"   # Black text on selected
export GUM_CONFIRM_SELECTED_BACKGROUND="2"   # Green background for selected
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7" # White for unselected
export GUM_CONFIRM_UNSELECTED_BACKGROUND="0" # Black background for unselected
export PADDING="0 0 0 $PADDING_LEFT"         # Gum Style
export GUM_CHOOSE_PADDING="$PADDING"
export GUM_FILTER_PADDING="$PADDING"
export GUM_INPUT_PADDING="$PADDING"
export GUM_SPIN_PADDING="$PADDING"
export GUM_TABLE_PADDING="$PADDING"
export GUM_CONFIRM_PADDING="$PADDING"

clear_logo() {
  printf "\033[H\033[2J"
  gum style --foreground 2 --padding "1 0 0 $PADDING_LEFT" "$(<"$LOGO_PATH")"
}