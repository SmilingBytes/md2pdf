#!/bin/bash

# md2pdf installer
# https://github.com/SmilingBytes/md2pdf

set -e

VERSION="1.0.0"
GITHUB_USER="SmilingBytes"
GITHUB_REPO="md2pdf"
SCRIPT_NAME="md2pdf.sh"
INSTALL_DIR="$HOME/.local/share/md2pdf"
BIN_DIR="$HOME/.local/bin"
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/$SCRIPT_NAME"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
    echo -e "${BLUE}${BOLD}"
    echo "  ┌─────────────────────────────────────┐"
    echo "  │           md2pdf installer          │"
    echo "  │      Markdown to PDF converter      │"
    echo "  └─────────────────────────────────────┘"
    echo -e "${NC}"
}

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -h, --help       Show this help message
    -v, --version    Show version
    -u, --uninstall  Uninstall md2pdf
    --check          Check dependencies only
    --no-deps        Skip dependency installation prompts

Examples:
    # Install md2pdf
    curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/install.sh | bash

    # Uninstall
    curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/install.sh | bash -s -- --uninstall
EOF
}

check_command() {
    command -v "$1" &>/dev/null
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

check_dependencies() {
    local missing=()
    
    info "Checking dependencies..."
    
    if check_command pandoc; then
        success "pandoc found: $(pandoc --version | head -1)"
    else
        missing+=("pandoc")
        warn "pandoc not found"
    fi
    
    if check_command weasyprint; then
        success "weasyprint found: $(weasyprint --version 2>&1 | head -1)"
    else
        missing+=("weasyprint")
        warn "weasyprint not found"
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo ""
        warn "Missing dependencies: ${missing[*]}"
        return 1
    fi
    
    return 0
}

install_dependencies() {
    local os=$(detect_os)
    
    echo ""
    info "Installing dependencies for $os..."
    
    case "$os" in
        arch|manjaro|endeavouros)
            sudo pacman -S --needed pandoc python-weasyprint
            ;;
        ubuntu|debian|pop|linuxmint)
            sudo apt update && sudo apt install -y pandoc weasyprint
            ;;
        fedora)
            sudo dnf install -y pandoc weasyprint
            ;;
        macos)
            if check_command brew; then
                brew install pandoc weasyprint
            else
                error "Homebrew not found. Install from https://brew.sh"
                return 1
            fi
            ;;
        *)
            error "Unknown OS. Please install pandoc and weasyprint manually:"
            echo "  - pandoc: https://pandoc.org/installing.html"
            echo "  - weasyprint: https://doc.courtbouillon.org/weasyprint/stable/first_steps.html"
            return 1
            ;;
    esac
}

prompt_install_deps() {
    echo ""
    read -rp "Would you like to install missing dependencies? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            install_dependencies
            ;;
        *)
            warn "Skipping dependency installation"
            warn "md2pdf will not work without pandoc and weasyprint"
            ;;
    esac
}

get_shell_rc() {
    local shell_name=$(basename "$SHELL")
    case "$shell_name" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bashrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *)    echo "" ;;
    esac
}

install() {
    print_banner
    
    # Check and install dependencies
    if ! check_dependencies; then
        if [[ "$NO_DEPS" != "true" ]]; then
            prompt_install_deps
        fi
    fi
    
    echo ""
    info "Installing md2pdf..."
    
    # Create directories
    mkdir -p "$INSTALL_DIR" "$BIN_DIR"
    
    # Download the script
    info "Downloading $SCRIPT_NAME..."
    if curl -fsSL "$RAW_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
        success "Downloaded to $INSTALL_DIR/$SCRIPT_NAME"
    else
        error "Failed to download. Check your internet connection."
        exit 1
    fi
    
    # Create symlink in bin directory
    ln -sf "$INSTALL_DIR/$SCRIPT_NAME" "$BIN_DIR/md2pdf"
    success "Created symlink: $BIN_DIR/md2pdf"
    
    # Add shell integration for sourcing (function aliases)
    local rc_file=$(get_shell_rc)
    local shell_name=$(basename "$SHELL")
    
    if [[ -n "$rc_file" && -f "$rc_file" ]]; then
        local source_line="[[ -f \"$INSTALL_DIR/$SCRIPT_NAME\" ]] && source \"$INSTALL_DIR/$SCRIPT_NAME\""
        
        if [[ "$shell_name" == "fish" ]]; then
            source_line="test -f \"$INSTALL_DIR/$SCRIPT_NAME\"; and source \"$INSTALL_DIR/$SCRIPT_NAME\""
        fi
        
        if ! grep -q "md2pdf" "$rc_file" 2>/dev/null; then
            echo "" >> "$rc_file"
            echo "# md2pdf - Markdown to PDF converter" >> "$rc_file"
            echo "$source_line" >> "$rc_file"
            success "Added to $rc_file"
        else
            info "Shell integration already configured"
        fi
    fi
    
    # Check if BIN_DIR is in PATH
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        warn "$BIN_DIR is not in your PATH"
        echo "  Add this to your shell config:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    
    echo ""
    echo -e "${GREEN}${BOLD}Installation complete!${NC}"
    echo ""
    echo "For more options: md2pdf --help"
}

uninstall() {
    print_banner
    info "Uninstalling md2pdf..."
    
    # Remove installation directory
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        success "Removed $INSTALL_DIR"
    fi
    
    # Remove symlink
    if [[ -L "$BIN_DIR/md2pdf" ]]; then
        rm -f "$BIN_DIR/md2pdf"
        success "Removed $BIN_DIR/md2pdf"
    fi
    
    # Note about shell config
    local rc_file=$(get_shell_rc)
    if [[ -n "$rc_file" ]]; then
        warn "You may want to remove md2pdf lines from $rc_file"
    fi
    
    echo ""
    success "md2pdf has been uninstalled"
}

# Parse arguments
NO_DEPS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            echo "md2pdf installer v$VERSION"
            exit 0
            ;;
        -u|--uninstall)
            uninstall
            exit 0
            ;;
        --check)
            check_dependencies
            exit $?
            ;;
        --no-deps)
            NO_DEPS=true
            shift
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Run installation
install
