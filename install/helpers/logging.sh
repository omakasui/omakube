start_install_log() {
  sudo touch "$OMAKUB_INSTALL_LOG_FILE"
  sudo chmod 666 "$OMAKUB_INSTALL_LOG_FILE"

  export OMAKUB_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "=== $OMAKUB_BRAND Installation Started: $OMAKUB_START_TIME ===" >>"$OMAKUB_INSTALL_LOG_FILE"
}

stop_install_log() {
  if [[ -n ${OMAKUB_INSTALL_LOG_FILE:-} && -n ${OMAKUB_START_TIME:-} ]]; then
    local end_time mins secs
    end_time=$(date '+%Y-%m-%d %H:%M:%S')

    local start_epoch end_epoch duration
    start_epoch=$(date -d "$OMAKUB_START_TIME" +%s)
    end_epoch=$(date -d "$end_time" +%s)
    duration=$((end_epoch - start_epoch))
    mins=$((duration / 60))
    secs=$((duration % 60))

    {
      echo "=== $OMAKUB_BRAND Installation Completed: $end_time ==="
      echo ""
      echo "=== Installation Time Summary ==="
      echo "$OMAKUB_BRAND: ${mins}m ${secs}s"
      echo "================================="
    } >>"$OMAKUB_INSTALL_LOG_FILE"
  fi
}

# Run a script with output visible on terminal and appended to the log file.
run_logged() {
  local script="$1"
  local script_name
  script_name=$(basename "$script" .sh)
  export CURRENT_SCRIPT="$script"

  # Pick up any PATH updates
  if [[ -f "$HOME/.local/state/omakub/.env_update" ]]; then
    source "$HOME/.local/state/omakub/.env_update"
  fi

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script_name" | tee -a "$OMAKUB_INSTALL_LOG_FILE"

  step_headline "Running: $script_name"

  # Run the script — output goes to both terminal and log via tee.
  # pipefail ensures the exit code from bash propagates through the pipe.
  bash "$script" 2>&1 | tee -a "$OMAKUB_INSTALL_LOG_FILE"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script_name" | tee -a "$OMAKUB_INSTALL_LOG_FILE"

  unset CURRENT_SCRIPT
}