# Agent Guidelines for nixdots

## Build/Lint/Test Commands

### Build Commands
- `nix build .#<hostname>` - Build specific host configuration
- `nixos-rebuild build --flake .#<hostname>` - Build and test host config without installing
- `nix flake check` - Validate flake syntax and dependencies
- Run `./git-sync` to update the git tracking tree before building, as the Nix flake uses git-tracked files and may not see uncommitted changes (especially when adding new files)

### Lint Commands
- `alejandra .` - Format Nix files (if alejandra is installed)
- `nixd` - LSP server for Nix (use in editor for linting)

### Test Commands
- `nixos-rebuild dry-build --flake .#<hostname>` - Dry run build to check for errors
- No specific test framework; validation happens during builds

## Code Style Guidelines

### Nix Code Style
- Use `alejandra` for automatic formatting
- Follow standard Nix indentation (2 spaces)
- Use descriptive variable names in camelCase
- Group related configuration with comments
- Use `lib.mkDefault` for optional overrides
- Prefer `with pkgs;` for package lists
- Use `rec {}` for mutually recursive attribute sets

### Python Code Style
- Use type hints for function parameters and return values
- Follow PEP 8 conventions
- Use descriptive variable/function names in snake_case
- Import modules at the top, group by standard library, third-party, local
- Use logging instead of print statements
- Handle exceptions appropriately with try/except blocks

### Shell Scripts
- Use `#!/usr/bin/env sh` for portability
- Use `set -e` for strict error handling when appropriate
- Quote variables: `"$variable"`
- Use functions for reusable code
- Add comments for complex logic

### General
- No trailing whitespace
- Use descriptive commit messages
- Keep files focused on single responsibilities
- Use relative paths where possible
- Comment complex configurations

### Naming Conventions
- Host configs: lowercase, descriptive names
- Modules: lowercase with hyphens
- Variables: camelCase in Nix, snake_case in Python/shell
- Files: lowercase with hyphens or underscores as appropriate

### Error Handling
- Nix: Use `lib.mkIf` for conditional configurations
- Python: Use try/except with specific exception types
- Shell: Check exit codes and use `||` for fallbacks

### Imports
- Nix: Import modules at top of files
- Python: Group imports (stdlib, third-party, local)
- Avoid circular imports

### Security
- Never commit secrets or keys
- Use SOPS for encrypted secrets
- Validate SSH/AGE keys before committing