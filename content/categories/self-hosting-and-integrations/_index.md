---
title: "Self-Hosting Cooklang and Integrations with Other Tools"
slug: "self-hosting-and-integrations"
description: "Docker, Home Assistant, Raspberry Pi, mobile and desktop apps, sync agents, parser APIs — running Cooklang in your own infrastructure."
date: 2026-05-27
---

Because Cooklang is files plus a CLI, self-hosting it is mostly trivial: a folder, a git repo, and any web server is already a deployment. The interesting work is in the integrations — connecting Cooklang to the rest of your kitchen-tech stack: a Home Assistant dashboard, a Raspberry Pi mounted on the fridge, a mobile app that syncs your recipes between devices, or a programmatic API in another application.

For the simple setup, [Self-Hosting Recipes with Docker](/blog/21-self-hosting-recipes-with-docker/) walks through a containerised CookCLI server. For something more ambitious, [Raspberry Pi Kitchen Display](/blog/17-raspberry-pi-kitchen-display/) covers wall-mounted recipe screens, and [Cooklang Home Assistant Smart Kitchen](/blog/32-cooklang-home-assistant-smart-kitchen/) integrates recipes into an existing home-automation setup.

On the application side, [Cooklang Mobile App](/blog/34-cooklang-mobile-app/) covers the official iOS/Android client, while [Desktop App Replaced by Sync Agent](/blog/36-desktop-app-replaced-by-sync-agent/) explains why we moved away from a desktop app and what the sync agent does instead. The [File Sync Library](/blog/06-developing-file-sync-library/) post is the technical story behind that move.

For developers, [Building a Recipe API with Cooklang](/blog/29-building-recipe-api-with-cooklang/) walks through embedding Cooklang in your own backend, and [A Plain Text Recipe Database](/blog/38-plain-text-recipe-database/) explains how the filesystem itself acts as the database layer — no Postgres required.

A common pattern across all of these: the integration is usually a thin shim. CookCLI does the parsing and the data shaping; the integration is just a script or a small service that hands files in and gets structured output back. If you find yourself building anything elaborate to hold Cooklang together, it's usually a sign there's a simpler path.
