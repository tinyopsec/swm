<div align="center">

# swm

**Simple X11 Window Manager – suckless, auditable, fast.**

<img src="https://raw.githubusercontent.com/tinyopsec/assets/main/swm/swm.png" width="720" alt="swm - minimal tiling X11 window manager, POSIX C99, under 1000 lines">

[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat&logo=open-source-initiative&logoColor=white&labelColor=2d2d2d&color=3a7ca5)](LICENSE)
[![C99](https://img.shields.io/badge/C-C99%20%2F%20POSIX-8b9bb4?style=flat&logo=c&logoColor=white&labelColor=2d2d2d)](https://en.wikipedia.org/wiki/C99)
[![LOC](https://img.shields.io/badge/source-under%201000%20lines-6a9c78?style=flat&logo=codefactor&logoColor=white&labelColor=2d2d2d)](swm.c)
[![Version](https://img.shields.io/badge/version-1.1-9c7e6a?style=flat&logo=semver&logoColor=white&labelColor=2d2d2d)](https://github.com/tinyopsec/swm/releases)

</div>

---

`swm` is a minimal X11 window manager written in POSIX C99. The full source fits in two files, under 1000 lines. No config files, no status bar, no runtime dependencies beyond Xlib.

**Quick start:**

```sh
git clone https://github.com/tinyopsec/swm
cd swm
make && sudo make install
```

---

## Features

| Category          | Details                                                                                      |
|-------------------|----------------------------------------------------------------------------------------------|
| Layouts           | Tiling (master/stack), floating, monocle                                                     |
| Workspaces        | 9 tags using bitmasks; windows may carry multiple tags                                       |
| Mouse support     | Move, resize, toggle floating via modifier + button                                          |
| Gaps              | Configurable `gappx` on all sides, built in                                                  |
| Borders           | Inactive, focused, and urgent colors defined at compile time                                 |
| Tag switching     | `Mod+Tab` toggles between last two tag views via two-slot XOR system                         |
| Fullscreen        | Toggle via keybind or `_NET_WM_STATE_FULLSCREEN`                                             |
| Urgent hints      | `XUrgencyHint` and `_NET_ACTIVE_WINDOW` handled                                              |
| Auto‑float        | `_NET_WM_WINDOW_TYPE_DIALOG` windows float automatically                                     |
| EWMH support      | `_NET_WM_STATE`, `_NET_ACTIVE_WINDOW`, `_NET_CLIENT_LIST`, `_NET_SUPPORTING_WM_CHECK`        |
| ICCCM compliance  | `WM_DELETE_WINDOW`, `WM_TAKE_FOCUS`, `WM_NORMAL_HINTS`, `WM_HINTS`                           |
| OpenBSD pledge    | Supports `pledge(2)`; builds on FreeBSD as well                                              |
| Compilation       | Clean under `gcc -std=c99 -pedantic -Wall -Wextra`                                           |

---

## Screenshots

<img src="https://raw.githubusercontent.com/tinyopsec/distrohop/main/assets/alpine.webp"
     width="49%"
     alt="Alpine Linux screenshot">

<img src="https://raw.githubusercontent.com/tinyopsec/assets/main/swm/screenshot.png"
     width="49%"
     alt="swm - tiling layout with master/stack arrangement">

---

## Installation

### Requirements

| Dependency | Arch Linux         | Debian / Ubuntu   |
|------------|--------------------|-------------------|
| Xlib       | `libx11`           | `libx11-dev`      |
| C compiler | `gcc` or `clang`   | `build-essential` |

No further runtime dependencies. The default terminal is `st` and launcher is `dmenu` – replace them in `swm.h` before compilation if desired.

### From source

```sh
git clone https://github.com/tinyopsec/swm
cd swm
make
sudo make install   # installs to /usr/local/bin/swm
```

Edit `PREFIX` in the `Makefile` to change the installation path.

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

For display managers, create a session entry:

```ini
# /usr/share/xsessions/swm.desktop
[Desktop Entry]
Name=swm
Comment=Simple Window Manager – minimal tiling X11 WM
Exec=swm
Type=Application
```

### Terminal and launcher

The defaults are defined in `swm.h`:

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

To use `alacritty` and `rofi`, change them to:

```c
static const char *termcmd[]  = { "alacritty", NULL };
static const char *dmenucmd[] = { "rofi", "-show", "run", NULL };
```

Recompile and reinstall.

### Autostart (recommended)

`swm` does not provide an autostart mechanism. Start background services from `.xinitrc` or a wrapper script:

```sh
picom &
feh --bg-scale ~/wallpaper.png &
exec swm
```

---

## Default Key Bindings

The default modifier is **Super (Win)**. Change `#define MODKEY Mod4Mask` in `swm.h` to use `Mod1Mask` (Alt).

### Window and layout

| Key                     | Action                                      |
|-------------------------|---------------------------------------------|
| `Mod + Return`          | Spawn terminal                              |
| `Mod + d`               | Spawn dmenu                                 |
| `Mod + j`               | Focus next window in stack                  |
| `Mod + k`               | Focus previous window in stack              |
| `Mod + h`               | Shrink master area by 5%                    |
| `Mod + l`               | Grow master area by 5%                      |
| `Mod + i`               | Increase master window count                |
| `Mod + o`               | Decrease master window count                |
| `Mod + Space`           | Promote focused window to master            |
| `Mod + Tab`             | Toggle between last two tag views           |
| `Mod + t`               | Tiling layout                               |
| `Mod + f`               | Floating layout                             |
| `Mod + m`               | Monocle layout                              |
| `Mod + F11`             | Toggle fullscreen                           |
| `Mod + Shift + Space`   | Toggle floating for focused window          |
| `Mod + q`               | Kill focused window                         |
| `Mod + Shift + e`       | Quit swm                                    |

### Tags (workspaces)

| Key                         | Action                                      |
|-----------------------------|---------------------------------------------|
| `Mod + 1-9`                 | Switch to tag                               |
| `Mod + Ctrl + 1-9`          | Toggle tag view (show alongside current)    |
| `Mod + Shift + 1-9`         | Move focused window to tag                  |
| `Mod + Ctrl + Shift + 1-9`  | Toggle tag assignment on focused window     |
| `Mod + 0`                   | View all tags at once                       |
| `Mod + Shift + 0`           | Assign focused window to all tags           |

### Mouse (modifier key held over a window)

| Button          | Action          |
|-----------------|-----------------|
| `Mod + Button1` | Move window     |
| `Mod + Button2` | Toggle floating |
| `Mod + Button3` | Resize window   |

Dragging or resizing a tiled window past the snap threshold (`snap` pixels) will float it automatically.

All bindings are defined in the `keys[]` and `buttons[]` arrays inside `swm.h`.

---

## Configuration

`swm` is configured entirely at compile time by editing `swm.h`.

| Option          | Default     | Description                                    |
|-----------------|-------------|------------------------------------------------|
| `borderpx`      | `0`         | Border width in pixels                         |
| `gappx`         | `6`         | Gap between windows and screen edges           |
| `col_nborder`   | `#1e1e1e`   | Inactive border color                          |
| `col_sborder`   | `#7c9e7e`   | Focused border color                           |
| `col_uborder`   | `#c47f50`   | Urgent window border color                     |
| `mfact`         | `0.5`       | Master area ratio (0.05–0.95)                  |
| `nmaster`       | `1`         | Initial number of master windows               |
| `snap`          | `16`        | Edge snap distance in pixels                   |
| `attachbottom`  | `0`         | Attach new windows at bottom of stack          |
| `focusonopen`   | `1`         | Focus newly opened windows                     |

### Modifier key

```c
#define MODKEY Mod4Mask   /* Super / Win */
```

### Terminal and launcher commands

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

After changing `swm.h`, run:

```sh
make && sudo make install
```

---

## Development Philosophy

`swm` follows the suckless philosophy:

- **Auditable by design.** Under 1000 lines of C99. The entire codebase can be read and understood in a single sitting.
- **Compile-time configuration.** No config file parser, no IPC socket, no scripting runtime. Edit `swm.h` and recompile.
- **Zero external dependencies.** Pure Xlib. No xcb, Cairo, Pango, or extra libraries.

`swm` differs from `dwm` in a few concrete ways:

- Deterministic tiling algorithm with no pixel drift or remainder accumulation
- Built-in gap support via `gappx` without patching
- Two-slot XOR system for both layouts and tags – `Mod+Tab` behaves consistently

---

## Contributing

Bug reports and patches are welcome via [GitHub issues](https://github.com/tinyopsec/swm/issues) and pull requests.

Code style requirements:

- No comments in production code
- No external dependencies
- No over‑abstraction or wrapper layers
- Compiles clean: `gcc -std=c99 -pedantic -Wall -Wextra`
- Total source stays under 1000 lines

Optional features behind `#ifdef` or compile‑time constants are considered. Core event loop changes are reviewed carefully.

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
