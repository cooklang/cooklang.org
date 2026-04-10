---
title: 'Update'
weight: 99
description: 'CookCLI Update command documentation'
date: 2026-04-10T18:01:50+00:00
---


Update CookCLI to the latest version.

## Usage

```
cook update [OPTIONS]
```

Alias: `cook u`

## Options

| Option | Description |
|--------|-------------|
| `--check-only` | Check for updates without installing |
| `--force` | Force update even if already on the latest version |

## Examples

```bash
# Update to latest version
cook update

# Check for updates without installing
cook update --check-only

# Force reinstall
cook update --force
```

## Notes

- Downloads from GitHub releases over HTTPS
- Automatically detects your platform and architecture
- May require `sudo` if installed in a system directory (e.g., `/usr/local/bin/`)
- Verify with `cook --version` after updating
