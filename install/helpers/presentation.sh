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

# Minimal padding for desktop terminal
export PADDING_LEFT=4
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

script_headline() {
  local title="$1"
  gum style --foreground 3 --padding "1 0 0 $PADDING_LEFT" "$title"
  echo
}

step_headline() {
  clear_logo
  gum style --foreground 3 --padding "1 0 0 $PADDING_LEFT" "Installing $OMAKUB_BRAND..."
  gum style --foreground 4 "Logging to: $OMAKUB_INSTALL_LOG_FILE"
  echo

  if [[ -n $1 ]]; then
    script_headline "$1"
  fi
}