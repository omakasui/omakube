# Keep sudo credentials fresh during long installations.
start_sudo_keepalive() {
  sudo -v

  # Background loop: refresh every 60 seconds until killed
  (
    while true; do
      sleep 60
      sudo -n -v 2>/dev/null || true
    done
  ) &
  export SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
  if [[ -n ${SUDO_KEEPALIVE_PID:-} ]]; then
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    unset SUDO_KEEPALIVE_PID
  fi
}

start_install_log() {
  sudo touch "$OMAKUB_INSTALL_LOG_FILE"
  sudo chmod 666 "$OMAKUB_INSTALL_LOG_FILE"

  export OMAKUB_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "=== $OMAKUB_BRAND Installation Started: $OMAKUB_START_TIME ===" >>"$OMAKUB_INSTALL_LOG_FILE"

  start_sudo_keepalive
}

stop_install_log() {
  stop_sudo_keepalive

  if [[ -n ${OMAKUB_INSTALL_LOG_FILE:-} ]]; then
    OMAKUB_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== $OMAKUB_BRAND Installation Completed: $OMAKUB_END_TIME ===" >>"$OMAKUB_INSTALL_LOG_FILE"
    echo "" >>"$OMAKUB_INSTALL_LOG_FILE"
    echo "=== Installation Time Summary ===" >>"$OMAKUB_INSTALL_LOG_FILE"

    if [ -n "$OMAKUB_START_TIME" ]; then
      OMAKUB_START_EPOCH=$(date -d "$OMAKUB_START_TIME" +%s)
      OMAKUB_END_EPOCH=$(date -d "$OMAKUB_END_TIME" +%s)
      OMAKUB_DURATION=$((OMAKUB_END_EPOCH - OMAKUB_START_EPOCH))

      OMAKUB_MINS=$((OMAKUB_DURATION / 60))
      OMAKUB_SECS=$((OMAKUB_DURATION % 60))

      echo "$OMAKUB_BRAND:     ${OMAKUB_MINS}m ${OMAKUB_SECS}s" >>"$OMAKUB_INSTALL_LOG_FILE"

      if [ -n "$ARCH_DURATION" ]; then
        TOTAL_DURATION=$((ARCH_DURATION + OMAKUB_DURATION))
        TOTAL_MINS=$((TOTAL_DURATION / 60))
        TOTAL_SECS=$((TOTAL_DURATION % 60))
        echo "Total:       ${TOTAL_MINS}m ${TOTAL_SECS}s" >>"$OMAKUB_INSTALL_LOG_FILE"
      fi
    fi
    echo "=================================" >>"$OMAKUB_INSTALL_LOG_FILE"
  fi
}

run_logged() {
  local script="$1"
  local script_name=$(basename "$script" .sh)
  export CURRENT_SCRIPT="$script"

  # ANSI escape codes
  local ANSI_CLEAR_LINE="\033[K"        # Clear from cursor to end of line
  local ANSI_CARRIAGE_RETURN="\r"       # Return to start of line
  local ANSI_GREEN="\033[32m"           # Green color
  local ANSI_RED="\033[31m"             # Red color
  local ANSI_YELLOW="\033[33m"          # Yellow color
  local ANSI_RESET="\033[0m"            # Reset all attributes

  # Check if there are any PATH updates to apply
  if [[ -f "$HOME/.local/state/omakub/.env_update" ]]; then
    source "$HOME/.local/state/omakub/.env_update"
  fi

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >>"$OMAKUB_INSTALL_LOG_FILE"

  local temp_exit_file=$(mktemp)

  # Execute the script in background with updated environment
  (
    # Source environment updates in the subshell too
    [[ -f "$HOME/.local/state/omakub/.env_update" ]] && source "$HOME/.local/state/omakub/.env_update"
    bash -c "source '$script'" </dev/null >>"$OMAKUB_INSTALL_LOG_FILE" 2>&1
    echo $? > "$temp_exit_file"
  ) &
  local bg_pid=$!

  # Get timeout from environment or use default (10 minutes)
  # Each script can override this by exporting OMAKUB_SCRIPT_TIMEOUT before calling run_logged
  local timeout=${OMAKUB_SCRIPT_TIMEOUT:-600}

  # Show spinner with timeout
  GUM_SPIN_SHOW_OUTPUT=0 timeout $timeout gum spin --spinner dot --title "Installing $script_name..." -- bash -c "
    while kill -0 $bg_pid 2>/dev/null; do
      sleep 0.1
    done
  " </dev/null

  local gum_exit=$?

  # Check if timeout occurred
  if [ $gum_exit -eq 124 ]; then
    kill -TERM $bg_pid 2>/dev/null
    sleep 2
    kill -KILL $bg_pid 2>/dev/null
    printf "${ANSI_CARRIAGE_RETURN}${ANSI_CLEAR_LINE}${PADDING_LEFT_SPACES}${ANSI_YELLOW}⚠${ANSI_RESET}  Timeout $script_name (exceeded ${timeout}s)\n"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Timeout: $script (exceeded ${timeout}s)" >>"$OMAKUB_INSTALL_LOG_FILE"
    rm -f "$temp_exit_file"
    unset CURRENT_SCRIPT
    unset OMAKUB_SCRIPT_TIMEOUT
    return 124
  fi

  # Wait for background process to complete and get exit code
  wait $bg_pid 2>/dev/null
  local exit_code=$(cat "$temp_exit_file" 2>/dev/null || echo "1")
  rm -f "$temp_exit_file"

  # Reset timeout for next script
  unset OMAKUB_SCRIPT_TIMEOUT

  if [ $exit_code -eq 0 ]; then
    # Success - replace the spinner line with completion status
    printf "${ANSI_CARRIAGE_RETURN}${ANSI_CLEAR_LINE}${PADDING_LEFT_SPACES}${ANSI_GREEN}✓${ANSI_RESET}  Completed $script_name\n"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >>"$OMAKUB_INSTALL_LOG_FILE"
    unset CURRENT_SCRIPT
    return 0
  else
    # Failure - replace the spinner line with error status
    printf "${ANSI_CARRIAGE_RETURN}${ANSI_CLEAR_LINE}${PADDING_LEFT_SPACES}${ANSI_RED}✗${ANSI_RESET}  Failed $script_name\n"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >>"$OMAKUB_INSTALL_LOG_FILE"
    return $exit_code
  fi
}