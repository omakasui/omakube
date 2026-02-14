#!/bin/bash

# Must not be on a LVM partition
LVM_DETECTED=false
if [ -f /etc/fstab ]; then
  if grep -Pq '/dev/(mapper/|disk/by-id/dm)' /etc/fstab; then
    LVM_DETECTED=true
  fi
fi

# ==============================================================================
# ALT BOOTLOADERS SETUP
# ==============================================================================

apply_alt_bootloaders() {
  # Add kernel parameters for Plymouth
  if [ -f "/etc/default/grub" ]; then # Grub
    # Backup GRUB config before modifying
    backup_timestamp=$(date +"%Y%m%d%H%M%S")
    sudo cp /etc/default/grub "/etc/default/grub.bak.${backup_timestamp}"

    # Check if splash is already in GRUB_CMDLINE_LINUX_DEFAULT
    if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT.*splash" /etc/default/grub; then
      # Get current GRUB_CMDLINE_LINUX_DEFAULT value
      current_cmdline=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub | cut -d'"' -f2)

      # Add splash and quiet if not present
      new_cmdline="$current_cmdline"
      if [[ ! "$current_cmdline" =~ splash ]]; then
        new_cmdline="$new_cmdline splash"
      fi
      if [[ ! "$current_cmdline" =~ quiet ]]; then
        new_cmdline="$new_cmdline quiet"
      fi

      # Trim any leading/trailing spaces
      new_cmdline=$(echo "$new_cmdline" | xargs)

      sudo sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT=\".*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$new_cmdline\"/" /etc/default/grub

      # Regenerate grub config
      sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
  fi
}

if [ "$LVM_DETECTED" = true ]; then
  echo "Warning: LVM partition detected. Plymouth may not work properly with encrypted LVM setups. Skipping Plymouth configuration for bootloaders."
else
  apply_alt_bootloaders
fi