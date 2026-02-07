#!/bin/bash

# Copy over Omabuntu configs
mkdir -p ~/.config
cp -R ~/.local/share/omakub/config/* ~/.config/

# Configure the bash shell using Omabuntu defaults
cp ~/.local/share/omakub/default/bashrc ~/.bashrc