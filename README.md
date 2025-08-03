# 🧭 comp<code>ass</code>

A Safari tab switcher for terminal written in Nushell.

## Requirements

- macOS (uses AppleScript to control Safari)
- Nushell (automatically installed if using Nix)

## Installation

### With nix-darwin/home-manager

Add to your flake inputs:
```nix
inputs.compass.url = "github:jakubrpawlowski/compass";
```

Then add to your packages:
```nix
# For home-manager (user-specific)
home.packages = [ inputs.compass.packages.${pkgs.system}.default ];

# OR for nix-darwin (system-wide)
environment.systemPackages = [ inputs.compass.packages.${pkgs.system}.default ];
```

### Without Nix

```bash
# Clone the repository
git clone https://github.com/jakubrpawlowski/compass.git
cd compass

# Make it executable
chmod +x compass.nu

# Link or copy to your PATH
ln -s $(pwd)/compass.nu /usr/local/bin/ass
```

## Usage

Simply run:
```bash
ass
```

This will:
1. Fetch all open Safari tabs from the front window
2. Show them in an interactive fuzzy-search list
3. Switch to the selected tab when you press Enter

Local tabs (localhost and file://) are prefixed with "local: " for easy identification.
