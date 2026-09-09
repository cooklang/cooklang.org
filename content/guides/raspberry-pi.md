---
title: 'Raspberry Pi Kitchen Server'
weight: 30
description: 'Run cook server on a Raspberry Pi so every phone, tablet and laptop in the house can browse recipes, build shopping lists and check the pantry, with no cloud involved.'
group: power
tools: [CookCLI, Raspberry Pi, systemd]
---

A Raspberry Pi running `cook server` turns your recipe folder into a website for your home network. Prop a tablet on the counter, open the Pi's address, and the whole family sees the same recipes, the same meal plan and the same shopping list. It draws a few watts and needs no account anywhere.

{{< server-carousel >}}

## What you need

- A Raspberry Pi 3B+ or newer. 1 GB of RAM is plenty; the server is a single small binary.
- A microSD card (8 GB or more) and a power supply.
- WiFi or Ethernet on the same network as your other devices.
- About 30 minutes.

The commands below assume Raspberry Pi OS Lite (Bookworm) and that you are logged in over SSH. Substitute your own user name for `pi` if you chose a different one in the imager.

## 1. Prepare the Pi

Flash [Raspberry Pi OS Lite](https://www.raspberrypi.com/software/) with Raspberry Pi Imager. In the imager's settings, set a hostname (this guide uses `kitchen`), a user name and password, your WiFi details, and enable SSH. Boot the Pi and connect:

```bash
ssh pi@kitchen.local
sudo apt update && sudo apt upgrade -y
```

## 2. Install CookCLI

Download the release binary for the Pi's architecture. Check which one you have first:

```bash
uname -m
```

```bash
# aarch64 (64-bit OS, the default on Pi 3B+ and newer)
curl -L https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-unknown-linux-musl.tar.gz | tar xz

# armv7l (32-bit OS)
# curl -L https://github.com/cooklang/cookcli/releases/latest/download/cook-arm-unknown-linux-musleabihf.tar.gz | tar xz

sudo install -m 755 cook /usr/local/bin/cook
cook --version
```

Later upgrades are one command: `sudo cook update`.

## 3. Add recipes and try the server

Put your recipes on the Pi. To see the server working before you copy your own collection, seed a sample one:

```bash
cook seed ~/recipes
```

Then start the server, allowing connections from other devices:

```bash
cook server ~/recipes --host
```

Open `http://kitchen.local:9080` on your phone or laptop. You should see the recipe list. Press `Ctrl+C` to stop it; the next step makes it permanent.

`--host` is what makes the server listen on the network rather than only on the Pi itself. Anyone on your network can then read and edit the recipes, so keep it on your home WiFi, not a shared or public one.

## 4. Run it as a service

A systemd unit starts the server at boot and restarts it if it crashes.

```bash
sudo tee /etc/systemd/system/cook-server.service > /dev/null <<'EOF'
[Unit]
Description=Cooklang recipe server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/recipes
ExecStart=/usr/local/bin/cook server /home/pi/recipes --host --port 9080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now cook-server.service
sudo systemctl status cook-server.service
```

`status` should say `active (running)`. To read the server's log:

```bash
journalctl -u cook-server -f
```

## 5. Make it easy to reach

**Use the hostname.** `http://kitchen.local:9080` works from macOS, iOS, Windows 10+, and most Linux desktops through mDNS. If it does not resolve on a device, use the IP address instead (`hostname -I` on the Pi shows it).

**Pin the IP address.** Either reserve the Pi's address in your router's DHCP settings (the simplest option), or set a static address on the Pi. Bookworm uses NetworkManager:

```bash
nmcli connection show                       # find the connection name, e.g. "preconfigured"
sudo nmcli connection modify "preconfigured" \
  ipv4.method manual \
  ipv4.addresses 192.168.1.50/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns 192.168.1.1
sudo nmcli connection up "preconfigured"
```

**Add it to home screens.** On the tablet in the kitchen, open the server in the browser and choose *Add to Home Screen* (Safari's share menu on iOS; Chrome's menu on Android). It opens full-screen like an app.

**Optional: drop the port number.** If you would rather type `http://kitchen.local` than `http://kitchen.local:9080`, put nginx in front:

```bash
sudo apt install -y nginx
sudo tee /etc/nginx/sites-available/cook > /dev/null <<'EOF'
server {
    listen 80 default_server;
    location / {
        proxy_pass http://127.0.0.1:9080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF
sudo ln -sf /etc/nginx/sites-available/cook /etc/nginx/sites-enabled/cook
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

The `Upgrade` headers keep the live-reload connection working. If the Pi already serves something else on port 80, run the recipes under a path instead: add `--url-prefix /recipes` to `ExecStart` and use `location /recipes/` in nginx.

## 6. Keep the recipes in sync

The Pi is a good place for the canonical copy of your collection, but you will want to edit on a laptop or phone too. Three approaches, from simplest to most flexible:

**Edit in the browser.** The server has a built-in editor and a *New recipe* button. For a household that only edits on the kitchen tablet, this is enough.

**Git.** Keep the collection in a repository and let the Pi pull on a schedule:

```bash
cd ~/recipes
git init && git add . && git commit -m "Recipes"
git remote add origin git@github.com:yourusername/recipes.git
git push -u origin main

crontab -e
# add: pull every 15 minutes
*/15 * * * * cd /home/pi/recipes && git pull --quiet --rebase
```

Edit anywhere Git works, push, and the Pi is current within 15 minutes. `cook server` picks up file changes without a restart.

**Cook Cloud.** CookCLI can sync the folder itself. Sign in once on the Pi and the running server keeps `~/recipes` in step with the mobile app and Cook Editor:

```bash
sudo -u pi cook login        # prints a code and a cook.md URL; approve it in any browser
sudo systemctl restart cook-server
```

Changes made on your phone arrive on the Pi within seconds, and edits on the Pi go the other way. Sync is part of [Cook Basic](https://cook.md/pricing).

Whichever you pick, take backups; microSD cards fail. A nightly tarball to a USB stick or another machine is enough:

```bash
crontab -e
# add: nightly backup at 02:00, keep 14 days
0 2 * * * tar czf /media/usb/recipes-$(date +\%F).tar.gz -C /home/pi recipes && find /media/usb -name 'recipes-*.tar.gz' -mtime +14 -delete
```

## 7. Optional hardening

**Firewall.** Only the SSH and server ports need to be open:

```bash
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw allow 9080/tcp      # or 80/tcp if you set up nginx
sudo ufw enable
```

**Fewer SD card writes.** The recipe folder changes rarely, so the main source of wear is logging. Moving logs to RAM is a reasonable trade-off for an always-on appliance:

```bash
echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,size=50m 0 0" | sudo tee -a /etc/fstab
sudo reboot
```

## What to expect

A Pi 4 serves recipe pages in well under a second on a local network and copes with everyone in the house browsing at once. Search, shopping lists and the pantry page all work; those are the features `cook build web` leaves out, which is why a live server is worth running at home even if you also publish a static site.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Works on the Pi (`curl localhost:9080`) but not from other devices | `--host` is missing from the command, or the firewall blocks the port (`sudo ufw status`). |
| `kitchen.local` does not resolve | Use the IP address, or check the hostname with `hostname`. Some Android devices lack mDNS; use the IP there. |
| `Exec format error` when running `cook` | Wrong architecture download. Re-check `uname -m`. |
| Server stops when you close SSH | You ran it by hand. Use the systemd service from step 4. |
| Recipes edited elsewhere do not show up | Check the sync route: `git pull` in cron, or the sync agent's status. The server itself does not need restarting. |

## See also

- [`cook server` reference](/cli/commands/server/): all options, including `--url-prefix`
- [Hosting Recipes as a Static Website](/guides/static-website/): the read-only alternative for sharing outside the house
- [Shopping Lists](/guides/shopping/) and [Pantry Management](/guides/pantry/): the features the server exposes in the browser
- [Version control recipes with Git](/blog/43-version-control-recipes-with-git/)
