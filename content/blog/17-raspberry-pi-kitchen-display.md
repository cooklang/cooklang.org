---
title: "Build a Raspberry Pi Kitchen Display for Your Recipes"
date: 2026-02-25
weight: 60
summary: "Turn a Raspberry Pi into a dedicated kitchen recipe display. Run CookCLI's web server on the Pi, sync your Cooklang recipes, and browse them from a touchscreen or any device on your network."
---

A Raspberry Pi with a small display makes a practical kitchen companion. Run [CookCLI](/cli/) on it, point it at your recipe collection, and you get a browsable recipe server accessible from any device on your network — or directly on a touchscreen mounted in your kitchen.

This guide covers the hardware, setup, and a few tricks to make it work well in a kitchen environment.

## What You Need

- **Raspberry Pi 4 or 5** (2GB+ RAM is fine — CookCLI is lightweight)
- **microSD card** (16GB+)
- **Power supply** for your Pi model
- **Optional: touchscreen display** (the official 7" Raspberry Pi Touch Display works well, or any HDMI monitor)
- Your recipes in [Cooklang format](/docs/spec/)

If you don't want a dedicated screen, skip the display — you can access the recipe server from your phone, tablet, or laptop over your local network.

## Install Raspberry Pi OS

Flash Raspberry Pi OS Lite (64-bit) to your microSD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/). During setup:

- Enable SSH
- Configure your Wi-Fi
- Set a hostname (e.g., `kitchen`)

Boot the Pi and SSH in:

```bash
ssh pi@kitchen.local
```

## Install CookCLI

### Option A: Docker (Recommended)

Install Docker on the Pi:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in, then run CookCLI:

```bash
docker run -d \
  --name cookcli \
  --restart unless-stopped \
  -p 9080:9080 \
  -v /home/pi/recipes:/recipes \
  ghcr.io/cooklang/cookcli:0.23.0
```

Pre-built ARM images are available for both Pi 4+ (aarch64) and Pi 3 (armv7), so Docker pulls the right architecture automatically.

### Option B: Binary Install

Download the ARM binary from the [CookCLI releases page](https://github.com/cooklang/CookCLI/releases):

```bash
# For Pi 4/5 (64-bit)
wget https://github.com/cooklang/CookCLI/releases/latest/download/cook-aarch64-unknown-linux-musl.tar.gz
tar xzf cook-aarch64-unknown-linux-musl.tar.gz
sudo mv cook /usr/local/bin/
```

## Get Your Recipes Onto the Pi

### Git Sync (Best for Version Control)

If your recipes are in a Git repository:

```bash
sudo apt install git
git clone https://github.com/yourusername/cookbook.git /home/pi/recipes
```

Set up a cron job to pull updates automatically:

```bash
crontab -e
# Add this line to sync every hour:
0 * * * * cd /home/pi/recipes && git pull --quiet
```

### Syncthing (Best for Real-Time Sync)

[Syncthing](https://syncthing.net/) keeps your recipe folder in sync across devices. Install it on the Pi and your main computer, share the recipe folder, and edits propagate automatically.

### Simple Copy

Or just copy your recipes over:

```bash
scp -r ~/my-recipes/ pi@kitchen.local:/home/pi/recipes/
```

## Start the Recipe Server

If you installed the binary (not Docker):

```bash
cook server /home/pi/recipes --host --port 9080
```

The `--host` flag makes the server accessible from other devices on your network, not just localhost.

### Run on Boot with systemd

Create a service file so CookCLI starts automatically:

```bash
sudo tee /etc/systemd/system/cooklang.service << 'EOF'
[Unit]
Description=Cooklang Recipe Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/recipes
ExecStart=/usr/local/bin/cook server --host --port 9080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable cooklang
sudo systemctl start cooklang
```

## Browse Recipes

Open a browser on any device on your network and go to:

```
http://kitchen.local:9080
```

(Or use the Pi's IP address: `http://192.168.1.100:9080`)

The web interface lets you:

- **Browse** recipes organized by folder
- **Search** by ingredient or recipe name
- **Scale** recipes up or down — ingredient quantities adjust automatically
- **Generate shopping lists** from multiple recipes at once
- **Track your pantry** to see what you already have and what you need

The interface is responsive, so it works on a touchscreen, phone, or desktop browser.

## Optional: Kiosk Mode for Touchscreen

If you're using a touchscreen display, set up the Pi to boot directly into the recipe browser in fullscreen:

```bash
sudo apt install chromium-browser unclutter

# Auto-start Chromium in kiosk mode
mkdir -p /home/pi/.config/autostart
cat > /home/pi/.config/autostart/kiosk.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Recipe Kiosk
Exec=chromium-browser --kiosk --noerrdialogs --disable-infobars http://localhost:9080
EOF
```

Install a minimal desktop environment if you're on Raspberry Pi OS Lite:

```bash
sudo apt install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox
```

The `unclutter` package hides the mouse cursor after a few seconds of inactivity — useful for a touchscreen-only setup.

## Organize Your Recipes for Browsing

The recipe server mirrors your folder structure. Organize your recipes into directories for easy navigation:

```
recipes/
├── Breakfast/
├── Dinner/
│   ├── Quick/
│   ├── Weekend/
│   └── Batch Cooking/
├── Desserts/
├── Sides/
└── Meal Plans/
    └── This Week/
```

Add an `aisle.conf` file to your recipe directory to organize shopping lists by store section:

```
[Produce]
tomato|tomatoes
onion|onions
garlic

[Dairy]
milk
butter
cheese

[Pantry]
olive oil
salt
pepper
```

## What This Gets You

A dedicated kitchen device that:

- Shows your entire recipe collection, searchable and browsable
- Generates shopping lists from whatever you plan to cook this week
- Doesn't require internet access after initial setup
- Costs under $100 in hardware (less if you skip the display)
- Uses about 5 watts of power running idle

The Pi handles CookCLI's server easily — it's a single Rust binary with minimal resource requirements. No database server, no background services, just your recipes as text files served over HTTP.

[Get started with Cooklang →](/docs/getting-started/) | [CookCLI documentation →](/cli/)

-Alex
