#!/bin/bash

echo "Remove interactive shell check from .bashrc (breaks hotkey commands)"

BASHRC="$HOME/.bashrc"

if [ -f "$BASHRC" ]; then
  # Remove the interactive check and its comment
  sed -i '/# If not running interactively, don'\''t do anything (leave this at the top of this file)/d' "$BASHRC"
  sed -i '/\[\[ $- != \*i\* \]\] && return/d' "$BASHRC"

  # Remove any extra blank lines at the top
  sed -i '/./,$!d' "$BASHRC"
fi
