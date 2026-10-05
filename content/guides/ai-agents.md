---
title: 'Use Cooklang with Your AI Agent'
weight: 34
description: 'Install cook-mcp, an open-source MCP server that lets Claude Code, Claude Desktop, Cursor, ChatGPT or any MCP client read, validate and write the .cook and .menu files in your recipe folder.'
group: power
tools: [cook-mcp, MCP client]
---

[cook-mcp](https://github.com/cook-md/cook-mcp) is an open-source MCP server that gives your AI agent tools over a local Cooklang recipe folder. Your recipes stay as plain `.cook` and `.menu` files on your disk; the agent reads and writes them in place, and every write is validated first.

It is free and runs locally with no account. Nutrition and photo import go through cook.md and need Cook Basic or Pro.

## Install

Claude Code:

```bash
claude mcp add cook -- npx -y @cookmd/mcp
```

Any client that takes an `mcpServers` config (Claude Desktop, Cursor, ChatGPT and others):

```json
{
  "mcpServers": {
    "cook": {
      "command": "npx",
      "args": ["-y", "@cookmd/mcp"],
      "env": { "COOK_RECIPES_DIR": "/path/to/recipes" }
    }
  }
}
```

`COOK_RECIPES_DIR` is the recipe root. If it is not set, the client's working directory is used. Builds exist for macOS and Linux (x64 and arm64), not Windows yet.

## What the agent can do

- Read and search your recipes and meal plans, with optional scaling.
- Validate a file, a folder or the whole collection, and find broken references.
- Write `.cook` recipes and `.menu` meal plans. Invalid Cooklang is refused, and there is no delete tool.
- Build a shopping list from recipes and menus: duplicates merged, grouped by aisle, pantry subtracted.
- Track the pantry: expiring items, low stock, and which recipes you can cook with what you have.
- Render report templates, and with Cook Basic or Pro, compute nutrition and import recipes from photos.

Try: "Plan dinners for next week from my recipes and make the shopping list."

## More

- Source and full tool list: [github.com/cook-md/cook-mcp](https://github.com/cook-md/cook-mcp)
- Setup notes for specific clients: [cook.md/help/mcp](https://cook.md/help/mcp)
