# 🧠 realSUDO/nvim

<p align="center">
  <b>Hyper-minimal. Blazing Fast. Battle-ready Neovim config.</b><br>
  ⚙️ Built for speed • 🧩 Modular by design • ⌨️ Terminal-native focus
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Neovim-%E2%9C%94-green?style=flat-square&logo=neovim&logoColor=white" />
  <img src="https://img.shields.io/badge/Status-Active-blue?style=flat-square&logo=github" />
  <img src="https://img.shields.io/badge/Linux-Hyprland%20%7C%20Arch-black?style=flat-square&logo=arch-linux" />
</p>

---

## 🚀 Installation

### Section 1: Auto Installation (Recommended)

Run this one-liner to install with all dependencies:

```bash
curl -sL https://raw.githubusercontent.com/realSUDO/neovimconfig/main/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/realSUDO/neovimconfig && cd neovimconfig && chmod +x install.sh && ./install.sh
```

The installer will:

- Install all required dependencies
- Set up Python virtual environment
- Configure clipboard support
- Back up existing config (if any)
- Install all plugins automatically

---

### Section 2: Manual Installation

#### 🧱 Dependencies

**Core Requirements:**

- Neovim 0.9+
- Python 3.10+ with pip
- Node.js 16+
- npm

**Arch Linux:**

```bash
sudo pacman -S --needed neovim python-pip nodejs npm clang
```

**Ubuntu/Debian:**

```bash
sudo apt install neovim python3-pip nodejs npm clang
```

**Python Packages:**

```bash
python3 -m venv ~/.globalPython
~/.globalPython/bin/pip install pynvim black isort
```

**Clipboard Support:**

- X11: `sudo pacman -S xclip` or `sudo apt install xclip`
- Wayland: `sudo pacman -S wl-clipboard` or `sudo apt install wl-clipboard`

#### ⚙️ Configuration

```bash
git clone https://github.com/realSUDO/neovimconfig ~/.config/nvim
nvim +Lazy sync
```

---

## 🎮 Getting Started

### Core Shortcuts

**General:**

- `<leader>` = Space
- `;` = `:`
- `<C-s>` = Save
- `<C-q>` = Quit
- `<leader>q` = Close buffer

**Navigation:**

- `<C-h/j/k/l>` = Window navigation
- `<leader>e` = File explorer (Neotree)
- `<leader>f` = Find files (Telescope)
- `<leader>g` = Live grep (Telescope)
- `<leader>b` = Buffer list

**LSP:**

- `gd` = Go to definition
- `gr` = Go to references
- `K` = Hover info
- `<leader>d` = Open diagnostics
- `<leader>rn` = Rename symbol

**Git:**

- `<leader>gs` = Git status (Neogit)
- `<leader>gb` = Git blame
- `<leader>gd` = Git diff

**UI:**

- `<leader>u` = Toggle theme
- `<leader>tt` = Toggle terminal

---

## ⚙️ Core Features

- 🚀 Fast lazy-loaded startup via Lazy.nvim
- 🎯 Minimal UI with floating borders & clean highlights
- 🔧 LSP, Mason, Autocompletion (nvim-cmp)
- 🔍 Telescope for fuzzy file/symbol navigation
- 🌌 TokyoNight theme for a modern look
- 📜 Treesitter for advanced syntax highlighting
- 🗂️ Neotree for file browsing
- 📊 Statusline with Lualine
- 🧠 LSP Diagnostics, DAP-ready
- 🏠 Beautiful start screen with ASCII art & sessions

---

## 🧩 Tech Stack

| Tool / Plugin   | Purpose                        |
|-----------------|--------------------------------|
| Neovim (0.9+)   | Core Editor                    |
| Lua             | Configuration Language         |
| Lazy.nvim       | Plugin Manager                 |
| Mason.nvim      | LSP/DAP Installer              |
| Telescope       | Fuzzy Finder                   |
| Treesitter      | Syntax Highlighting            |
| nvim-cmp        | Autocompletion                 |
| Lualine         | Status Line                    |
| TokyoNight      | Theme                          |
| alpha-nvim      | Custom Dashboard / Zeroscreen  |

---

## 📉 Limitations

- ❌ Not beginner-friendly (requires Neovim knowledge)
- ⛔ Terminal-only (no GUI support)
- 🌱 Manual plugin tweaking for unsupported languages

---

## 🪪 License

MIT © realSUDO

<p align="center"><i>“There is elegance in speed. There is beauty in silence.”</i></p>
