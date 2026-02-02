#!/bin/bash

rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude

# Remove user settings and state
rm -rf ~/.claude
rm ~/.claude.json