---
title: "The Desktop App Is Gone. Here's What Replaced It."
date: 2026-03-11
weight: 48
summary: "We replaced the Cooklang desktop app with a lightweight sync agent — a tiny background service that does the same job faster, with less overhead."
---

The Cooklang desktop app is no more. We've replaced it with something better: a lightweight sync agent that does exactly one thing — keeps your recipe folder in sync between your computer and your phone.

## Why the Change

The old desktop app was built with Tauri. It worked, but it was heavier than it needed to be. It bundled a web view, had a slower startup, and required more maintenance than a background sync service should.

The thing is, nobody opens a desktop app to sync files. You install it, point it at your recipes folder, and forget about it. So why have a full app with a window?

## What the Sync Agent Does

The sync agent is a single Rust binary. It runs in the background, sits in your system tray, and syncs your local recipe files with Cook Cloud. That's it.

Here's what you get:

- **System tray icon** — shows sync status at a glance, no window to manage
- **Automatic syncing** — watches your recipes folder and syncs changes within seconds
- **Secure login** — OAuth-based authentication, tokens stored in your OS keyring (macOS Keychain, Windows Credential Manager, Linux Secret Service)
- **Auto-updates** — updates itself silently in the background
- **Cross-platform** — macOS, Windows, Linux (AppImage)
- **CLI interface** — `start`, `stop`, `status`, `login`, `config` — everything you'd expect

## Installation

Download it from [cook.md/download](https://cook.md/download). Run the installer, sign in, pick your recipes folder. The agent starts automatically on boot.

If you had the old desktop app installed, the sync agent migrates your settings automatically.

## For the Terminal-Inclined

The agent is fully controllable from the command line:

```bash
cook-sync start          # start the daemon
cook-sync stop           # stop it
cook-sync status         # check sync status
cook-sync login          # authenticate via browser
cook-sync config         # configure recipes directory, auto-start, etc.
```

## What Stays the Same

Everything about your workflow stays the same. Your recipes are still plain text files in a folder. The mobile app still reads them. Cook Cloud still handles the sync. The only difference is that the thing running on your computer is now smaller, faster, and stays out of your way.

If you're using iCloud sync on iOS, nothing changes for you at all — the sync agent is for Android users and anyone who prefers Cook Cloud over iCloud.

## The Takeaway

Software should match the job. A background sync service doesn't need a window. It needs to start fast, use minimal resources, and never crash. That's what the sync agent does.

[Download it here](https://cook.md/download).

-Alexey
