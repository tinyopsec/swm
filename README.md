<div align="center">

# swm

**Simple X11 Window Manager - suckless, auditable, fast.**

<img src="https://raw.githubusercontent.com/tinyopsec/assets/main/swm/swm.png" width="720" alt="swm - minimal tiling X11 window manager, POSIX C99, under 1000 lines">

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C99](https://img.shields.io/badge/C-C99%20%2F%20POSIX-lightgrey.svg)]()
[![LOC](https://img.shields.io/badge/source-under%201000%20lines-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.1-informational.svg)]()
[![Issues](https://img.shields.io/github/issues/tinyopsec/swm.svg)](https://github.com/tinyopsec/swm/issues)
[![Stars](https://img.shields.io/github/stars/tinyopsec/swm.svg)](https://github.com/tinyopsec/swm/stargazers)

</div>

---

`swm` is a minimal X11 window manager written in POSIX C99. Under 1000 lines across two files. No config files, no status bar, no runtime dependencies beyond Xlib. Tiling, floating, and monocle layouts. Tag-based workspaces. Compile-time configuration via `swm.h`. A clean dwm alternative for users who want full control without the patch surface.

---

## Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Key Bindings](#key-bindings)
- [Configuration](#configuration)
- [Development Philosophy](#development-philosophy)
- [Contributing](#contributing)
- [Star History](#star-history)
- [Related Links](#related-links)
- [License](#license)

---

## Overview

`swm` follows the suckless philosophy: small, auditable, and configured at compile time. The full source fits in `swm.c` and `swm.h`. No external build system, no scripting language, no plugin API.

**Key properties:**

- Two source files, under 1000 lines of C99
- Pure Xlib - no xcb, no Cairo, no Pango
- Configured entirely in `swm.h` before compilation
- Partial EWMH and full ICCCM compliance
- OpenBSD `pledge(2)` support; portable to FreeBSD

---

## Features

| Category      | Details                                                                                            |
|---------------|----------------------------------------------------------------------------------------------------|
| Layouts       | Tiling (master/stack), floating, monocle                                                           |
| Workspaces    | 9 tag-based workspaces using bitmasks; multi-tag assignment                                        |
| Mouse         | Move, resize, toggle float via modifier + button                                                   |
| Gaps          | Configurable `gappx` on all sides, built in                                                        |
| Borders       | Inactive, focused, and urgent colors - all compile-time                                            |
| Tab switching | `Mod+Tab` toggles between last two tag views via two-slot XOR system                               |
| Fullscreen    | Toggle via keybind or `_NET_WM_STATE_FULLSCREEN`                                                   |
| Urgent hints  | `XUrgencyHint` and `_NET_ACTIVE_WINDOW` handled                                                    |
| Auto-float    | `_NET_WM_WINDOW_TYPE_DIALOG` windows float automatically                                           |
| EWMH          | `_NET_WM_STATE`, `_NET_ACTIVE_WINDOW`, `_NET_CLIENT_LIST`, `_NET_SUPPORTING_WM_CHECK`             |
| ICCCM         | `WM_DELETE_WINDOW`, `WM_TAKE_FOCUS`, `WM_NORMAL_HINTS`, `WM_HINTS`                                |
| BSD           | OpenBSD `pledge(2)`; compiles on FreeBSD                                                           |
| Build         | `gcc -std=c99 -pedantic -Wall -Wextra`, zero warnings                                             |

---

## Screenshots

<img src="https://raw.githubusercontent.com/tinyopsec/distrohop/main/assets/alpine.webp"
     width="520"
     alt="Alpine Linux screenshot">

<br/>

<img src="https://raw.githubusercontent.com/tinyopsec/assets/main/swm/screenshot.png"
     width="520"
     alt="swm - tiling layout with master/stack arrangement">

---

## Requirements

| Dependency | Arch Linux        | Debian / Ubuntu   |
|------------|-------------------|-------------------|
| Xlib       | `libx11`          | `libx11-dev`      |
| C compiler | `gcc` or `clang`  | `build-essential` |

No other runtime dependencies. `st` and `dmenu` are the default terminal and launcher - replace them in `swm.h` before compiling.

**Supported platforms:**

- Linux (tested on Arch, Void, Debian)
- OpenBSD (compiles; not regularly tested)
- FreeBSD (compiles; not regularly tested)

Tested on other UNIX-like systems? Open an issue or send a patch.

---

## Installation

### From source

```sh
git clone https://github.com/tinyopsec/swm
cd swm
make
sudo make install
```

Installs to `/usr/local/bin/swm`. Edit `PREFIX` in the `Makefile` to change the path.

### AUR (Arch Linux)

```sh
yay -S swm
# or
paru -S swm
```

AUR package: [aur.archlinux.org/packages/swm](https://aur.archlinux.org/packages/swm)

### Uninstall

```sh
sudo make uninstall
```

---

## Usage

### Starting swm

Add `swm` to your `~/.xinitrc`:

```sh
exec swm
```

Start X:

```sh
startx
```

For display managers, create a session entry:

```ini
# /usr/share/xsessions/swm.desktop
[Desktop Entry]
Name=swm
Comment=Simple Window Manager - minimal tiling X11 WM
Exec=swm
Type=Application
```

---

### Launcher and terminal

By default, `swm` uses:

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

You can replace these at compile time in `swm.h`.

**Example: use `alacritty` and `rofi` instead:**

```c
static const char *termcmd[]  = { "alacritty", NULL };
static const char *dmenucmd[] = { "rofi", "-show", "run", NULL };
```

Recompile and reinstall:

```sh
make && sudo make install
```

After this, `Mod+Return` launches `alacritty` and `Mod+d` launches `rofi`.

---

### Autostart (recommended)

`swm` does not implement a built-in autostart mechanism by design. Use one of the following approaches.

**Via `.xinitrc`:**

```sh
# background services
picom &
feh --bg-scale ~/wallpaper.png &

exec swm
```

**Via a wrapper script:**

```sh
#!/bin/sh
picom &
feh --bg-scale ~/wallpaper.png &
exec swm
```

Then in `.xinitrc`:

```sh
exec ~/bin/start-swm
```

---

### Using custom binaries from `~/.local/bin`

If your launcher is installed in a non-standard path, make sure it is on `PATH` before `swm` starts:

```sh
export PATH="$HOME/.local/bin:$PATH"
exec swm
```

Keybindings that invoke missing commands will silently fail, so verify availability first:

```sh
which dmenu_run
```

---

### Version

```sh
swm -v
```

---

## Key Bindings

The default modifier is **Super (Win)**. To switch to Alt, set `#define MODKEY Mod1Mask` in `swm.h`.

### Window and layout

| Key                   | Action                                      |
|-----------------------|---------------------------------------------|
| `Mod + Return`        | Spawn terminal                              |
| `Mod + d`             | Spawn dmenu                                 |
| `Mod + j`             | Focus next window in stack                  |
| `Mod + k`             | Focus previous window in stack              |
| `Mod + h`             | Shrink master area by 5%                    |
| `Mod + l`             | Grow master area by 5%                      |
| `Mod + i`             | Increase master window count                |
| `Mod + o`             | Decrease master window count                |
| `Mod + Space`         | Promote focused window to master            |
| `Mod + Tab`           | Toggle between last two tag views           |
| `Mod + t`             | Tiling layout                               |
| `Mod + f`             | Floating layout                             |
| `Mod + m`             | Monocle layout                              |
| `Mod + F11`           | Toggle fullscreen                           |
| `Mod + Shift + Space` | Toggle floating for focused window          |
| `Mod + q`             | Kill focused window                         |
| `Mod + Shift + e`     | Quit swm                                    |

### Tags (workspaces)

| Key                       | Action                                  |
|---------------------------|-----------------------------------------|
| `Mod + 1-9`               | Switch to tag            CCM).               |
| `Mod + Ctrl + 1-9`        | Toggle tag view (show alongside current)|
| `Mod + Shift + 1-9`       | Move focused window to tag              |
| `Mod + Ctrl + Shift + 1-9`| Toggle tag assignment on focused window |
| `Mod + 0`                 | View all tags at once                   |
| `Mod + Shift + 0`         | Assign focused window to all tags       |

`Mod+Tab` uses a two-slot XOR system: it always switches back to the previous tag view, symmetrically, regardless of how many times you switch.

### Mouse (modifier key held over a window)

| Button          | Action          |
|-----------------|-----------------|
| `Mod + Button1` | Move window     |
| `Mod + Button2` | Toggle floating |
| `Mod + Button3` | Resize window   |

Dragging or resizing a tiled window past the snap threshold auto-floats it.

All bindings are defined in `keys[]` and `buttons[]` in `swm.h` and are freely remappable.

---

## Configuration

`swm` has no runtime configuration files. All settings live in `swm.h` and take effect after recompilation:

```sh
$EDITOR swm.h
make && sudo make install
```

### Appearance

| Option        | Default     | Description                     |
|---------------|-------------|---------------------------------|
| `borderpx`    | `2`         | Border width in pixels          |
| `gappx`       | `6`         | Gap between windows and edges   |
| `col_nborder` | `#1e1e1e`   | Inactive border color           |
| `col_sborder` | `#7c9e7e`   | Focused border color            |
| `col_uborder` | `#c47f50`   | Urgent window border color      |

### Behavior

| Option         | Default | Description                           |
|----------------|---------|---------------------------------------|
| `mfact`        | `0.5`   | Master area ratio (0.05-0.95)         |
| `nmaster`      | `1`     | Initial number of master windows      |
| `snap`         | `16`    | Edge snap distance in pixels          |
| `attachbottom` | `0`     | Attach new windows at bottom of stack |
| `focusonopen`  | `1`     | Focus newly opened windows            |

### Modifier key

```c
#define MODKEY Mod4Mask   /* Super / Win */
```

### Terminal and launcher

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

Replace with any terminal or launcher: `"alacritty"`, `"foot"`, `"rofi"`, etc.

---

## Development Philosophy

`swm` follows the [suckless philosophy](https://suckless.org/philosophy/):

- **Auditable by design.** Under 1000 lines of C99. No hidden complexity. The entire codebase fits in one reading session.
- **Compile-time configuration.** No config file parser, no IPC socket, no scripting runtime. Edit `swm.h`, recompile.
- **Zero dependencies.** Pure Xlib. No xcb, no Cairo, no external libraries.
- **No feature creep.** Features are added by patching the source, not by enabling runtime options.

`swm` is inspired by [dwm](https://dwm.suckless.org) but departs from it in several concrete ways:

- Deterministic tiling algorithm with no pixel drift or remainder accumulation
- Built-in gap support via `gappx` without requiring a patch
- Two-slot XOR system for both layouts and tags - `Mod+Tab` is consistent

---

## Contributing

Bug reports and patches are welcome via [GitHub issues](https://github.com/tinyopsec/swm/issues) and pull requests.

Code style requirements:

- No comments in production code
- No external dependencies
- No over-abstraction or wrapper layers
- Compiles clean: `gcc -std=c99 -pedantic -Wall -Wextra`
- Total source stays under 1000 lines

Optional features behind `#ifdef` or compile-time constants are considered. Changes to the core event loop are reviewed carefully.

---

## Star History

<a href="https://www.star-history.com/?repos=tinyopsec%2Fswm&type=date&legend=top-left">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=tinyopsec/swm&type=date&theme=dark&legend=top-left" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=tinyopsec/swm&type=date&legend=top-left" />
    <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=tinyopsec/swm&type=date&legend=top-left" width="720" />
  </picture>
</a>

---

## Related Links

| Resource            | Link                                                                                                        |
|---------------------|-------------------------------------------------------------------------------------------------------------|
| dwm (inspiration)   | [dwm.suckless.org](https://dwm.suckless.org)                                                                |
| suckless.org        | [suckless.org](https://suckless.org)                                                                        |
| st terminal         | [st.suckless.org](https://st.suckless.org)                                                                  |
| dmenu               | [tools.suckless.org/dmenu](https://tools.suckless.org/dmenu/)                                               |
| EWMH specification  | [freedesktop.org](https://specifications.freedesktop.org/wm-spec/latest/)                                   |
| ICCCM specification | [x.org](https://x.org/releases/X11R7.6/doc/xorg-docs/specs/ICCCM/icccm.html)                               |
| Xlib manual         | [x.org](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html)                                  |
| AUR package         | [aur.archlinux.org](https://aur.archlinux.org/packages/swm)                                                 |

---

## License

MIT. See [LICENSE](LICENSE) for details.
