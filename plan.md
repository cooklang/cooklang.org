# Raspberry Pi Self-Hosting Use Case - Documentation Plan

## Document Metadata
- **Title**: "Raspberry Pi Kitchen Server"
- **Weight**: 65
- **Description**: "Turn a Raspberry Pi into your dedicated recipe server for 24/7 kitchen access"
- **Location**: `/content/docs/use-cases/raspberry-pi.md`

## Content Structure

### 1. Introduction Hook
**Theme**: "The Always-On Kitchen Assistant"
- Position Raspberry Pi as the perfect dedicated recipe server
- Emphasize low cost ($35-75), low power (5W), silent operation
- Target audience: Home cooks, tech-savvy families, small restaurants
- Key benefit: Set-and-forget recipe server that runs 24/7

### 2. Why Raspberry Pi for Recipe Hosting?

#### The Perfect Kitchen Computer
- **Cost-effective**: Under $100 complete setup vs hundreds for dedicated server
- **Energy-efficient**: Uses less power than a LED bulb (5W)
- **Silent operation**: No fans, perfect for kitchen environment
- **Small footprint**: Fits anywhere - behind TV, under cabinet, in pantry
- **Always-on**: Designed for 24/7 operation without maintenance

#### Real Kitchen Scenarios
- Morning coffee routine: Check recipes from phone while half-awake
- Dinner prep: Multiple family members accessing different recipes
- Holiday cooking: Reliable access during internet outages
- Recipe development: Test and refine recipes with live preview

### 3. Getting Started Section

#### Quick Setup (30 minutes)
```bash
# 1. Flash Raspberry Pi OS Lite (headless setup)
# 2. Enable SSH, connect to WiFi
# 3. Install CookCLI
wget -O cook https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-linux
chmod +x cook
sudo mv cook /usr/local/bin/

# 4. Start server
cook server ~/recipes --host 0.0.0.0
```

#### What You'll Need
- Raspberry Pi 3B+ or newer (4GB RAM recommended)
- MicroSD card (16GB+)
- Power supply
- Network connection (WiFi or Ethernet)
- Optional: Case with passive cooling

### 4. Installation Deep Dive

#### A. Preparing Your Raspberry Pi
- Raspberry Pi OS Lite vs Desktop (recommend Lite for headless)
- Initial setup with `raspi-config`
- Security basics: Change default password, setup firewall
- Network configuration for static IP

#### B. Installing CookCLI
- Binary installation for ARM64
- Building from source (if needed)
- Setting up recipe directory structure
- Initial configuration files

#### C. Optimizing for Raspberry Pi
- SD card optimization (reduce writes)
- Memory usage tuning
- Swap file configuration
- Log rotation setup

### 5. Production Deployment

#### A. Systemd Service Setup
```systemd
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

[Install]
WantedBy=multi-user.target
```

#### B. Automatic Startup
- Enable service on boot
- Health checks and monitoring
- Automatic restart on failure
- Log management

#### C. Network Access
- Setting static IP address
- Router configuration for consistent access
- Optional: Local DNS setup (recipes.local)
- Mobile bookmarks and home screen apps

### 6. Advanced Configurations

#### A. Performance Tuning
- nginx reverse proxy for caching
- Preloading common recipes
- Image optimization for faster loading
- Database alternatives for large collections

#### B. Multi-User Household
- Separate recipe collections per family member
- Shared family cookbook
- Access control considerations
- Meal planning coordination

#### C. Backup & Sync
- Automated backups to NAS/cloud
- Git integration for version control
- Syncing with main computer
- Recipe sharing between households

### 7. Real-World Scenarios

#### Scenario 1: The Family Kitchen Hub
- Central Pi in kitchen running 24/7
- Tablets and phones accessing recipes
- Shopping list on phone synced with pantry
- Kids learning to cook with easy access

#### Scenario 2: Small Restaurant/Café
- Standardized recipes for consistency
- Multiple stations accessing simultaneously
- Recipe scaling for different batch sizes
- Inventory tracking with pantry feature

#### Scenario 3: Recipe Developer's Lab
- Live preview while writing recipes
- Multiple test devices for responsive design
- Version control integration
- Quick sharing for feedback

### 8. Integration Ideas

#### A. Smart Home Integration
- Voice assistant queries ("Show me dinner recipes")
- Display recipes on smart displays
- Integration with meal planning apps
- Kitchen timer automation

#### B. Extended Features
- Mounting network drives for recipes
- Webhook notifications for meal planning
- API access for custom apps
- Recipe of the day automation

### 9. Troubleshooting Guide

#### Common Issues
- "Cannot connect from other devices"
  - Firewall settings
  - Network isolation
  - Correct IP binding

- "Server stops after SSH logout"
  - Use systemd service
  - Or use screen/tmux
  - Or nohup command

- "Slow performance"
  - SD card speed
  - Insufficient RAM
  - Too many concurrent users

- "Recipe changes not showing"
  - Browser cache
  - Server restart needed
  - File permissions

### 10. Security Best Practices

#### Network Security
- Keep on local network only
- Use VPN for remote access
- Regular security updates
- Strong passwords

#### Data Protection
- Regular backups
- RAID options with USB drives
- Encryption for sensitive recipes
- Access logging

### 11. Cost Breakdown

#### Basic Setup (~$75)
- Raspberry Pi 4 (2GB): $45
- MicroSD Card (32GB): $10
- Power Supply: $10
- Case: $10

#### Enhanced Setup (~$120)
- Raspberry Pi 4 (4GB): $55
- High-endurance SD (64GB): $20
- Quality power supply: $15
- Aluminum case with cooling: $20
- Backup USB drive: $10

### 12. Performance Expectations

- **Startup time**: 30-45 seconds from power on
- **Page load**: <100ms on local network
- **Concurrent users**: 10-15 comfortable
- **Recipe capacity**: 10,000+ recipes
- **Power usage**: ~5W (≈$5/year electricity)

### 13. Tips and Best Practices

#### Do's
- Use wired ethernet for best performance
- Set up automatic backups
- Use a quality SD card
- Monitor temperature in summer
- Document your setup

#### Don'ts
- Don't expose directly to internet
- Don't skip the firewall setup
- Don't use default passwords
- Don't forget regular updates
- Don't overload with other services

### 14. Conclusion

#### The Kitchen Investment That Pays Off
- One-time setup, years of service
- Cost savings vs cloud services
- Complete privacy and control
- Perfect kitchen companion

#### Next Steps
- Link to Getting Started guide
- Link to Raspberry Pi installation script
- Community forum for Pi users
- Recipe collection starter packs

## Style Notes

- Use the same friendly, practical tone as existing use cases
- Include plenty of real-world examples
- Balance technical detail with accessibility
- Use code blocks for all commands
- Include visuals/diagrams where helpful

## Cross-References

- Link to main self-hosting documentation
- Reference Docker alternative for advanced users
- Connect to backup and sync documentation
- Point to security best practices guide

## SEO Considerations

- Keywords: raspberry pi recipe server, cooklang raspberry pi, self-hosted cookbook, kitchen server, recipe hosting
- Meta description: "Transform a $35 Raspberry Pi into your dedicated recipe server. Step-by-step guide for 24/7 kitchen access to your cookbook."

## Images Needed

1. Raspberry Pi in kitchen setting
2. Network diagram showing devices connecting
3. Screenshot of recipe on tablet/phone
4. Setup process flow diagram
5. Performance comparison chart

## Code Examples Repository

Create accompanying repository with:
- Ready-to-use installation script
- Systemd service files
- nginx configuration
- Backup scripts
- Monitoring setup