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

> not working at the moment, re: https://github.com/cooklang/cookcli/issues/155#issuecomment-3239646168

If you have Rust installed:

```bash
cargo install cookcli
```

### Build from Source

You'll need Rust and Node.js installed. Then:

```bash
# Clone the repository
git clone https://github.com/cooklang/CookCLI.git
cd CookCLI

# Install frontend dependencies
npm install

# Build CSS (required for web UI)
npm run build-css

# Build the CLI with web UI
cargo build --release

# Binary will be at target/release/cook
```

#### Building without Self-Update

By default, CookCLI includes a self-update feature. To build without this feature (useful for CI/CD pipelines, package managers, or environments where auto-update is not desired):

```bash
# Build without self-update feature
cargo build --release --no-default-features

# This disables the 'self-update' feature flag while keeping all other functionality
```

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

