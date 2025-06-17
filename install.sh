#!/usr/bin/env bash

# Author: justmultiply
# Cosmic Edition: Quirky, Roasty & Ruthless

set -eo pipefail

# Colors
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
NC=$(tput sgr0)

SPINNER=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
DIVIDER="$(printf '%*s' "$(tput cols)" '' | tr ' ' '═')"
SMALL_DIVIDER="$(printf '%*s' "$(( $(tput cols) / 2 ))" '' | tr ' ' '─')"

CHEESY=(
    "Installing faster than your ex moved on 🚩"
    "Turning your boring terminal into a space rave 💃"
    "Code so clean even your mom won't nag 🔥"
    "If Batman used Neovim, this would be it 🦇"
    "Running smoother than that guy who ghosted you 😎"
)

NO_VARIANTS=(
    "Nah, not feeling it."
    "Negative, captain."
    "Hell no 🚫"
    "Abort mission."
    "Declined like your last crush's DM 💔"
)

# Spinner animation
spinner() {
    local pid=$!
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r${SPINNER[$i]} ${1}..."
        sleep 0.1
    done
    printf "\r\033[2K"
}

cheesy_message() {
    echo "${MAGENTA}${BOLD}${CHEESY[$((RANDOM % ${#CHEESY[@]}))]}${NC}"
}

random_no() {
    echo "${YELLOW}${BOLD}${NO_VARIANTS[$((RANDOM % ${#NO_VARIANTS[@]}))]}${NC}"
}

header() {
    echo
    echo "${CYAN}${BOLD}${DIVIDER}${NC}"
    echo "${CYAN}${BOLD}$(printf "%*s" $(( (${#1} + $(tput cols)) / 2 )) "${1}")${NC}"
    echo "${CYAN}${BOLD}${DIVIDER}${NC}"
    echo
    cheesy_message
    echo
}

success() {
    echo "${GREEN}✅ $1${NC}"
}

warning() {
    echo "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo "${RED}❌ $1${NC}"
    exit 1
}

ask() {
    echo -e "\n${BOLD}${BLUE}❓ $1${NC}"
    echo -n "${CYAN}[y/N]: ${NC}"
    read -r choice
    case "$choice" in
        [Yy]* ) return 0 ;;
        * ) random_no; return 1 ;;
    esac
}

# == LAUNCH SEQUENCE ==
header "Cosmic Neovim Setup"

[ "$(id -u)" -eq 0 ] && error "Easy there, root cowboy. Run this as a user, not godmode."

command -v sudo >/dev/null || error "Sudo missing? Bro, you tryna jailbreak a toaster?"

sudo -v || error "Sudo timeout. Either type password or accept defeat."

command -v python3 >/dev/null || error "Python3 not found. Are you even on Earth?"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ ! -f "$SCRIPT_DIR/init.lua" ] && warning "init.lua missing in current dir. Sure you're not lost?"

# == INSTALLER ==
install_arch_pkg() {
    local pkg="$1"
    local reason="$2"
    if pacman -Qi "$pkg" &>/dev/null; then
        success "$pkg already chilling on your system"
    else
        warning "$pkg missing! Reason: $reason"
        if ask "Install $pkg now?"; then
            (sudo pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1) &
            spinner "Installing $pkg"
            success "$pkg installed!"
        else
            error "Mission failed. $pkg is mandatory."
        fi
    fi
}

header "Checking Dependencies"

install_arch_pkg "neovim" "Editor of the gods"
install_arch_pkg "python-pip" "Python package power"
install_arch_pkg "nodejs" "JS LSP backbone"
install_arch_pkg "npm" "JS dependency bridge"
install_arch_pkg "clang" "C/C++ LSP tools"

# == PYTHON TOOLS ==
header "Setting up Python Arsenal"

GLOBAL_PY="$HOME/.globalPython"

[ ! -d "$GLOBAL_PY" ] && (python3 -m venv "$GLOBAL_PY" >/dev/null 2>&1) &
spinner "Spinning up Python venv"
success "Python venv created at ~/.globalPython"

("$GLOBAL_PY/bin/pip" install --upgrade pip setuptools wheel >/dev/null 2>&1) &
spinner "Upgrading pip systems"

install_python_tool() {
    local tool="$1"
    local reason="$2"
    [ -f "$GLOBAL_PY/bin/$tool" ] && success "$tool already geared up!" && return
    warning "$tool missing: $reason"
    if ask "Install $tool?"; then
        ("$GLOBAL_PY/bin/pip" install "$tool" >/dev/null 2>&1) &
        spinner "Installing $tool"
        success "$tool ready for deployment"
    else
        warning "$tool skipped. Hope you know what you're doing 🫠"
    fi
}

install_python_tool "black" "Code auto-fixer"
install_python_tool "isort" "Import sorting wizard"
install_python_tool "pynvim" "Python-Neovim bridge"

# == OPTIONAL TOOLS ==
header "Installing Optional Enhancers"

install_optional_pkg() {
    local pkg="$1"
    local reason="$2"
    local install_cmd="$3"

    if command -v "$pkg" &>/dev/null; then
        success "$pkg already on board"
    else
        warning "$pkg could boost your life: $reason"
        if ask "Install $pkg?"; then
            (eval "$install_cmd" >/dev/null 2>&1) &
            spinner "Installing $pkg"
            success "$pkg installed!"
        else
            warning "$pkg left out. Like your last situationship."
        fi
    fi
}

install_optional_pkg "stylua" "Format Lua files like a boss" \
    "sudo pacman -S --noconfirm stylua || cargo install stylua"

# == CONFIG DEPLOYMENT ==
header "Deploying Neovim Config"

NVIM_CONFIG_PATH="$HOME/.config/nvim"
BACKUP_DIR="${NVIM_CONFIG_PATH}_backup_$(date +%Y%m%d_%H%M%S)"

if [ -d "$NVIM_CONFIG_PATH" ]; then
    warning "Existing config found!"
    if ask "Backup and overwrite it?"; then
        mv "$NVIM_CONFIG_PATH" "$BACKUP_DIR"
        success "Backup saved at $BACKUP_DIR"
    else
        error "Overwrite denied. Exiting with attitude."
    fi
fi

mkdir -p "$NVIM_CONFIG_PATH"
cp -r "$SCRIPT_DIR/"* "$NVIM_CONFIG_PATH/"
success "Config deployed at $NVIM_CONFIG_PATH"

# == PLUGIN SYNC ==
header "Syncing Plugin Universe"

echo -n "Plugin sync may take a moment..."
if nvim --headless "+Lazy! sync" +qa 2>/tmp/nvim_sync.log; then
    success "Plugins synced!"
else
    error "Plugin sync failed!"
    warning "Try manually: ${BOLD}nvim +Lazy sync${NC}"
    warning "Log: /tmp/nvim_sync.log"
fi

# == WRAP-UP ==
header "All Systems Go"

cat <<EOF
${GREEN}${BOLD}Neovim is now turbocharged!${NC}

🔮 Launch:     ${BOLD}nvim${NC}
🧪 Health:     ${BOLD}nvim +checkhealth${NC}
📦 Plugins:    ${BOLD}nvim +Lazy update${NC}
🐍 Python bin: ${BOLD}$HOME/.globalPython/bin${NC}
🔧 Add to PATH:
  ${BOLD}export PATH="\$HOME/.globalPython/bin:\$PATH"${NC}

${MAGENTA}Remember: Tabs over spaces... or war. 🚀${NC}
EOF

echo -n "${BOLD}Final countdown "
for i in {5..1}; do
    echo -n "$i "
    sleep 0.2
done
echo "${GREEN}💥 GO TIME!${NC}"

