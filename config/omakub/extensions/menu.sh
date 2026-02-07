#! /bin/bash

# Overwrite parts of the omakub-menu with user-specific submenus.
# See $OMAKUB_PATH/bin/omakub-menu for functions that can be overwritten.
#
# WARNING: Overwritten functions will obviously not be updated when Omabuntu changes.
#
# Example of minimal system menu:
#
# show_system_menu() {
#   case $(menu "System" "  Lock\n󰐥  Shutdown") in
#   *Lock*) omakub-lock-screen ;;
#   *Shutdown*) omakub-cmd-shutdown ;;
#   *) back_to show_main_menu ;;
#   esac
# }