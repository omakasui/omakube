# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

# Display recent log lines from the install log
show_log_tail() {
  if [[ -f $OMAKUB_INSTALL_LOG_FILE ]]; then
    echo "Recent installation log:"
    tail -10 "$OMAKUB_INSTALL_LOG_FILE" | sed 's/\x1b\[[0-9;]*m//g' | while IFS= read -r line; do
      echo "  $line"
    done
    echo
  fi
}

# Display the failed command or script name
show_failed_script_or_command() {
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    gum style "Failed script: $CURRENT_SCRIPT"
  else
    gum style "Failed command: $BASH_COMMAND"
  fi
}

# Simple output restoration
restore_outputs() {
  exec 1>/dev/tty 2>/dev/tty
}

# Kill any background installation process left running
kill_bg_process() {
  if [[ -n ${CURRENT_BG_PID:-} ]]; then
    kill -TERM "$CURRENT_BG_PID" 2>/dev/null || true
    sleep 1
    kill -KILL "$CURRENT_BG_PID" 2>/dev/null || true
    wait "$CURRENT_BG_PID" 2>/dev/null || true
    unset CURRENT_BG_PID
  fi
}

# Drain pending terminal input and reset to a clean state
clean_terminal() {
  # Drain any pending escape sequence responses from the terminal input buffer
  # (OSC 11 background color responses, CPR cursor position responses, etc.)
  if [[ -t 0 ]]; then
    stty -echo 2>/dev/null || true
    while read -r -t 0.3 -n 1024 2>/dev/null; do :; done
    stty echo 2>/dev/null || true
  fi

  # Reset terminal modes to sane defaults
  stty sane 2>/dev/null || true

  # Clear screen without sending any terminal queries
  printf "\033[H\033[2J"

  # Let the terminal settle
  sleep 0.2
}

# Error handler
catch_errors() {
  # Prevent recursive error handling
  if [[ $ERROR_HANDLING == true ]]; then
    return
  fi
  ERROR_HANDLING=true

  # Store exit code immediately before it gets overwritten
  local exit_code=$?

  # Disable errexit inside error handler to prevent cascading failures.
  # Without this, any command failure inside the handler (e.g. gum choose
  # interrupted by Ctrl+C) triggers the ERR trap recursively and bash
  # resumes execution after the original failure point instead of stopping.
  set +eE

  # Kill any orphaned background installation process
  kill_bg_process

  restore_outputs
  clear_logo

  gum style --foreground 1 "$OMAKUB_BRAND installation stopped!"
  show_log_tail

  gum style "This command halted with exit code $exit_code:"
  show_failed_script_or_command

  # Offer options menu - Ctrl+C in the menu will exit
  while true; do
    local choice
    choice=$(gum choose \
      "Retry installation" \
      "View full log" \
      "Exit" \
      --header "What would you like to do?" --height 6) || choice=""

    case "$choice" in
    "Retry installation")
      # Stop sudo keep-alive (will be restarted by new install)
      stop_sudo_keepalive 2>/dev/null || true

      # Clean terminal for a fresh start
      clean_terminal

      # Re-execute installation script (replaces current process)
      exec bash ~/.local/share/omakub/install.sh
      ;;
    "View full log")
      if command -v less &>/dev/null; then
        less "$OMAKUB_INSTALL_LOG_FILE"
      else
        tail "$OMAKUB_INSTALL_LOG_FILE"
      fi
      ;;
    *)
      # Exit, empty choice, or Ctrl+C
      exit 1
      ;;
    esac
  done
}

# Exit handler - ensures cleanup happens on any exit
exit_handler() {
  local exit_code=$?

  # Always clean up background processes and sudo keep-alive
  stop_sudo_keepalive 2>/dev/null || true
  kill_bg_process

  # Only run error handler if we're exiting with an error and haven't already handled it
  if [[ $exit_code -ne 0 && $ERROR_HANDLING != true ]]; then
    catch_errors
  fi
}

# Set up traps
trap catch_errors ERR INT TERM
trap exit_handler EXIT
