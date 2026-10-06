---
title: 'Use Cooklang with Your AI Agent'
weight: 34
description: 'Install the Cooklang plugin (14 skills plus the open-source Cook MCP server) for Claude Code, Codex, Gemini CLI, Cursor or VS Code, or add the server to any MCP client, to read, validate and write the .cook and .menu files in your recipe folder.'
group: power
tools: [cooklang-skills, cook-mcp, MCP client]
---

The Cooklang plugin gives your AI agent 14 skills (writing, validating, searching, importing, meal planning, shopping lists, pantry, reports) and the open-source [Cook MCP server](https://github.com/cook-md/cook-mcp) that the skills call. Your recipes stay as plain `.cook` and `.menu` files in a folder you own, and every write is validated first.

Everything is free and runs locally with no account. Nutrition data and photo or social import go through cook.md and need Cook Basic or Pro. You need Node.js, because the server runs through `npx`. Builds exist for macOS and Linux (x64 and arm64), not Windows yet.

## Claude Code

Recommended. Install the plugin:

```
/plugin marketplace add cooklang/cooklang-skills
/plugin install cooklang@cooklang-skills
```

It adds the skills and starts the Cook server with your project folder as the recipe folder. Check it with `/mcp`. If you added the server earlier with `claude mcp add cook`, remove it so only one copy runs.

## Codex

```bash
codex plugin marketplace add cooklang/cooklang-skills
codex plugin add cooklang@cooklang-skills
```

Codex does not tell MCP servers which workspace you have open, so set the recipe folder by adding the server yourself. It replaces the plugin's copy:

```bash
codex mcp add cook --env COOK_RECIPES_DIR=/path/to/recipes -- npx -y @cookmd/mcp
```

## Gemini CLI

```bash
gemini extensions install https://github.com/cooklang/cooklang-skills
```

The extension adds the skills and the server, using your workspace as the recipe folder.

## Cursor

The repository is an [Agent Plugin](https://agent-plugins.org) that Cursor loads with the skills and the server. To add only the server, use the one-click link in the [cooklang-skills README](https://github.com/cooklang/cooklang-skills#cursor).

## VS Code

Run **Chat: Install Plugin From Source** and enter `https://github.com/cooklang/cooklang-skills`. To add only the server, use the one-click link in the [cooklang-skills README](https://github.com/cooklang/cooklang-skills#vs-code--github-copilot).

## Any other MCP client

For Claude Desktop and any client that takes an `mcpServers` config, add the server and point it at your recipes (in Claude Desktop: Settings > Developer > Edit Config):

```json
{
  "mcpServers": {
    "cook": {
      "command": "npx",
      "args": ["-y", "@cookmd/mcp"],
      "env": { "COOK_RECIPES_DIR": "/absolute/path/to/recipes" }
    }
  }
}
```

## How the recipe folder is chosen

1. `COOK_RECIPES_DIR`, if set in the server's config.
2. The workspace folder your client reports, which is the project you have open.
3. The folder the client started the server in. `/`, your home folder and plugin folders are ignored.

## What the agent can do

- Read and search your recipes and meal plans, with optional scaling.
- Validate a file, a folder or the whole collection, and find broken references.
- Write `.cook` recipes and `.menu` meal plans. Invalid Cooklang is refused, and there is no delete tool.
- Build a shopping list from recipes and menus: duplicates merged, grouped by aisle, pantry subtracted.
- Track the pantry: expiring items, low stock, and which recipes you can cook with what you have.
- Render report templates, and with Cook Basic or Pro, compute nutrition and import recipes from photos and social links.

Try: "Plan dinners for next week from my recipes and make the shopping list."

## More

- Plugin and skills: [github.com/cooklang/cooklang-skills](https://github.com/cooklang/cooklang-skills)
- Server source and full tool list: [github.com/cook-md/cook-mcp](https://github.com/cook-md/cook-mcp)
- Setup notes for specific clients: [cook.md/help/mcp](https://cook.md/help/mcp)
