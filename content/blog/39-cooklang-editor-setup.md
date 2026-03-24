---
title: "Cooklang Editor Setup: VS Code, Vim, Obsidian, and More"
date: 2026-03-24
weight: 47
summary: "Cooklang files are plain text, so any editor works. But syntax highlighting and LSP support make the experience much better. Here's how to set up your editor of choice."
---

Cooklang files are plain text, so any editor works — Notepad, nano, whatever you already have open. But syntax highlighting and proper tooling make a real difference when you're writing recipes. Ingredients pop out visually, timers are easy to spot, and the LSP catches errors before you do.

Here's how to set up the major editors.

## VS Code

The easiest path. Search for "Cooklang" in the VS Code extensions panel, or install it directly from the [VS Code marketplace](https://marketplace.visualstudio.com/items?itemName=cooklang.cooklang).

Once installed, open any `.cook` file and you get immediate syntax highlighting:

- Ingredients (`@ingredient{quantity%unit}`) highlight in one color
- Cookware (`#pan{}`) in another
- Timers (`~{15%minutes}`) stand out distinctly
- Comments (`--`) are dimmed
- Section headers (`= Section name`) are emphasized
- YAML frontmatter is highlighted as a block

No configuration required. Open a `.cook` file and it works.

If you also want diagnostics and completions, add the LSP on top (covered below).

## Neovim

Cooklang has a [tree-sitter grammar](https://github.com/addcninblue/tree-sitter-cooklang) that plugs into Neovim via `nvim-treesitter`. Add this to your config:

```lua
require("nvim-treesitter.configs").setup({
  ensure_installed = { "cooklang" },
  highlight = {
    enable = true,
  },
})
```

Then register the parser source so nvim-treesitter knows where to find it:

```lua
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.cooklang = {
  install_info = {
    url = "https://github.com/addcninblue/tree-sitter-cooklang",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "cooklang",
}
```

Run `:TSInstall cooklang` and you're done. You get syntax highlighting, folding, and indentation support.

For a more complete setup, pair this with the LSP (see below). That gives you diagnostics on top of the tree-sitter highlighting.

## Vim (without tree-sitter)

If you're on plain Vim or an older Neovim without tree-sitter, you can add a basic filetype detection rule to your `.vimrc`:

```vim
au BufRead,BufNewFile *.cook set filetype=cooklang
```

This won't give you full syntax highlighting without a Vim syntax file, but it sets the stage if you want to write one or find a community-maintained version. The LSP approach below works here too if your Vim has LSP client support.

## Obsidian

If you already keep notes in Obsidian, the Cooklang plugin brings your recipes into the same vault.

Install it from **Settings → Community Plugins → Browse**, search for "Cooklang Editor", and enable it. Obsidian will recognize `.cook` files from that point on.

The plugin gives you:

- Syntax highlighting in edit mode
- A formatted preview mode with ingredients list, cookware list, and numbered steps
- Interactive timers — click a timer in preview and a countdown starts inside Obsidian
- Ingredient checklists for use while shopping

Your `.cook` files behave like any other note in your vault. They show up in search, appear in the graph view, support tags, and accept backlinks from other notes. A recipe index note can link to individual recipes; meal plan notes can reference whatever you're cooking that week.

There's a full walkthrough in [How to Manage Recipes in Obsidian with Cooklang](/blog/how-to-manage-recipes-in-obsidian-with-cooklang/).

## Emacs

The tree-sitter grammar works with Emacs through the built-in `treesit` support introduced in Emacs 29. Clone the grammar and point your config at it:

```elisp
(add-to-list 'treesit-language-source-alist
             '(cooklang . ("https://github.com/addcninblue/tree-sitter-cooklang")))
```

Then run `M-x treesit-install-language-grammar RET cooklang` to compile and install it. Define a derived major mode for `.cook` files to activate the grammar automatically.

For LSP support, `eglot` (built into Emacs 29+) or `lsp-mode` both work with the `cook lsp` server described below.

## Helix and Zed

Both editors support tree-sitter natively and can use the Cooklang grammar. Helix has a growing community of language grammar contributions — check the Helix documentation for the current state of external grammar support. Zed handles tree-sitter grammars through its extension system.

In both cases, the underlying grammar is the same one used by Neovim and Emacs, so highlighting behavior is consistent across editors.

## LSP: Any Editor That Supports It

CookCLI ships a Language Server Protocol implementation. Run it with:

```bash
cook lsp
```

This gives you:

- Error diagnostics as you type (malformed ingredient syntax, unclosed sections, etc.)
- Hover information
- Completions

Configure your editor to use `cook lsp` as the language server for `.cook` files. The exact setup depends on your editor's LSP client, but the server itself is the same regardless of editor.

**VS Code** — if you have the Cooklang extension installed, LSP support is already bundled.

**Neovim with nvim-lspconfig:**

```lua
local lspconfig = require("lspconfig")
lspconfig.cooklang_ls.setup({
  cmd = { "cook", "lsp" },
  filetypes = { "cooklang" },
})
```

**Emacs with eglot:**

```elisp
(add-to-list 'eglot-server-programs
             '(cooklang-mode . ("cook" "lsp")))
```

If your editor has an LSP client, it can use `cook lsp`. The [CookCLI reference at /cli/](/cli/) covers installation if you don't have it yet.

## Browser: No Install Required

If you want to test Cooklang syntax without setting up anything, the [playground](https://cooklang.github.io/cooklang-rs/) runs in a browser tab. Write on the left, see the parsed output on the right. Nothing is sent to a server — it runs locally in your browser via WebAssembly.

Useful for checking whether a particular syntax construct does what you expect before committing it to a recipe file.

## Which Editor Should You Use?

The one you're already in. Cooklang tooling exists for all the major editors, so you don't need to switch. If you're a VS Code user, install the extension and move on. If you live in Neovim, set up tree-sitter and the LSP. If you're in Obsidian, the plugin handles everything.

The format is plain text. The files stay on your disk. The editor is just a window into them.

The [Cooklang syntax reference at /docs/spec/](/docs/spec/) covers the full language. The [syntax highlighting docs at /docs/syntax-highlighting/](/docs/syntax-highlighting/) have more detail on editor-specific setup. And if you're just getting started, [the getting started guide](/docs/getting-started/) walks through writing your first recipe.

-Alex
