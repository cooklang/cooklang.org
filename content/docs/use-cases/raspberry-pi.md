---
title: "Raspberry Pi Kitchen Server"
weight: 65
description: "Turn a Raspberry Pi into your dedicated recipe server for 24/7 kitchen access"
---

**In 30 minutes**, you'll transform a $35 Raspberry Pi into your personal recipe server that runs 24/7 in your kitchen. No cloud subscriptions, no privacy concerns - just your recipes, always available.

{{< server-carousel >}}

## Table of Contents

- [Quick Start: 5 Steps to Your Recipe Server](#quick-start-5-steps-to-your-recipe-server)
- [Installation Deep Dive](#installation-deep-dive)
  - [Preparing Your Raspberry Pi](#preparing-your-raspberry-pi)
  - [Installing CookCLI](#installing-cookcli)
  - [Optimizing for Raspberry Pi](#optimizing-for-raspberry-pi)
- [Production Deployment](#production-deployment)
  - [Systemd Service Setup](#systemd-service-setup)
  - [Network Access](#network-access)
  - [Mobile Access](#mobile-access)
- [Advanced Configurations](#advanced-configurations)
  - [Performance Tuning](#performance-tuning)
  - [Multi-User Household](#multi-user-household)
  - [Backup & Sync](#backup--sync)
- [Troubleshooting: Quick Fixes](#troubleshooting-quick-fixes)
- [Security Best Practices](#security-best-practices)
- [Performance & Cost](#performance--cost)
- [Tips and Best Practices](#tips-and-best-practices)
- [Your Recipe Server Journey](#your-recipe-server-journey)

### What You'll Achieve

* ✓ **Always-on recipe access** from any device on your network
* ✓ **Zero monthly fees** - one-time setup, years of service
* ✓ **Complete privacy** - your recipes stay in your home
* ✓ **Family-friendly** - multiple users can browse recipes simultaneously
* ✓ **Power-efficient** - uses less electricity than a LED bulb ($5/year)

### This Guide Is For You If

- You have a spare Raspberry Pi (or planning to get one)
- You want reliable recipe access without internet dependency
- You're comfortable with basic command-line usage
- You have 30-60 minutes for initial setup

### What You'll Need

- **Raspberry Pi** (3B+ or newer, 2GB+ RAM)
- **MicroSD card** (16GB+)
- **Power supply** and network connection
- **30 minutes** for basic setup

## Quick Start: 5 Steps to Your Recipe Server

Follow these steps to get your recipe server running in under 30 minutes:

### Step 1: Prepare Your Raspberry Pi (10 minutes)
Flash Raspberry Pi OS Lite to your SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Enable SSH and configure WiFi during the imaging process.

### Step 2: Connect to Your Pi (2 minutes)
```bash
ssh pi@raspberrypi.local
# Default password: raspberry (change it immediately!)
```

### Step 3: Install CookCLI (3 minutes)
```bash
# Download and install CookCLI for Raspberry Pi (ARM64)
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-unknown-linux-musl.tar.gz
tar -xzf cook-aarch64-unknown-linux-musl.tar.gz
chmod +x cook
sudo mv cook /usr/local/bin/

# Verify installation
cook --version
```

### Step 4: Create Your Recipe Directory (1 minute)
```bash
# Create a home for your recipes
mkdir ~/recipes

# Optional: Add a sample recipe to test
echo "Boil @water{2%cups}. Add @tea{1%bag}." > ~/recipes/tea.cook
```

### Step 5: Launch Your Server (1 minute)
```bash
# Start the CookLang server
cook server ~/recipes --host 0.0.0.0 --port 9080
```

**🎉 Success!** Your recipe server is now running. Access it from any device:
- By hostname: `http://raspberrypi.local:9080`
- By IP address: `http://[your-pi-ip]:9080`

**Next**: Make it permanent with our [production setup](#production-deployment) below.

## Installation Deep Dive

### Preparing Your Raspberry Pi

#### Operating System Choice

We recommend **Raspberry Pi OS Lite** for headless operation - it uses less memory and runs faster without the desktop environment.

```bash
# Initial configuration
sudo raspi-config

# Set the following:
# - System Options > Password (change default)
# - System Options > Hostname (e.g., "recipes")
# - Interface Options > SSH (enable)
# - Localisation Options > Timezone
# - Advanced Options > Expand Filesystem
```

#### Network Configuration

Set a static IP for consistent access:

```bash
# Edit dhcpcd configuration
sudo nano /etc/dhcpcd.conf

# Add these lines (adjust for your network):
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1
```

#### Basic Security

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install firewall
sudo apt install ufw -y

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9080/tcp  # CookCLI server port
sudo ufw enable
```

### Installing CookCLI

The fastest way to get CookCLI running on your Raspberry Pi:

```bash
# Determine your Pi's architecture
uname -m
# aarch64 = 64-bit ARM (Pi 3B+, Pi 4, Pi 5)
# armv7l = 32-bit ARM (older models)

# For 64-bit Raspberry Pi OS (most common - Pi 3B+, Pi 4, Pi 5)
cd /tmp
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-unknown-linux-musl.tar.gz
tar -xzf cook-aarch64-unknown-linux-musl.tar.gz
sudo mv cook /usr/local/bin/cook

# For 32-bit Raspberry Pi OS (older models)
cd /tmp
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-arm-unknown-linux-musleabihf.tar.gz
tar -xzf cook-arm-unknown-linux-musleabihf.tar.gz
sudo mv cook /usr/local/bin/cook

# Verify installation
cook --version
```

#### Troubleshooting Installation

**Wrong architecture error**:
```bash
# Check your system
file /usr/local/bin/cook
# Should match your system architecture

# If wrong, download correct version:
uname -m  # Check architecture
# Then download matching binary
```

**Permission denied**:
```bash
# Ensure executable permissions
chmod +x /usr/local/bin/cook
# Or use sudo for installation
```

**Command not found**:
```bash
# Check if installed
ls -la /usr/local/bin/cook

# Add to PATH if needed
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Optimizing for Raspberry Pi

#### SD Card Optimization

Reduce wear on your SD card:

```bash
# Disable swap
sudo dphys-swapfile swapoff
sudo systemctl disable dphys-swapfile

# Move logs to RAM
echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,size=50m 0 0" | sudo tee -a /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=100m 0 0" | sudo tee -a /etc/fstab
```

#### Memory Tuning

For Raspberry Pi with limited RAM:

```bash
# Create swap file (only if needed)
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# Adjust swappiness
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
```

## Production Deployment

### Systemd Service Setup

Create a service to run CookCLI automatically:

```bash
# Create service file
sudo nano /etc/systemd/system/cooklang.service
```

Add the following content:

```ini
[Unit]
Description=CookLang Recipe Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/recipes
ExecStart=/usr/local/bin/cook server --host 0.0.0.0 --port 9080
Restart=always
RestartSec=10
StandardOutput=append:/var/log/cooklang.log
StandardError=append:/var/log/cooklang.log

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
# Enable service
sudo systemctl daemon-reload
sudo systemctl enable cooklang.service
sudo systemctl start cooklang.service

# Check status
sudo systemctl status cooklang.service

# View logs
sudo journalctl -u cooklang.service -f
```

### Network Access

#### Local DNS Setup

Make your server easily accessible by hostname instead of IP address:

```bash
# Avahi (mDNS) is usually pre-installed on Raspberry Pi OS
# If not, install it:
sudo apt install avahi-daemon -y

# Check current hostname
hostname

# Your Pi is now accessible as [hostname].local
# Default: raspberrypi.local
# After renaming: recipes.local
```

**Access methods after setup:**
- `http://recipes.local:9080` - Works on most devices (iOS, macOS, Linux, Windows 10+)
- `http://192.168.1.100:9080` - Direct IP always works
- Bookmark either URL for quick access

**Note for Windows users**: Older Windows versions may need Bonjour installed for .local addresses

#### Router Configuration

1. Reserve the Pi's IP address in your router's DHCP settings
2. Consider setting up port forwarding if you need external access (use VPN for security)
3. Create a DNS entry if your router supports it

### Mobile Access

#### iOS
- Open Safari and navigate to your server
- Tap the Share button > "Add to Home Screen"
- Name it "Recipes" for easy access

#### Android
- Open Chrome and navigate to your server
- Tap menu > "Add to Home screen"
- Creates an app-like shortcut

## Advanced Configurations

### Performance Tuning

#### Nginx Reverse Proxy

Add caching and compression:

```bash
# Install nginx
sudo apt install nginx -y

# Configure nginx
sudo nano /etc/nginx/sites-available/cooklang
```

```nginx
server {
    listen 80;
    server_name recipes.local;

    location / {
        proxy_pass http://localhost:9080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;

        # Caching
        proxy_cache_valid 200 1d;
        proxy_cache_bypass $http_pragma;
        proxy_cache_revalidate on;

        # Compression
        gzip on;
        gzip_types text/plain application/json text/css application/javascript;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/cooklang /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Multi-User Household

Set up separate recipe collections:

```bash
# Create user directories
mkdir -p ~/recipes/{shared,alice,bob,kids}

# Set permissions
chmod 755 ~/recipes/*

# Run server with base directory
cook server ~/recipes --host 0.0.0.0
```

### Backup & Sync

#### Automated Backups

Create a backup script:

```bash
#!/bin/bash
# /home/pi/backup-recipes.sh

BACKUP_DIR="/home/pi/backups"
DATE=$(date +%Y%m%d_%H%M%S)
RECIPES_DIR="/home/pi/recipes"

# Create backup
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/recipes_$DATE.tar.gz" -C "$RECIPES_DIR" .

# Keep only last 7 backups
ls -t "$BACKUP_DIR"/recipes_*.tar.gz | tail -n +8 | xargs -r rm

# Optional: Sync to cloud (requires rclone setup)
# rclone copy "$BACKUP_DIR/recipes_$DATE.tar.gz" remote:backups/
```

Add to crontab:

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /home/pi/backup-recipes.sh
```

#### Git Integration

Version control your recipes:

```bash
# Initialize git repo
cd ~/recipes
git init
git add .
git commit -m "Initial recipe collection"

# Set up remote (e.g., GitHub private repo)
git remote add origin git@github.com:yourusername/recipes.git
git push -u origin main

# Create sync script
cat > ~/sync-recipes.sh << 'EOF'
#!/bin/bash
cd /home/pi/recipes
git add .
git commit -m "Recipe update $(date +%Y-%m-%d)"
git pull --rebase
git push
EOF

chmod +x ~/sync-recipes.sh
```

## Troubleshooting: Quick Fixes

### 🔴 Problem: Cannot Connect from Other Devices

**Solution 1**: Check firewall settings
```bash
sudo ufw status
sudo ufw allow 9080/tcp
sudo systemctl restart cooklang  # If using systemd service
```

**Solution 2**: Verify correct binding
```bash
# Must use 0.0.0.0, not localhost
ps aux | grep cook
# ✓ Correct: cook server --host 0.0.0.0
# ✗ Wrong: cook server --host localhost
```

**Solution 3**: Confirm network connectivity
```bash
# On your Pi:
ip addr show  # Note the IP address
# On another device:
ping raspberrypi.local  # or use the IP
```

### 🔴 Problem: Server Stops When I Close SSH

**Solution**: Use the systemd service (see [Production Deployment](#production-deployment))

**Quick fix** without systemd:
```bash
# Option 1: Use screen
screen -S cooklang
cook server ~/recipes --host 0.0.0.0
# Press Ctrl+A, then D to detach

# Option 2: Use nohup
nohup cook server ~/recipes --host 0.0.0.0 &
```

### 🔴 Problem: Slow Loading or Timeouts

**Solution 1**: Check SD card health
```bash
sudo hdparm -t /dev/mmcblk0
# Should see >20 MB/sec for acceptable performance
```

**Solution 2**: Monitor resource usage
```bash
free -h  # Check available memory
df -h    # Check disk space
htop     # Monitor CPU and RAM (install with: sudo apt install htop)
```

**Solution 3**: Optimize for your Pi model
- Pi 3B+: Limit to 5-10 concurrent users
- Pi 4 (2GB): Comfortable with 10-15 users
- Pi 4 (4GB+): Can handle 20+ users

### 🔴 Problem: Recipe Changes Not Appearing

**Solution 1**: Clear browser cache
- Windows/Linux: `Ctrl + Shift + R`
- Mac: `Cmd + Shift + R`
- Mobile: Close and reopen browser

**Solution 2**: Check file permissions
```bash
ls -la ~/recipes  # All files should be readable
chmod 644 ~/recipes/*.cook  # Fix permissions if needed
```

**Solution 3**: Restart the server
```bash
sudo systemctl restart cooklang  # If using systemd
# Or manually stop (Ctrl+C) and restart
```

## Security Best Practices

### Network Security

- **Keep local only**: Don't expose directly to internet
- **Use VPN**: For remote access, use WireGuard or OpenVPN
- **Regular updates**:
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```
- **Strong passwords**: Change default Pi password
- **SSH keys**: Disable password authentication

### Data Protection

```bash
# Regular backups (see Backup section)
# For sensitive recipes, encrypt:
gpg --encrypt --recipient your@email.com sensitive-recipe.cook

# RAID with USB drives
sudo apt install mdadm
# Configure RAID 1 for redundancy
```

## Performance & Cost

### What to Expect
- **Page load**: <100ms on local network
- **Concurrent users**: 10-15 comfortable
- **Recipe capacity**: 10,000+ recipes
- **Power usage**: ~5W (≈$5/year electricity)
- **Uptime**: Months without restart

### Budget Options

- **Basic (~$75)**: Pi 4 (2GB) + 32GB SD + power + case
- **Enhanced (~$120)**: Pi 4 (4GB) + 64GB high-endurance SD + quality power + aluminum case + backup drive

## Tips and Best Practices

### Do's
- Use wired Ethernet for best performance
- Set up automatic backups from day one
- Use a quality, high-endurance SD card
- Monitor temperature in summer months
- Document your setup for future reference

### Don'ts
- Don't expose directly to the internet
- Don't skip the firewall configuration
- Don't use default passwords
- Don't forget regular system updates
- Don't overload with other services

## Your Recipe Server Journey

### 🎯 You Did It!

If you've followed this guide, you now have:
- ✅ A working CookLang server on your Raspberry Pi
- ✅ Access from all your devices via `raspberrypi.local:9080`
- ✅ Complete control over your recipe data
- ✅ Zero monthly fees or subscriptions

### 🚀 What's Next?

**Learn more**:
- [CookLang recipe syntax](/docs/spec/) - Write beautiful, functional recipes
- [Advanced CLI features](/cli/) - Discover powerful commands
- [Shopping lists & meal planning](/docs/use-cases/shopping/) - Automate your kitchen workflow

**Get involved**:
- [Community forum](https://github.com/cooklang/spec/discussions) - Share tips and get help
- [Recipe collection](https://github.com/cooklang/awesome-cooklang-recipes) - Browse and contribute recipes
- [Feature requests](https://github.com/cooklang/cookcli/issues) - Shape the future of CookLang

### 💡 One Final Tip

Add a bookmark to your recipe server on all your devices. On mobile, add it to your home screen for app-like access. Your digital cookbook is now just one tap away, forever.

**Welcome to your self-hosted recipe future!** 🍳
