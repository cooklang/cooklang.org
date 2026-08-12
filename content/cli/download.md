---
title: 'Download CookCLI'
date: 2021-05-20T19:30:08+10:00
draft: false
weight: 5
summary: Links and instructions to download CookCLI.
---


### Download Binary

Download the latest release for your platform from the [releases page](https://github.com/cooklang/CookCLI/releases) and add it to your PATH.

### macOS/Linux

Using Homebrew:

```bash
brew install cookcli
```

### Install with Cargo

If you have Rust installed:

```bash
cargo install cookcli --locked
```

`--locked` builds against the dependency versions we tested and released with, rather than re-resolving to the newest compatible ones.

Note that this compiles CookCLI and all its dependencies from source, which needs a few GB of RAM and disk. If you are on a Raspberry Pi, an Armbian board, or anything else memory-constrained, prefer the [prebuilt binaries](https://github.com/cooklang/CookCLI/releases) — we publish `aarch64` and `armv7` Linux builds.

<details>
<summary>Building on a low-memory single-board computer</summary>

`cargo install` places its build directory under `$TMPDIR`. On Armbian, `/tmp` is mounted on zram — a RAM-backed device sized to half your RAM — so a multi-gigabyte build will exhaust memory and fail, sometimes with a confusing `failed to load bitcode of module ...` error.

Point the build somewhere on real storage:

```bash
CARGO_TARGET_DIR=~/.cache/cookcli-build cargo install cookcli --locked
```

If memory is still tight, disable link-time optimisation for the build:

```bash
CARGO_PROFILE_RELEASE_LTO=false \
CARGO_TARGET_DIR=~/.cache/cookcli-build \
  cargo install cookcli --locked
```

</details>

### Build from Source

You'll need Rust and Node.js installed. Then:

```bash
# Clone the repository
git clone https://github.com/cooklang/CookCLI.git
cd CookCLI

# Install frontend dependencies
npm install

# Build CSS and JS (required for web UI; the build fails without them)
npm run build-css
npm run build-js

# Build the CLI with web UI
cargo build --release

# Binary will be at target/release/cook
```

#### Cargo features

The optional commands are behind Cargo features, all enabled by default. Turning them off cuts the dependency graph roughly in half (412 crates → 225) and the binary from ~23 MB to ~9 MB — useful for CI/CD, package managers, or small machines where you only want the core recipe tooling.

| Feature | Command | Notes |
|---|---|---|
| `server` | `cook server` | Web UI (axum + tower). `cook build` still works without it. |
| `import` | `cook import` | Scrape a recipe from a website. |
| `lsp` | `cook lsp` | Language server for editor integrations. |
| `sync` | `cook login` / `cook logout` | Recipe sync. Implies `server` — the sync loop runs inside it. |
| `self-update` | `cook update` | In-place binary upgrade. |

```bash
# Core CLI only: recipe, shopping-list, search, doctor, pantry, report, build, seed
cargo build --release --no-default-features

# Core plus the web server
cargo build --release --no-default-features --features server
```

Everything not listed above — parsing, scaling, shopping lists, search, pantry, reports and the static site builder — is always compiled in.

### Development Setup

For development with hot-reload of CSS changes:

```bash
# Install dependencies
npm install

# In one terminal, watch CSS changes
npm run watch-css

# In another terminal, run the development server
cargo run -- server ./seed

# Or use the Makefile
make dev_server  # Builds CSS and starts server
```

