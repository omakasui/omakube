#!/bin/bash
# Migrate from Omabuntu

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define migration variables
export OMAKUB_REPO="${OMAKUB_REPO:-omakasui/omabuntu}"
export OMAKUB_REF="${OMAKUB_REF:-main}"
export OMAKUB_BRAND="${OMAKUB_BRAND:-Omabuntu}"

# Define backup location
export BACKUP_DIR="$HOME/.local/share/omakub-backup-$(date +%Y%m%d_%H%M%S)"

# Define Omabuntu locations
export OMAKUB_PATH="$HOME/.local/share/omakub"
export OMAKUB_INSTALL="$OMAKUB_PATH/install"
export OMAKUB_INSTALL_LOG_FILE="/var/log/omakub-install.log"
export PATH="$OMAKUB_PATH/bin:$PATH"

# Check Omakub installation
if [[ ! -d "$OMAKUB_PATH" ]]; then
    echo "Error: Omakub not found in $OMAKUB_PATH"
    exit 1
fi

# Upgrade your system
sudo apt-get update >/dev/null
sudo apt-get upgrade -y >/dev/null

# Check for gum
if ! command -v gum &>/dev/null; then
    cd /tmp
    wget -q -O gum.deb "https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_amd64.deb"
    sudo apt install -y --allow-downgrades ./gum.deb >/dev/null 2>&1
    rm gum.deb
    cd - >/dev/null
fi

gum style --border normal --border-foreground 6 --padding "1 2" \
  "Ready to migrate to Omabuntu?" \
  "" \
  "• This migration cannot be stopped once started!" \
  "• Make sure you're connected to power or have a full battery" \
  "• A backup will be created before proceeding"

echo

# Request confirmation
if ! gum confirm "Continue with migration?"; then
  echo "Migration cancelled"
  exit 1
fi

# Backup
gum spin --spinner dot --title "Creating backup..." -- \
    sh -c "mkdir -p '$BACKUP_DIR' && cp -r '$OMAKUB_PATH' '$BACKUP_DIR/omakub'" || {
    echo "Backup failed"
    exit 1
}

# Backup bashrc
gum spin --spinner dot --title "Backing up bash configuration..." -- \
    sh -c "cp -f ~/.bashrc '$BACKUP_DIR/bashrc.bak' 2>/dev/null || true" || {
    echo "Bash configuration backup failed"
    exit 1
}

# Clone
gum spin --spinner dot --title "Downloading Omabuntu..." -- \
    sh -c "rm -rf '$OMAKUB_PATH' && git clone -q https://github.com/$OMAKUB_REPO.git '$OMAKUB_PATH'" || {
    echo "Clone failed, restoring backup..."
    cp -r "$BACKUP_DIR/omakub" "$OMAKUB_PATH"
    exit 1
}

# Checkout branch
if [[ -n "$OMAKUB_REF" ]]; then
    cd "$OMAKUB_PATH"
    git fetch -q origin "$OMAKUB_REF" && git checkout -q "$OMAKUB_REF" 2>/dev/null || true
    cd - >/dev/null
fi

# Remove old desktop entries and icons
rm -rf ~/.local/share/applications/About.desktop
rm -rf ~/.local/share/applications/Activity.desktop
rm -rf ~/.local/share/applications/Basecamp.desktop
rm -rf ~/.local/share/applications/Docker.desktop
rm -rf ~/.local/share/applications/HEY.desktop
rm -rf ~/.local/share/applications/Neovim.desktop
rm -rf ~/.local/share/applications/Omabuntu.desktop
rm -rf ~/.local/share/applications/WhatsApp.desktop
rm -rf ~/.local/share/applications/icons

# Remove inputrc
rm -rf ~/.inputrc

# Install
source "$OMAKUB_INSTALL/helpers/all.sh"
source "$OMAKUB_INSTALL/preflight/all.sh"
source "$OMAKUB_INSTALL/packaging/all.sh"
source "$OMAKUB_INSTALL/config/all.sh"
source "$OMAKUB_INSTALL/login/all.sh"
source "$OMAKUB_INSTALL/post-install/all.sh"

