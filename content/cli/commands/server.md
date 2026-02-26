---
title: 'Server'
weight: 30
description: 'CookCLI Server command documentation'
date: 2026-02-26T12:59:19+00:00
---


Start a local web server to browse and view your recipe collection.

<img width="600" height="359" alt="recipes" src="https://github.com/user-attachments/assets/b18ec5b9-4959-49be-9784-86f73f0e34e2" />
<img width="600" height="359" alt="recipe" src="https://github.com/user-attachments/assets/e24b7b90-7bf7-4a5d-b1e0-585995a647c6" />
<img width="600" height="359" alt="shopping" src="https://github.com/user-attachments/assets/8c9036ca-a902-4f09-901c-905c6f8325a2" />
<img width="600" height="359" alt="pantry" src="https://github.com/user-attachments/assets/92d20226-eeb4-4b64-8833-ee7d9b3578a9" />

## Usage

```
cook server [OPTIONS] [BASE_PATH]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `[BASE_PATH]` | Root directory containing recipe files (default: current directory) |

## Options

| Option | Description |
|--------|-------------|
| `--host [<ADDRESS>]` | Allow connections from external hosts (default: localhost only). Optionally bind to a specific address. |
| `-p, --port <PORT>` | Port number (default: 9080) |
| `--open` | Automatically open the web interface in your default browser |

## Examples

```bash
# Start on localhost:9080
cook server

# Serve recipes from a specific directory
cook server ~/my-recipes

# Custom port with auto-open
cook server --port 8080 --open

# Allow access from other devices on the network
cook server --host
```

## Notes

- By default, only accepts connections from localhost
- Use `--host` on trusted networks only — recipes become accessible to anyone on the network
- The web interface supports recipe browsing, scaling, search, and shopping list management
- Mobile-friendly responsive layout
