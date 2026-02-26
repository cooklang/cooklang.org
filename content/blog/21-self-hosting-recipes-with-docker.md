---
title: "Self-Hosting Your Recipe Collection with Docker and CookCLI"
date: 2026-02-25
weight: 60
summary: "Set up a self-hosted recipe server in minutes with Docker and CookCLI. Browse recipes from any device, generate shopping lists, and keep your data private — no cloud accounts required."
---

If you keep your recipes in [Cooklang format](/docs/spec/), you can serve them on your local network with a single Docker command. [CookCLI](/cli/) runs a lightweight web server that lets you browse, search, and generate shopping lists from any device — phone, tablet, or laptop.

No cloud account. No subscription. Your recipes stay on your hardware.

## Quick Start

If you already have Docker installed:

```bash
docker run -d \
  --name cookcli \
  --restart unless-stopped \
  -p 9080:9080 \
  -v /path/to/your/recipes:/recipes \
  ghcr.io/cooklang/cookcli:0.23.0
```

Replace `/path/to/your/recipes` with the directory containing your `.cook` files. Open `http://localhost:9080` in a browser and you're done.

## Docker Compose Setup

For a more maintainable setup, create a `docker-compose.yml`:

```yaml
services:
  cookcli:
    image: ghcr.io/cooklang/cookcli:0.23.0
    ports:
      - "9080:9080"
    volumes:
      - ./recipes:/recipes
    restart: unless-stopped
```

Then:

```bash
docker compose up -d
```

Put your `.cook` recipe files in the `./recipes` directory. The server picks them up automatically — no restart needed when you add new recipes.

## What the Server Does

The web interface at `http://localhost:9080` provides:

- **Recipe browsing** — folder-based navigation that mirrors your directory structure
- **Search** — find recipes by name or ingredient
- **Recipe scaling** — adjust serving sizes and all ingredient quantities update
- **Shopping lists** — select multiple recipes, set individual serving counts, and generate a combined list organized by store aisle
- **Pantry tracking** — mark what you already have, and shopping lists exclude those items
- **Mobile-friendly** — responsive layout works on phones and tablets

The server is read-only — it serves your recipe files but doesn't modify them. Editing happens in your text editor, Obsidian, or VS Code.

## Accessing from Other Devices

By default, CookCLI's Docker image binds to all interfaces (`--host`), so it's accessible from any device on your local network.

Find your server's IP address:

```bash
# macOS
ipconfig getifaddr en0

# Linux
hostname -I | awk '{print $1}'
```

Then open `http://192.168.1.100:9080` (your IP will differ) from your phone or tablet.

## Organizing Recipes for the Server

The server displays your folder structure as navigation. A clean directory layout makes browsing easier:

```
recipes/
├── aisle.conf
├── Breakfast/
│   ├── pancakes.cook
│   └── overnight-oats.cook
├── Dinner/
│   ├── Quick Weeknight/
│   ├── Weekend Projects/
│   └── Batch Cooking/
├── Desserts/
├── Sides/
└── Basics/
    ├── chicken-stock.cook
    └── pizza-dough.cook
```

### Aisle Configuration

Add an `aisle.conf` file to your recipe directory to organize shopping lists by store section:

```
[Produce]
tomato|tomatoes
onion|onions
garlic
lettuce
bell pepper|bell peppers

[Dairy]
milk
butter
cheese
cream
eggs

[Meat]
chicken
beef
pork

[Pantry]
olive oil
salt
pepper
flour
sugar
rice
pasta

[Spices]
cumin
paprika
oregano
chili flakes
```

Ingredients matching these patterns get grouped by aisle in your shopping list. The `|` syntax handles plurals and alternate names.

## Syncing Recipes to the Server

### Git (Recommended)

Mount a Git repository as the recipe volume:

```bash
# On the server
git clone https://github.com/yourusername/cookbook.git /home/user/recipes
```

Set up a cron job or systemd timer to pull updates:

```bash
# Pull every 30 minutes
*/30 * * * * cd /home/user/recipes && git pull --quiet
```

Recipes you push from your laptop appear on the server within 30 minutes.

### Syncthing

For real-time sync without Git, [Syncthing](https://syncthing.net/) runs well alongside the recipe server:

```yaml
services:
  cookcli:
    image: ghcr.io/cooklang/cookcli:0.23.0
    ports:
      - "9080:9080"
    volumes:
      - recipes:/recipes
    restart: unless-stopped

  syncthing:
    image: syncthing/syncthing
    ports:
      - "8384:8384"
      - "22000:22000"
    volumes:
      - recipes:/var/syncthing/recipes
    restart: unless-stopped

volumes:
  recipes:
```

Edit a recipe on your phone or laptop and it appears on the server immediately.

## Running on a VPS

If you want to access your recipes outside your home network, deploy to any VPS provider. A $5/month server handles this easily. Add a reverse proxy for HTTPS:

```nginx
server {
    server_name recipes.example.com;

    location / {
        proxy_pass http://localhost:9080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Add Let's Encrypt with `certbot` for TLS and you have a private recipe server accessible from anywhere.

## Resource Usage

CookCLI is a single Rust binary. It uses minimal resources:

- **Memory:** ~20–30 MB for a collection of several hundred recipes
- **CPU:** Negligible — it's serving text files
- **Disk:** The Docker image is ~30 MB. Your recipes are plain text, so even thousands of recipes use very little space.

It runs well on a Raspberry Pi, an old laptop, a NAS, or any VPS.

## Comparison with Other Self-Hosted Options

If you're evaluating self-hosted recipe managers, CookCLI's server is the simplest option — no database, no configuration, just point it at a directory. For more features (meal planning calendars, multi-user access, web scraping), see our [comparison of open source recipe managers](/blog/the-best-open-source-recipe-managers-in-2026/).

The trade-off is clear: CookCLI gives you simplicity and data portability (plain text files). Database-backed tools like Mealie and Tandoor give you richer features at the cost of more infrastructure.

[CookCLI documentation →](/cli/) | [Get started with Cooklang →](/docs/getting-started/)

-Alex
