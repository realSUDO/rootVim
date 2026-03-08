#!/usr/bin/env bash

# Author: justmultiply
# Cosmic Edition: Now with Premium Visual Flair ✨
# Fixed Version: Production-ready with comprehensive error handling

# Safer error handling - removed set -e, using explicit checks
set -o pipefail

# Internet connectivity check
check_internet() {
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1 && ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        return 1
    fi
    return 0
}

# Disk space check (need 500MB)
check_disk_space() {
    local available=$(df "$HOME" | awk 'NR==2 {print $4}')
    local needed=512000  # 500MB in KB
    [ "$available" -gt "$needed" ]
}

# Minimum Neovim version check (0.9+)
check_nvim_version() {
    if command -v nvim >/dev/null 2>&1; then
        local version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | sed 's/v//')
        local major=$(echo "$version" | cut -d. -f1)
        local minor=$(echo "$version" | cut -d. -f2)
        [ "$major" -gt 0 ] || ([ "$major" -eq 0 ] && [ "$minor" -ge 9 ])
    else
        return 1
    fi
}

# Detect if running from curl pipe
if [ -t 0 ]; then
    INTERACTIVE=true
else
    INTERACTIVE=false
fi

# Clear terminal only if interactive
[ "$INTERACTIVE" = true ] && clear

# ==== TERMINAL ART ====
cat << "EOF"
 ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
 ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ 
▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   
         ░    ░  ░    ░ ░        ░   ░         ░   
                                ░                  
EOF

# ==== COLOR PALETTE ====
BOLD=$(tput bold 2>/dev/null || echo "")
GREEN=$(tput setaf 46 2>/dev/null || echo "")
YELLOW=$(tput setaf 226 2>/dev/null || echo "")
RED=$(tput setaf 196 2>/dev/null || echo "")
BLUE=$(tput setaf 39 2>/dev/null || echo "")
CYAN=$(tput setaf 51 2>/dev/null || echo "")
NEON_WHITE=$(tput setaf 255 2>/dev/null || echo "")
GRAY=$(tput setaf 245 2>/dev/null || echo "")
NC=$(tput sgr0 2>/dev/null || echo "")

# Animations
SPINNER=("🌒 " "🌓 " "🌔 " "🌕 " "🌖 " "🌗 " "🌘 " "🌑 ")
DIVIDER="$(printf '.%.0s' $(seq 1 $(tput cols 2>/dev/null || echo 80)))"

# Fun messages
QUIPS=(
    "Initializing premium Neovim experience ✨"
    "Your editor is about to transcend reality 🚀"
    "Loading elite coding environment... 💎"
    "Preparing to make IDEs jealous 😎"
    "This setup is so clean, it sparkles ✨"
    "Optimizing at the speed of light ⚡"
    "Turning your terminal into a work of art 🎨"
    "Code so clean it should be in a museum 🏛️"
    "The editor experience you deserve 🦄"
    "Smoother than a fresh macOS install 🍏"
)

REJECTS=(
    "Nah, not feeling it."
    "Negative, captain."
    "Hard pass 🚫"
    "Abort mission."
    "Declined with extreme prejudice 💔"
    "Bruh... no. 😒"
    "Your loss, legend. 🏆"
    "Skipping like a stone on water 🌊"
    "Rejected like a bad PR 👎"
    "Aight, peace out ✌️"
)

# ==== FUNCTIONS ====
random_quip() {
    echo "${NEON_WHITE}${BOLD}${QUIPS[$((RANDOM % ${#QUIPS[@]}))]}${NC}"
}

random_reject() {
    echo "${YELLOW}${BOLD}${REJECTS[$((RANDOM % ${#REJECTS[@]}))]}${NC}"
}

# Fixed spinner that works without set -e
spinner() {
    local pid=$1
    local msg="$2"
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 8 ))
        printf "\r${SPINNER[$i]} ${NEON_WHITE}${msg}...${NC}"
        sleep 0.1
    done
    printf "\r\033[2K"
    wait "$pid"
    return $?
}

header() {
    echo
    echo "${GRAY}${DIVIDER}${NC}"
    echo "${NEON_WHITE}${BOLD}$(printf "%*s" $(( (${#1} + $(tput cols 2>/dev/null || echo 80)) / 2 )) "${1}")${NC}"
    echo "${GRAY}${DIVIDER}${NC}"
    echo
    random_quip
    echo
}

success() {
    echo "${GREEN}${BOLD}✓ ${NEON_WHITE}${1}${NC}"
}

warning() {
    echo "${YELLOW}${BOLD}⚠ ${NEON_WHITE}${1}${NC}"
}

error() {
    echo "${RED}${BOLD}✗ ${NEON_WHITE}${1}${NC}"
    exit 1
}

ask() {
    local timeout=30
    local question="$1"
    local default="${2:-N}"
    
    echo -e "\n${BOLD}${BLUE}? ${NEON_WHITE}${question}${NC}"
    echo -n "${CYAN}[y/N] (${timeout}s timeout): ${NC}"
    
    if ! read -t "$timeout" -r choice; then
        echo -e "\n${YELLOW}Timeout reached. Using default: ${default}${NC}"
        case "${default}" in
            [Yy]*) return 0 ;;
            *) return 1 ;;
        esac
    fi
    
    case "${choice}" in
        [Yy]*) return 0 ;;
        [Nn]*) random_reject; return 1 ;;
        *) 
            case "${default}" in
                [Yy]*) return 0 ;;
                *) random_reject; return 1 ;;
            esac
            ;;
    esac
}

# Sudo keepalive loop
sudo_keepalive() {
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" 2>/dev/null || exit
    done 2>/dev/null &
    SUDO_PID=$!
}

cleanup() {
    [ -n "$SUDO_PID" ] && kill "$SUDO_PID" 2>/dev/null
}
trap cleanup EXIT

# ==== PREMIUM LAUNCH SEQUENCE ====
header "PREMIUM NEOVIM DEPLOYMENT"

# Initial checks
echo "${BOLD}${NEON_WHITE}Running initial system checks...${NC}"

if ! check_internet; then
    error "No internet connection detected. Cannot proceed with installation."
fi
success "Internet connectivity confirmed 🌐"

if ! check_disk_space; then
    error "Insufficient disk space. Need at least 500MB free in home directory."
fi
success "Sufficient disk space available 💾"

# Sudo verification with keepalive
echo "${BOLD}${NEON_WHITE}Verifying SUDO credentials...${NC}"
if sudo -v; then
    success "SUDO access confirmed. We have liftoff clearance! 🚀"
    sudo_keepalive
else
    error "SUDO verification failed. Aborting mission. 🚨"
fi

# ==== SYSTEM CHECKS ====
header "SYSTEM INSPECTION"

[ "$(id -u)" -eq 0 ] && error "Root detected! Regular user privileges required."
command -v python3 >/dev/null || error "Python3 missing. This ain't the stone age."

# Detect OS and package manager
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    error "Cannot detect OS. Unsupported system."
fi

if command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm --needed"
elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
    # Update package list for Ubuntu
    echo "${BOLD}${NEON_WHITE}Updating package lists...${NC}"
    sudo apt update >/dev/null 2>&1 &
    if ! spinner $! "Updating package database"; then
        warning "Package update failed, continuing anyway"
    else
        success "Package database updated"
    fi
else
    error "Unsupported package manager. Only pacman and apt are supported."
fi

success "Detected: $OS with $PKG_MANAGER package manager"

# Handle script directory for curl pipe execution
if [ "$INTERACTIVE" = false ] || [ ! -f "$(dirname "$0")/init.lua" ]; then
    warning "Config files not found locally. Cloning repository..."
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/justmultiply/nvim-config.git "$TEMP_DIR" >/dev/null 2>&1 &
    if ! spinner $! "Cloning repository"; then
        error "Failed to clone repository. Check internet connection."
    fi
    SCRIPT_DIR="$TEMP_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Interactive system scan
if ask "Scan system for optimal configuration?" "Y"; then
    (sudo lscpu | grep "Model name" && free -h) 2>/dev/null &
    spinner $! "Analyzing system specs"
    success "System scan complete. Ready for deployment."
else
    warning "System scan skipped. Proceeding blind. 🕶️"
fi

# ==== CORE DEPENDENCIES ====
header "ESSENTIAL DEPENDENCIES"

install_pkg() {
    local pkg="$1"
    local reason="$2"
    local critical="${3:-true}"
    
    # Check if package is installed
    local is_installed=false
    if [ "$PKG_MANAGER" = "pacman" ]; then
        pacman -Qi "$pkg" &>/dev/null && is_installed=true
    elif [ "$PKG_MANAGER" = "apt" ]; then
        dpkg -l | grep -q "^ii  $pkg " && is_installed=true
    fi
    
    if $is_installed; then
        success "${pkg} already installed and ready 💪"
    else
        warning "${pkg} missing! Required for: ${reason}"
        if ask "Install ${pkg}?" "Y"; then
            $INSTALL_CMD "$pkg" >/dev/null 2>&1 &
            if spinner $! "Installing ${pkg}"; then
                success "${pkg} successfully installed! 🎯"
            else
                if $critical; then
                    error "Critical package ${pkg} failed! Aborting. 🚨"
                else
                    warning "${pkg} installation failed. Continuing anyway..."
                fi
            fi
        elif $critical; then
            error "Critical package skipped. Cannot continue. 💥"
        else
            warning "${pkg} skipped. Hope you know what you're doing. 🤞"
        fi
    fi
}

# Core packages with premium status
if [ "$PKG_MANAGER" = "pacman" ]; then
    install_pkg "neovim" "The premium editor experience" true
    install_pkg "git" "Version control system" true
    install_pkg "python-pip" "Python package excellence" true
    install_pkg "nodejs" "JavaScript runtime supremacy" true
    install_pkg "npm" "Node package mastery" true
    install_pkg "base-devel" "Build tools for compilation" true
    install_pkg "tree-sitter" "Syntax parsing engine" true
    install_pkg "unzip" "Mason LSP tool extraction" true
    install_pkg "wget" "Mason LSP downloads" true
    install_pkg "curl" "Mason LSP downloads" true
elif [ "$PKG_MANAGER" = "apt" ]; then
    # Add NodeSource PPA for latest Node.js
    if ! grep -q "nodesource" /etc/apt/sources.list.d/* 2>/dev/null; then
        warning "Adding NodeSource PPA for latest Node.js"
        if ask "Add NodeSource PPA for Node.js?" "Y"; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - >/dev/null 2>&1 &
            if spinner $! "Adding NodeSource PPA"; then
                success "NodeSource PPA added successfully"
            else
                warning "Failed to add NodeSource PPA, using system Node.js"
            fi
        fi
    fi
    
    install_pkg "neovim" "The premium editor experience" true
    install_pkg "git" "Version control system" true
    install_pkg "python3-pip" "Python package excellence" true
    install_pkg "python3-venv" "Python virtual environments" true
    install_pkg "nodejs" "JavaScript runtime supremacy" true
    install_pkg "npm" "Node package mastery" true
    install_pkg "build-essential" "Build tools for compilation" true
    install_pkg "libtree-sitter-dev" "Syntax parsing engine" true
    install_pkg "unzip" "Mason LSP tool extraction" true
    install_pkg "wget" "Mason LSP downloads" true
    install_pkg "curl" "Mason LSP downloads" true
fi

# Check Neovim version after installation
if ! check_nvim_version; then
    error "Neovim version 0.9+ required. Current version is too old."
fi
success "Neovim version check passed ✅"

# ==== CLIPBOARD SUPPORT ====
header "CLIPBOARD INTEGRATION"

CLIPBOARD_NOTE="For seamless copy/paste experience"
WAYLAND=$(env | grep -q WAYLAND_DISPLAY && echo 1 || echo 0)
X11=$(env | grep -q DISPLAY && echo 1 || echo 0)

if [ "$WAYLAND" -eq 1 ]; then
    install_pkg "wl-clipboard" "$CLIPBOARD_NOTE (Wayland)" false
elif [ "$X11" -eq 1 ]; then
    if ! command -v xclip >/dev/null && ! command -v xsel >/dev/null; then
        warning "No clipboard tools detected"
        if ask "Install xclip for premium clipboard support?" "Y"; then
            $INSTALL_CMD xclip >/dev/null 2>&1 &
            if spinner $! "Installing xclip"; then
                success "xclip ready for action! 📋"
            else
                warning "xclip installation failed"
            fi
        fi
    else
        success "Clipboard tools already installed 👍"
    fi
else
    warning "No GUI environment detected. Clipboard might not work. 🤷"
fi

# ==== PYTHON ENVIRONMENT ====
header "PYTHON SETUP"

GLOBAL_PY="$HOME/.globalPython"

if [ ! -d "$GLOBAL_PY" ]; then
    if ask "Set up Python virtual environment at $GLOBAL_PY?" "Y"; then
        python3 -m venv "$GLOBAL_PY" >/dev/null 2>&1 &
        if spinner $! "Creating premium Python environment"; then
            success "Python virtualenv ready at ~/.globalPython 🐍"
        else
            error "Failed to create Python virtual environment"
        fi
    else
        warning "Python virtual environment skipped. Risky move. 🎲"
    fi
else
    success "Python environment already exists 🏰"
fi

if [ -d "$GLOBAL_PY" ]; then
    "$GLOBAL_PY/bin/pip" install --upgrade pip setuptools wheel >/dev/null 2>&1 &
    spinner $! "Upgrading Python toolchain ⬆️"
    
    install_python_tool() {
        local tool="$1"
        local reason="$2"
        local critical="${3:-false}"
        
        if "$GLOBAL_PY/bin/pip" show "$tool" >/dev/null 2>&1; then
            success "${tool} already installed ✅"
        else
            warning "${tool} missing: ${reason}"
            if ask "Install ${tool}?" "Y"; then
                "$GLOBAL_PY/bin/pip" install "$tool" >/dev/null 2>&1 &
                if spinner $! "Installing ${tool}"; then
                    success "${tool} installed successfully! 🎯"
                else
                    if $critical; then
                        error "Critical Python tool ${tool} failed! Abort! 🚨"
                    else
                        warning "${tool} installation failed. Moving on..."
                    fi
                fi
            elif $critical; then
                error "Critical Python tool skipped! Cannot continue! 💥"
            else
                warning "${tool} skipped. Hope you have alternatives. 🤷"
            fi
        fi
    }
    
    # Essential Python tools
    install_python_tool "pynvim" "Neovim Python integration" true
    install_python_tool "black" "Code formatting perfection" false
    install_python_tool "isort" "Import organization" false
fi

# ==== NPM PACKAGES ====
header "NPM PACKAGES"

install_npm_pkg() {
    local pkg="$1"
    local reason="$2"
    local critical="${3:-false}"
    
    # Fixed npm list check to not fail on missing packages
    if npm list -g "$pkg" >/dev/null 2>&1; then
        success "${pkg} already installed 🌟"
    else
        warning "${pkg} needed for: ${reason}"
        if ask "Install ${pkg} globally via npm?" "Y"; then
            sudo npm install -g "$pkg" >/dev/null 2>&1 &
            if spinner $! "Installing ${pkg}"; then
                success "${pkg} installed successfully! 🎊"
            else
                if $critical; then
                    error "${pkg} installation failed! Aborting. 🚨"
                else
                    warning "${pkg} installation failed. Continuing..."
                fi
            fi
        elif $critical; then
            error "Critical npm package skipped! Cannot continue! 💥"
        else
            warning "${pkg} skipped."
        fi
    fi
}

install_npm_pkg "typescript" "TypeScript compilation (tsc)" true
install_npm_pkg "live-server" "HTML live development server" true

# ==== PASSMASK PLUGIN ====
header "PASSMASK PLUGIN (OPTIONAL)"

PASSMASK_SRC="$HOME/CrazyProjects/passmask"
PASSMASK_DEST="$HOME/.local/share/nvim/passmask"

if [ -d "$PASSMASK_SRC" ]; then
    warning "Passmask plugin found at $PASSMASK_SRC"
    if ask "Install passmask plugin for password masking?" "N"; then
        mkdir -p "$(dirname "$PASSMASK_DEST")"
        cp -r "$PASSMASK_SRC" "$PASSMASK_DEST" >/dev/null 2>&1 &
        if spinner $! "Installing passmask plugin"; then
            success "Passmask plugin installed! 🔒"
        else
            warning "Passmask plugin installation failed"
        fi
    else
        warning "Passmask plugin skipped. Plugin will be disabled."
    fi
else
    warning "Passmask plugin not found at $PASSMASK_SRC. Skipping."
fi

# ==== CONFIG DEPLOYMENT ====
header "PREMIUM CONFIG DEPLOYMENT"

NVIM_CONFIG_PATH="$HOME/.config/nvim"
BACKUP_DIR="${NVIM_CONFIG_PATH}_backup_$(date +%Y%m%d_%H%M%S)"

if [ -d "$NVIM_CONFIG_PATH" ]; then
    warning "Existing Neovim config detected!"
    if ask "Create backup and install premium config?" "Y"; then
        mv "$NVIM_CONFIG_PATH" "$BACKUP_DIR" >/dev/null 2>&1 &
        if spinner $! "Creating backup"; then
            success "Backup saved at $BACKUP_DIR 📦"
        else
            error "Failed to create backup"
        fi
    else
        error "Installation aborted by user. No changes made. ✋"
    fi
fi

mkdir -p "$NVIM_CONFIG_PATH"
# Don't copy install.sh to config directory
find "$SCRIPT_DIR" -type f ! -name "install*.sh" -exec cp {} "$NVIM_CONFIG_PATH/" \; 2>/dev/null &
if spinner $! "Deploying premium config files"; then
    success "Configuration deployed to $NVIM_CONFIG_PATH 🎯"
else
    error "Failed to deploy configuration files"
fi

# ==== LAZY.NVIM BOOTSTRAP ====
header "LAZY.NVIM BOOTSTRAP"

LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    warning "Bootstrapping Lazy.nvim plugin manager"
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH" >/dev/null 2>&1 &
    if spinner $! "Bootstrapping Lazy.nvim"; then
        success "Lazy.nvim bootstrapped successfully! 🚀"
    else
        error "Failed to bootstrap Lazy.nvim"
    fi
else
    success "Lazy.nvim already bootstrapped ✅"
fi

# ==== PLUGIN SYNC ====
header "PREMIUM PLUGIN INSTALLATION"

echo -e "${BLUE}This may take a while... perfect time for a coffee break! ☕${NC}"
if ask "Proceed with premium plugin installation?" "Y"; then
    nvim --headless "+Lazy! sync" +qa 2>/tmp/nvim_sync.log &
    if spinner $! "Installing premium plugins" && wait $!; then
        success "All premium plugins installed successfully! Ready to code! 💻"
    else
        warning "Plugin installation encountered issues"
        echo -e "${YELLOW}Check logs: /tmp/nvim_sync.log${NC}"
        echo -e "${CYAN}Try manual sync: nvim +Lazy sync${NC}"
    fi
else
    warning "Plugin installation skipped. Run manually later."
fi

# ==== COMPLETION ====
header "MISSION ACCOMPLISHED"

cat <<EOF
${GREEN}${BOLD}Premium Neovim configuration successfully installed!${NC}

${NEON_WHITE}${BOLD}QUICK START GUIDE:${NC}
  🚀 ${BOLD}nvim${NC}          - Launch your premium editor
  🧪 ${BOLD}nvim +checkhealth${NC} - Verify everything works
  🔄 ${BOLD}nvim +Lazy update${NC} - Update plugins

${CYAN}${BOLD}PYTHON TOOLS:${NC}
  Located in ${BOLD}~/.globalPython/bin${NC}
  Add to PATH for easy access:
  ${BOLD}export PATH="\$HOME/.globalPython/bin:\$PATH"${NC}

${NEON_WHITE}Happy coding! May your bugs be few and your coffee strong! ☕${NC}
EOF

# Final countdown
echo -e "\n${BOLD}${NEON_WHITE}Launching in "
for i in {5..1}; do
    echo -n "${i}..."
    sleep 0.5
done
echo -e " ${GREEN}${BOLD}LIFTOFF! 🚀${NC}\n"