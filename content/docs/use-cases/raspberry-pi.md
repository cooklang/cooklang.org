---
title: "Raspberry Pi Kitchen Server"
weight: 65
description: "Run CookCLI on a Raspberry Pi as a dedicated recipe server on your local network"
---

A Raspberry Pi running CookCLI serves your recipes to every device on your home network. No cloud, no subscription — just a $35 board drawing less power than a LED bulb.

{{< server-carousel >}}

## What You Need

- Raspberry Pi 3B+ or newer (2GB+ RAM)
- MicroSD card (16GB+)
- Power supply and network connection

## Quick Start

### 1. Prepare the Pi

Flash [Raspberry Pi OS Lite](https://www.raspberrypi.com/software/) to your SD card. Enable SSH and configure WiFi during imaging.

```bash
ssh pi@raspberrypi.local
# Change the default password immediately
```

### 2. Install CookCLI

```bash
# For 64-bit Pi OS (Pi 3B+, Pi 4, Pi 5)
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-unknown-linux-musl.tar.gz
tar -xzf cook-aarch64-unknown-linux-musl.tar.gz
chmod +x cook
sudo mv cook /usr/local/bin/

# For 32-bit Pi OS (older models)
# wget https://github.com/cooklang/cookcli/releases/latest/download/cook-arm-unknown-linux-musleabihf.tar.gz

cook --version
```

### 3. Add Recipes and Start the Server

```bash
mkdir ~/recipes
echo "Boil @water{2%cups}. Add @tea{1%bag}." > ~/recipes/tea.cook

cook server ~/recipes --host --port 9080
```

Access from any device: `http://raspberrypi.local:9080`

## Running as a Service

Create a systemd service so the server starts automatically and survives reboots:

```bash
sudo nano /etc/systemd/system/cooklang.service
```

```ini
[Unit]
Description=CookLang Recipe Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/recipes
ExecStart=/usr/local/bin/cook server --host --port 9080
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable cooklang.service
sudo systemctl start cooklang.service

# Check status
sudo systemctl status cooklang.service
```

## Network Setup

### Static IP

Reserve a consistent IP so your bookmark always works:

```bash
sudo nano /etc/dhcpcd.conf
```

```
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1
```

### Mobile Access

Add a home screen shortcut on your phone:

- **iOS**: Safari > Share > "Add to Home Screen"
- **Android**: Chrome > Menu > "Add to Home screen"

### Firewall

```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9080/tcp
sudo ufw enable
```

## Syncing Recipes

### Git

Version control your recipes and sync across devices:

```bash
cd ~/recipes
git init
git add .
git commit -m "Initial recipe collection"
git remote add origin git@github.com:yourusername/recipes.git
git push -u origin main
```

Pull changes from other devices with a cron job:

```bash
crontab -e
# Add:
*/15 * * * * cd /home/pi/recipes && git pull --quiet
```

### Backups

```bash
#!/bin/bash
# /home/pi/backup-recipes.sh
BACKUP_DIR="/home/pi/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/recipes_$DATE.tar.gz" -C /home/pi/recipes .

# Keep only last 7 backups
ls -t "$BACKUP_DIR"/recipes_*.tar.gz | tail -n +8 | xargs -r rm
```

```bash
crontab -e
# Add daily backup at 2 AM:
0 2 * * * /home/pi/backup-recipes.sh
```

## Optional: Nginx Reverse Proxy

Serve on port 80 with caching and compression:

```bash
sudo apt install nginx -y
sudo nano /etc/nginx/sites-available/cooklang
```

```nginx
server {
    listen 80;
    server_name recipes.local;

    location / {
        proxy_pass http://localhost:9080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;

        gzip on;
        gzip_types text/plain application/json text/css application/javascript;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/cooklang /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## SD Card Optimization

Reduce write wear for longer card life:

```bash
# Disable swap
sudo dphys-swapfile swapoff
sudo systemctl disable dphys-swapfile

# Move logs to RAM
echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,size=50m 0 0" | sudo tee -a /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=100m 0 0" | sudo tee -a /etc/fstab
```

## What to Expect

- **Page load**: <100ms on local network
- **Concurrent users**: 10-15 comfortably
- **Recipe capacity**: 10,000+
- **Power**: ~5W (~$5/year electricity)
- **Cost**: ~$75 for Pi 4 (2GB) + SD card + power + case

## Troubleshooting

**Can't connect from other devices**: Check `sudo ufw status` — port 9080 must be allowed. Verify the Pi's IP with `ip addr show`.

**Server stops when SSH closes**: Use the systemd service above, or `nohup cook server ~/recipes --host &` as a quick fix.

**Slow loading**: Check SD card health with `sudo hdparm -t /dev/mmcblk0` (should be >20 MB/sec). Monitor resources with `htop`.

**Wrong architecture binary**: Run `uname -m` to check — `aarch64` needs the 64-bit binary, `armv7l` needs 32-bit.

## See Also

- [CookCLI Server Command](/cli/commands/server/) — server configuration options
- [Shopping Lists](../shopping/) — generate lists from your recipes
- [Meal Planning](../meal-planning/) — plan weekly meals
