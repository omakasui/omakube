# Style

- Two spaces for indentation, no tabs
- Use Bash syntax for conditionals: `[[ -f $file ]]`, not `[ -f "$file" ]`

# Command Naming

All commands start with `omakub-`. Prefixes indicate purpose:

- `app` - app/app-folder management
- `cmd-` - check if commands exist, misc utility commands
- `pkg-` - package management helpers
- `env-` - envs variable management
- `font-` - fonts management
- `keybindings-` - GNOME keybindings management
- `refresh-` - copy default config to user's `~/.config/`
- `restart-` - restart a component
- `launch-` - open applications
- `install-` - install optional software
- `toggle-` - toggle features on/off
- `theme-` - theme management
- `update-` - update components

# Helper Commands

Use these instead of raw shell commands:

- `omakub-cmd-missing` / `omakub-cmd-present` - check for commands
- `omakub-pkg-missing` / `omakub-pkg-present` - check for packages
- `omakub-pkg-add` - install packages (from APT)

# Config Structure

- `config/` - default configs copied to `~/.config/`
- `default/themed/*.tpl` - templates with `{{ variable }}` placeholders for theme colors
- `themes/*/colors.toml` - theme color definitions (accent, background, foreground, color0-15)

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
omakub-refresh-config fastfetch/config.jsonc
```

This copies `~/.local/share/omakub/config/fastfetch/config.jsonc` to `~/.config/fastfetch/config.jsonc`.

# Migrations

To create a new migration, run `omakub-dev-add-migration --no-edit`. This creates a migration file named after the unix timestamp of the last commit.

Migration format:

- First is shebang line
- Start with an `echo` describing what the migration does
