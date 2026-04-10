---
title: 'Lsp'
weight: 99
description: 'CookCLI Lsp command documentation'
date: 2026-04-10T18:01:50+00:00
---


Start the Language Server Protocol server for Cooklang editor integration.

## Usage

```
cook lsp [OPTIONS]
```

The server communicates over stdin/stdout. You typically don't run this directly — your editor starts it automatically.

## Features

- Real-time syntax checking and validation
- Auto-completion for ingredients, cookware, and timers
- Semantic syntax highlighting
- Hover documentation
- Document symbols and navigation
- Go to definition for recipe references

## Editor Integration

### Visual Studio Code

Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=cooklang.cooklang). It uses `cook lsp` automatically.

Manual configuration in `settings.json`:
```json
{
  "cooklang.languageServer.path": "cook",
  "cooklang.languageServer.args": ["lsp"]
}
```

### Neovim

Using [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig):

```lua
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

if not configs.cooklang then
  configs.cooklang = {
    default_config = {
      cmd = { 'cook', 'lsp' },
      filetypes = { 'cooklang' },
      root_dir = lspconfig.util.root_pattern('.git', 'config'),
      settings = {},
    },
  }
end

lspconfig.cooklang.setup{}
```

### Vim with CoC

Add to `coc-settings.json`:
```json
{
  "languageserver": {
    "cooklang": {
      "command": "cook",
      "args": ["lsp"],
      "filetypes": ["cooklang"],
      "rootPatterns": [".git", "config"]
    }
  }
}
```

### Emacs

Using [lsp-mode](https://emacs-lsp.github.io/lsp-mode/):

```elisp
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
    '(cooklang-mode . "cooklang"))

  (lsp-register-client
    (make-lsp-client
      :new-connection (lsp-stdio-connection '("cook" "lsp"))
      :activation-fn (lsp-activate-on "cooklang")
      :server-id 'cooklang-lsp)))
```

Using [eglot](https://github.com/joaotavora/eglot):

```elisp
(add-to-list 'eglot-server-programs
  '(cooklang-mode . ("cook" "lsp")))
```

### Helix

Add to `languages.toml`:
```toml
[[language]]
name = "cooklang"
scope = "source.cooklang"
file-types = ["cook"]
language-servers = ["cooklang-lsp"]

[language-server.cooklang-lsp]
command = "cook"
args = ["lsp"]
```

### Sublime Text

Using [LSP package](https://github.com/sublimelsp/LSP):

```json
{
  "clients": {
    "cooklang": {
      "enabled": true,
      "command": ["cook", "lsp"],
      "selector": "source.cooklang"
    }
  }
}
```

### Zed

Add to `settings.json`:
```json
{
  "lsp": {
    "cooklang": {
      "binary": {
        "path": "cook",
        "arguments": ["lsp"]
      }
    }
  }
}
```

## Troubleshooting

Verify `cook` is in your PATH:
```bash
which cook
cook --version
```

Check server logs:
```bash
cook lsp 2>/tmp/cooklang-lsp.log
```

Enable debug logging:
```bash
RUST_LOG=debug cook lsp 2>/tmp/cooklang-lsp-debug.log
```
