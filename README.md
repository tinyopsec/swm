<div align="center">

# nwm

**Minimal tiling X11 window manager. ~1000 lines. No config files. No runtime dependencies.**

<img src="https://raw.githubusercontent.com/tinyopsec/assets/main/nwm/nwm.webp" style="width: 56%; height: auto;" alt="nwm: tiling layout with master/stack on Alpine Linux">

[![Version](https://img.shields.io/badge/version-1.3-9c7e6a?style=flat&logo=semver&logoColor=white&labelColor=2d2d2d)](https://github.com/tinyopsec/nwm/releases)
[![LOC](https://img.shields.io/badge/source-~1000%20lines-6a9c78?style=flat&logo=codefactor&logoColor=white&labelColor=2d2d2d)](nwm.c)
[![C99](https://img.shields.io/badge/C-C99%20%2F%20POSIX-8b9bb4?style=flat&logo=c&logoColor=white&labelColor=2d2d2d)](https://en.wikipedia.org/wiki/C99)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat&logo=open-source-initiative&logoColor=white&labelColor=2d2d2d&color=3a7ca5)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20OpenBSD%20%7C%20FreeBSD-5a7fa8?style=flat&logo=linux&logoColor=white&labelColor=2d2d2d)](Makefile)
[![AUR](https://img.shields.io/aur/version/nwm?style=flat&logo=archlinux&logoColor=white&labelColor=2d2d2d&color=1793d1)](https://aur.archlinux.org/packages/nwm)
[![Stars](https://img.shields.io/github/stars/tinyopsec/nwm?style=flat&logo=github&logoColor=white&labelColor=2d2d2d&color=f0a500)](https://github.com/tinyopsec/nwm/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/tinyopsec/nwm?style=flat&logo=git&logoColor=white&labelColor=2d2d2d&color=5c8a5c)](https://github.com/tinyopsec/nwm/commits/main)

</div>

---

`nwm` is a lightweight X11 tiling window manager written in strict POSIX C99. Two source files, under 1000 lines, pure Xlib - no drawing code, no font rendering, no status bar. Configure it by editing `nwm.h` and recompiling. No config files, no IPC, no runtime dependencies beyond Xlib.

It supports tiling, floating, and monocle layouts; 9 tag workspaces via bitmasks; gaps; EWMH and ICCCM compliance; and native OpenBSD `pledge(2)`. If you want a window manager you can read in a single sitting and trust completely, this is it.

---

## Contents

- [Quick Start](#quick-start)
- [Why nwm?](#why-nwm)
- [Who Is This For?](#who-is-this-for)
- [vs dwm](#vs-dwm)
- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)
- [Key Bindings](#key-bindings)
- [Configuration](#configuration)
- [How It Works](#how-it-works)
- [FAQ](#faq)
- [Contributing](#contributing)
- [Star History](#star-history)
- [Related](#related)
- [License](#license)

---

## Quick Start

```sh
git clone https://github.com/tinyopsec/nwm
cd nwm
make && sudo make install
echo "exec nwm" >> ~/.xinitrc
startx
```

> [!NOTE]
> The default terminal is `st` and the default launcher is `dmenu_run`. Change them in `nwm.h` before compiling if you use something else - see [Configuration](#configuration).

For display managers, drop a session file at `/usr/share/xsessions/nwm.desktop` - see [Usage](#usage).

---

## Why nwm?

> [!TIP]
> These are the concrete reasons to pick `nwm` over a heavier alternative.

- **Fits in one reading session.** ~1000 lines of C99 with no layers of abstraction. You can audit the entire codebase in an afternoon.
- **No pixel drift.** The tiling algorithm uses integer division throughout, so tile sizes stay accurate across redraws with no floating-point accumulation.
- **Gaps built in.** `gappx` is a first-class config option - no patching required.
- **Deterministic `Mod+Tab`.** A two-slot XOR mechanism always restores the exact tag bitmask or layout that was active before the last change, including combined multi-tag views.
- **Minimal attack surface.** No bar, no font rendering, no drawing code - just window management.
- **BSD-native.** Runs on Linux, OpenBSD (with `pledge(2)`), FreeBSD, NetBSD, and DragonFly.
- **~1 MB RAM at idle.** Roughly half the footprint of dwm.
- **Strict compliance.** Compiles clean under `gcc -std=c99 -pedantic -Wall -Wextra` with zero warnings.

---

## Who Is This For?

`nwm` is a good fit if you:

- Want a tiling WM you can read, understand, and modify without a patch stack.
- Already run a patched dwm and want a cleaner starting point with gaps and sane `Mod+Tab` behavior already included.
- Run OpenBSD or another BSD and want `pledge(2)` support out of the box.
- Prefer external panels (or none at all) and do not want bar rendering code in your WM.
- Value a minimal trusted computing base and small binary size.

It is probably not the right fit if you need a built-in status bar, per-monitor setups with complex multi-head logic, or a large ecosystem of community patches.

---

## vs dwm

`nwm` takes direct inspiration from dwm but diverges in several concrete ways:

| Area | dwm | nwm |
|---|---|---|
| Lines of code | ~2000 | ~1000 - readable in one session |
| RAM at idle | ~2-3 MB | ~1 MB |
| Tiling arithmetic | Can accumulate pixel remainder | Integer division, no drift |
| Gap support | Requires patching | Built in via `gappx` |
| `Mod+Tab` behavior | Inconsistent across patches | Deterministic XOR for both tags and layouts |
| OpenBSD `pledge(2)` | Not supported | Supported natively |
| POSIX compliance | Uses GNU extensions in places | Strict POSIX C99 throughout |
| Status bar | Built-in, requires patching to remove | None - use any external panel |
| Config complexity | ~100 lines + patch management | Single flat `nwm.h`, no patch stack |
| Audit surface | Large - bar, fonts, drawing code | Minimal - window management only |

dwm's bar and font rendering alone account for a significant portion of its codebase. `nwm` drops all of that. No drawing, no text, no color schemes beyond three border hex values.

If you already run a patched dwm, `nwm` is roughly what you end up with after applying the gaps and pertag patches - except the behavior is defined once, not assembled from diffs.

---

## Features

| Category | Details |
|---|---|
| Layouts | Tiling (master/stack), floating, monocle |
| Workspaces | 9 tags via bitmasks; windows may carry multiple tags |
| Mouse support | Move, resize, toggle floating via modifier + button |
| Gaps | Configurable `gappx` on all sides |
| Borders | Inactive, focused, and urgent colors at compile time |
| Fullscreen | Toggle via keybind or `_NET_WM_STATE_FULLSCREEN` |
| Urgent hints | `XUrgencyHint` and `_NET_ACTIVE_WINDOW` handled |
| Auto-float | `_NET_WM_WINDOW_TYPE_DIALOG` windows float automatically |
| EWMH | `_NET_WM_STATE`, `_NET_ACTIVE_WINDOW`, `_NET_CLIENT_LIST`, `_NET_SUPPORTING_WM_CHECK` |
| ICCCM | `WM_DELETE_WINDOW`, `WM_TAKE_FOCUS`, `WM_NORMAL_HINTS`, `WM_HINTS` |
| OpenBSD | `pledge(2)` with `stdio rpath proc exec ps` - automatically applied at startup |
| Compilation | Clean under `gcc -std=c99 -pedantic -Wall -Wextra` |

---

## Screenshots

<div align="center">

<table>
<tr>
<td align="center" width="50%">
<img src="https://raw.githubusercontent.com/tinyopsec/distrohop/main/assets/alpine.webp"
     width="100%"
     alt="nwm on Alpine Linux: three terminals tiled in master/stack layout">
<sub>Master/stack tiling on Alpine Linux</sub>
</td>
<td align="center" width="50%">
<img src="https://raw.githubusercontent.com/tinyopsec/distrohop/main/assets/arch.webp"
     width="100%"
     alt="nwm master/stack with browser in master and two terminals in stack">
<sub>Browser in master, two terminals in the stack on Arch Linux</sub>
</td>
</tr>
</table>

</div>

---

## Installation

### Requirements

| Dependency | Arch | Debian / Ubuntu | Void | Alpine |
|---|---|---|---|---|
| Xlib | `libx11` | `libx11-dev` | `libX11-devel` | `libx11-dev` |
| C compiler | `gcc` or `clang` | `build-essential` | `gcc` | `build-base` |

No runtime dependencies beyond Xlib.

### From Source

```sh
git clone --depth 1 https://github.com/tinyopsec/nwm
cd nwm
make
sudo make install   # installs to /usr/local/bin/nwm
```

Change `PREFIX` in the `Makefile` to install elsewhere.

### AUR (Arch Linux)

```sh
yay -S nwm
```

Package: [aur.archlinux.org/packages/nwm](https://aur.archlinux.org/packages/nwm)

<details>
<summary>FreeBSD / OpenBSD / NetBSD / DragonFly</summary>

Install Xlib via the system package manager, then uncomment the appropriate paths at the top of the `Makefile`:

```makefile
# OpenBSD / FreeBSD:
INCS = -I/usr/X11R6/include
LIBS = -L/usr/X11R6/lib -lX11

# NetBSD (pkgsrc):
# INCS = -I/usr/pkg/include
# LIBS = -L/usr/pkg/lib -lX11
```

Then build normally:

```sh
make && sudo make install
```

On OpenBSD, `pledge(2)` is applied automatically at startup with `stdio rpath proc exec ps`. No extra configuration needed.

</details>

### Uninstall

```sh
sudo make uninstall
```

---

## Usage

### Starting nwm

Add to `~/.xinitrc`:

```sh
picom &
feh --bg-scale ~/wallpaper.png &
exec nwm
```

`nwm` has no built-in autostart. Launch background processes from `.xinitrc` or a wrapper script before the `exec` line.

For display managers, create a session file:

```ini
# /usr/share/xsessions/nwm.desktop
[Desktop Entry]
Name=nwm
Comment=Minimal tiling X11 window manager
Exec=nwm
Type=Application
```

### Terminal and Launcher

Defaults in `nwm.h`:

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

To use `alacritty` and `rofi`:

```c
static const char *termcmd[]  = { "alacritty", NULL };
static const char *dmenucmd[] = { "rofi", "-show", "run", NULL };
```

> [!IMPORTANT]
> Recompile after any change to `nwm.h`: `make && sudo make install`

---

## Key Bindings

The default modifier is **Super (Win)**. To use Alt instead, change `#define MODKEY Mod4Mask` to `Mod1Mask` in `nwm.h`.

### Window and Layout Controls

<table>
<tr>
<th>Key</th><th>Action</th>
<th>Key</th><th>Action</th>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>Return</kbd></td><td>Spawn terminal</td>
<td><kbd>Mod</kbd> + <kbd>t</kbd></td><td>Tiling layout</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>d</kbd></td><td>Spawn launcher (dmenu)</td>
<td><kbd>Mod</kbd> + <kbd>f</kbd></td><td>Floating layout</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>j</kbd></td><td>Focus next window</td>
<td><kbd>Mod</kbd> + <kbd>m</kbd></td><td>Monocle layout</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>k</kbd></td><td>Focus previous window</td>
<td><kbd>Mod</kbd> + <kbd>F11</kbd></td><td>Toggle fullscreen</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>h</kbd></td><td>Shrink master area 5%</td>
<td><kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd></td><td>Toggle floating (focused)</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>l</kbd></td><td>Grow master area 5%</td>
<td><kbd>Mod</kbd> + <kbd>Space</kbd></td><td>Promote focused to master</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>i</kbd></td><td>Increase master count</td>
<td><kbd>Mod</kbd> + <kbd>q</kbd></td><td>Kill focused window</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>o</kbd></td><td>Decrease master count</td>
<td><kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd></td><td>Quit nwm</td>
</tr>
</table>

### Tag (Workspace) Controls

<table>
<tr>
<th>Key</th><th>Action</th>
<th>Key</th><th>Action</th>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>1-9</kbd></td><td>Switch to tag</td>
<td><kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>1-9</kbd></td><td>Move focused window to tag</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>Ctrl</kbd> + <kbd>1-9</kbd></td><td>Toggle tag view alongside current</td>
<td><kbd>Mod</kbd> + <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>1-9</kbd></td><td>Toggle tag on focused window</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>0</kbd></td><td>View all tags</td>
<td><kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd></td><td>Assign focused window to all tags</td>
</tr>
<tr>
<td><kbd>Mod</kbd> + <kbd>Tab</kbd></td><td>Return to previous tag view (XOR two-slot)</td>
<td></td><td></td>
</tr>
</table>

> [!NOTE]
> `Mod+Tab` is not a simple "previous tag" shortcut. It uses the same two-slot XOR mechanism as layout switching - it always restores the exact tag bitmask that was active before the last view change, including combined multi-tag views.

### Mouse (modifier held over a client window)

| Button | Action |
|---|---|
| `Mod` + Button1 | Move window |
| `Mod` + Button2 | Toggle floating |
| `Mod` + Button3 | Resize window |

Dragging or resizing a tiled window beyond `snap` pixels from its position automatically makes it floating. The `snap` threshold is configurable in `nwm.h`.

All bindings are defined in the `keys[]` and `buttons[]` arrays in `nwm.h`.

---

## Configuration

`nwm` is configured at compile time by editing `nwm.h`. There is no config file, no IPC, no reload mechanism.

> [!IMPORTANT]
> After every change to `nwm.h`, run `make && sudo make install` and restart nwm.

### Core Options

| Option | Default | Description |
|---|---|---|
| `borderpx` | `2` | Border width in pixels |
| `gappx` | `6` | Gap size between windows and screen edges |
| `mfact` | `0.5` | Master area ratio (0.05 to 0.95) |
| `nmaster` | `1` | Initial number of master windows |
| `snap` | `16` | Edge snap / float-on-drag threshold in pixels |
| `attachbottom` | `0` | Set to `1` to append new windows at the bottom of the stack |
| `focusonopen` | `1` | Set to `0` to keep focus on the current window when a new one opens |

### Modifier Key

```c
#define MODKEY Mod4Mask   /* Super / Win key */
// #define MODKEY Mod1Mask   /* Alt key */
```

### Border Colors

```c
static const char colnb[] = "#1e1e1e";  /* inactive */
static const char colsb[] = "#7c9e7e";  /* focused  */
static const char colub[] = "#c47f50";  /* urgent   */
```

### Terminal and Launcher

```c
static const char *termcmd[]  = { "st", NULL };
static const char *dmenucmd[] = { "dmenu_run", NULL };
```

---

## How It Works

`nwm` manages windows through a flat client list and a parallel focus stack. The tiling algorithm divides the screen into a master area and a stack area, computing tile sizes with integer arithmetic - no floating-point accumulation and no pixel drift across redraws.

Tags are bitmasks. Each client carries a tag bitmask; the active view is also a bitmask. A client is visible when the bitwise AND of its tags and the current view is nonzero. This means one window can appear on multiple tags simultaneously, with no duplication of the actual process.

Layout and tag history both use a two-slot XOR system. `nwm` keeps the current and previous values in a two-element array and flips an index bit on each change. `Mod+Tab` flips the index back - always returning to whatever was active before, whether that was a layout or a tag view.

Dialog windows (those carrying `_NET_WM_WINDOW_TYPE_DIALOG`) are automatically made floating when they are mapped, so they do not get tiled alongside regular clients.

On OpenBSD, after initial setup `nwm` calls `pledge("stdio rpath proc exec ps", NULL)` to restrict itself to the minimum set of system call categories it actually needs for the rest of its lifetime.

---

## FAQ

<details>
<summary><strong>How do I use a different terminal or launcher?</strong></summary>

Edit `nwm.h` and change the `termcmd` and `dmenucmd` arrays. For example, to switch to `kitty` and `rofi`:

```c
static const char *termcmd[]  = { "kitty", NULL };
static const char *dmenucmd[] = { "rofi", "-show", "run", NULL };
```

Then recompile and reinstall:

```sh
make && sudo make install
```

</details>

<details>
<summary><strong>Can I use a status bar with nwm?</strong></summary>

Yes. `nwm` has no built-in bar and makes no assumptions about one. You can run any EWMH-aware panel alongside it - `polybar`, `lemonbar`, `waybar` (X11 mode), `xmobar`, or none at all. Launch it from your `.xinitrc` before the `exec nwm` line. `nwm` will respect the space reserved by panels that set `_NET_WM_STRUT` or `_NET_WM_STRUT_PARTIAL`.

</details>

<details>
<summary><strong>Do I need a compositor?</strong></summary>

No. `nwm` works fine without one. If you want transparency, shadows, or vsync, launch a compositor such as `picom` from `.xinitrc` before `exec nwm`. There is nothing in `nwm` that conflicts with or requires a compositor.

</details>

---

## Contributing

Bug reports and patches are welcome via [GitHub Issues](https://github.com/tinyopsec/nwm/issues) and pull requests.

<details>
<summary>Code requirements</summary>

- No comments in production code
- No external dependencies
- No over-abstraction or wrapper layers
- Compiles clean: `gcc -std=c99 -pedantic -Wall -Wextra`
- Total source stays under 1000 lines

Optional features behind `#ifdef` or compile-time constants are considered. Core event loop changes are reviewed carefully.

</details>

---

## Star History

<a href="https://www.star-history.com/?repos=tinyopsec%2Fnwm&type=date&legend=top-left">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=tinyopsec/nwm&type=date&theme=dark&legend=top-left" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=tinyopsec/nwm&type=date&legend=top-left" />
    <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=tinyopsec/nwm&type=date&legend=top-left" width="720" />
  </picture>
</a>

---

## Related

**Suckless ecosystem**

| Project | Link |
|---|---|
| dwm | [dwm.suckless.org](https://dwm.suckless.org) |
| st terminal | [st.suckless.org](https://st.suckless.org) |
| dmenu | [tools.suckless.org/dmenu](https://tools.suckless.org/dmenu/) |
| suckless.org | [suckless.org](https://suckless.org) |

**Specifications**

| Spec | Link |
|---|---|
| EWMH | [freedesktop.org](https://specifications.freedesktop.org/wm-spec/latest/) |
| ICCCM | [x.org](https://x.org/releases/X11R7.6/doc/xorg-docs/specs/ICCCM/icccm.html) |
| Xlib manual | [x.org](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html) |

**Packages**

| Distro | Link |
|---|---|
| AUR (Arch) | [aur.archlinux.org/packages/nwm](https://aur.archlinux.org/packages/nwm) |

---

## License

MIT. See [LICENSE](LICENSE) for details.
