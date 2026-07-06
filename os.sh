#!/usr/bin/env bash

# Kali Linux Shell Customizer (Kali-TH)
# Created by Raj Aryan (H4CK3R)


# Color variables
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;93m'
B='\033[1;34m'
C='\033[1;36m'
W='\033[1;97m'
RS='\033[0m'
DG='\033[90m'


clear
SUDO_CMD=$(command -v sudo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine Target User and Home Directory
if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$(whoami)"
    TARGET_HOME="$HOME"
fi

# Ownership Correction Helper
adjust_ownership() {
    if [ "$TARGET_USER" != "$(whoami)" ] && [ -n "$TARGET_USER" ]; then
        for file in "$@"; do
            if [ -e "$file" ]; then
                chown -R "$TARGET_USER:$TARGET_USER" "$file" 2>/dev/null || true
            fi
        done
    fi
}

# Ensure we're in the script directory
cd "$SCRIPT_DIR" 2>/dev/null

# Display banner
banner() {
    clear
    if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
        figlet -f standard "Kali-TH" | lolcat
    else
        echo -e "${R}  _  __        _ _      _______ _    _  ${RS}"
        echo -e "${R} | |/ /       | (_)    |__   __| |  | | ${RS}"
        echo -e "${R} | ' /  __ _  | |_       | |  | |__| | ${RS}"
        echo -e "${R} |  <  / _\` | | | |      | |  |  __  | ${RS}"
        echo -e "${R} | . \| (_| | | | |      | |  | |  | | ${RS}"
        echo -e "${R} |_|\_\\\\__,_| |_|_|      |_|  |_|  |_| ${RS}"
        echo -e "${B}                                        ${RS}"
        echo -e "${C}             Kali Linux Customizer      ${RS}"
    fi
    echo -e "${B} ┌──────────────────────────────────────────────────┐"
    echo -e "${B} │ ${W}Coder  : ${C}Raj Aryan ${B}│ ${W}YouTube : ${G}H4Ck3R ${B}        │"
    echo -e "${B} │ ${W}Version: ${Y}4.0       ${B}│ ${W}Target  : ${R}Kali Linux ${B}    │"
    echo -e "${B} └──────────────────────────────────────────────────┘${RS}"
}

# Error prompt
wr() {
    echo -e "${R}\n [!] Invalid Option Selected!${RS}"
    sleep 1
    menu
}

# Verify Kali Linux / Debian Compatibility
check_kali() {
    if [ ! -f /etc/debian_version ]; then
        echo -e "${R}[!] Warning: This script is designed for Debian/Kali Linux systems.${RS}"
        read -p "Do you want to proceed anyway? [y/N]: " proceed
        if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
            echo -e "${R}Exiting script.${RS}"
            exit 1
        fi
    fi
}

# Install core packages
install_packages() {
    echo -e "${G}\n [*] Updating system databases...${RS}"
    $SUDO_CMD apt update
    
    echo -e "${G} [*] Installing core tools (zsh, fish, fastfetch, figlet, toilet, git, wget, curl, unzip, ruby)...${RS}"
    $SUDO_CMD apt install -y zsh fish fastfetch figlet toilet git wget curl unzip ruby
    
    # Try installing lolcat
    if ! command -v lolcat &> /dev/null; then
        echo -e "${G} [*] Installing lolcat...${RS}"
        $SUDO_CMD apt install -y lolcat || gem install lolcat
    fi
    
    echo -e "${G} [✓] Core packages installed successfully!${RS}"
    sleep 2
    menu
}

# Apply custom Zsh theme
apply_zsh_theme() {
    # Verify Zsh installation
    if ! command -v zsh &> /dev/null; then
        echo -e "${Y}\n [!] Zsh is not installed. Installing it...${RS}"
        $SUDO_CMD apt install -y zsh
    fi

    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    # Oh-My-Zsh Installation Check
    if [ ! -d "$TARGET_HOME/.oh-my-zsh" ]; then
        read -p " Oh My Zsh is not installed. Install it now? [y/N]: " inst_omz
        if [[ "$inst_omz" =~ ^[Yy]$ ]]; then
            echo -e "${G} [*] Downloading & installing Oh My Zsh (unattended)...${RS}"
            if [ "$TARGET_USER" != "$(whoami)" ]; then
                sudo -u "$TARGET_USER" env CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            else
                env CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            fi
        fi
    fi

    # Deploy Theme File
    echo -e "${G} [*] Copying theme file to Zsh directory...${RS}"
    OMZ_THEMES="$TARGET_HOME/.oh-my-zsh/themes"
    STANDALONE_THEMES="$TARGET_HOME/.zsh/themes"
    
    if [ -d "$TARGET_HOME/.oh-my-zsh" ]; then
        mkdir -p "$OMZ_THEMES"
        sed -e "s/H4CK3R/$custom_name/g" "$SCRIPT_DIR/.object/.h4Ck3r.zsh-theme" > "$OMZ_THEMES/h4Ck3r.zsh-theme"
    fi
    mkdir -p "$STANDALONE_THEMES"
    sed -e "s/H4CK3R/$custom_name/g" "$SCRIPT_DIR/.object/.h4Ck3r.zsh-theme" > "$STANDALONE_THEMES/h4Ck3r.zsh-theme"

    # Set up Config
    echo -e "${G} [*] Deploying custom .zshrc...${RS}"
    [ -f "$TARGET_HOME/.zshrc" ] && cp "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zshrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.zshrc_template" > "$TARGET_HOME/.zshrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$TARGET_HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$TARGET_HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */zsh ]]; then
        read -p " Change default shell to Zsh? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v zsh)" "$TARGET_USER"
            echo -e "${G} [✓] Shell changed to Zsh. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

    adjust_ownership "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zshrc.bak" "$TARGET_HOME/.oh-my-zsh/themes/h4Ck3r.zsh-theme" "$TARGET_HOME/.zsh" "$TARGET_HOME/.config/fastfetch"

    echo -e "${G} [✓] Zsh theme applied successfully!${RS}"
    sleep 2
    menu
}

# Apply custom Bash theme
apply_bash_theme() {
    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    echo -e "${G} [*] Deploying custom .bashrc...${RS}"
    [ -f "$TARGET_HOME/.bashrc" ] && cp "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.bashrc_template" > "$TARGET_HOME/.bashrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$TARGET_HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$TARGET_HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */bash ]]; then
        read -p " Change default shell to Bash? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v bash)" "$TARGET_USER"
            echo -e "${G} [✓] Shell changed to Bash. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

    adjust_ownership "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak" "$TARGET_HOME/.config/fastfetch"

    echo -e "${G} [✓] Bash theme applied successfully! Run 'source ~/.bashrc' to apply.${RS}"
    sleep 2
    menu
}

# Apply custom Fish theme
apply_fish_theme() {
    # Verify Fish installation
    if ! command -v fish &> /dev/null; then
        echo -e "${Y}\n [!] Fish is not installed. Installing it...${RS}"
        $SUDO_CMD apt install -y fish
    fi

    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    echo -e "${G} [*] Deploying custom config.fish...${RS}"
    mkdir -p "$TARGET_HOME/.config/fish"
    [ -f "$TARGET_HOME/.config/fish/config.fish" ] && cp "$TARGET_HOME/.config/fish/config.fish" "$TARGET_HOME/.config/fish/config.fish.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/config.fish_template" > "$TARGET_HOME/.config/fish/config.fish"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$TARGET_HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$TARGET_HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */fish ]]; then
        read -p " Change default shell to Fish? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v fish)" "$TARGET_USER"
            echo -e "${G} [✓] Shell changed to Fish. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

    adjust_ownership "$TARGET_HOME/.config/fish" "$TARGET_HOME/.config/fastfetch"

    echo -e "${G} [✓] Fish theme applied successfully!${RS}"
    sleep 2
    menu
}

# Download & Setup Zsh Plugins
apply_zsh_plugins() {
    echo -e "${G}\n [*] Setting up autosuggestions and syntax highlighting...${RS}"
    
    # Try system packages first
    echo -e "${G} [*] Installing plugin system packages if available...${RS}"
    $SUDO_CMD apt install -y zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null
    
    # Backup setup: Clone to user directories
    ZSH_PLUGINS_DIR="$TARGET_HOME/.zsh"
    mkdir -p "$ZSH_PLUGINS_DIR"

    # Syntax Highlighting
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
        echo -e "${G} [*] Cloning zsh-syntax-highlighting...${RS}"
        if [ "$TARGET_USER" != "$(whoami)" ]; then
            sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
        fi
    else
        echo -e "${G} [*] Updating zsh-syntax-highlighting...${RS}"
        if [ "$TARGET_USER" != "$(whoami)" ]; then
            sudo -u "$TARGET_USER" sh -c "cd '$ZSH_PLUGINS_DIR/zsh-syntax-highlighting' && git pull"
        else
            cd "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" && git pull && cd "$SCRIPT_DIR"
        fi
    fi

    # Autosuggestions
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
        echo -e "${G} [*] Cloning zsh-autosuggestions...${RS}"
        if [ "$TARGET_USER" != "$(whoami)" ]; then
            sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
        else
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
        fi
    else
        echo -e "${G} [*] Updating zsh-autosuggestions...${RS}"
        if [ "$TARGET_USER" != "$(whoami)" ]; then
            sudo -u "$TARGET_USER" sh -c "cd '$ZSH_PLUGINS_DIR/zsh-autosuggestions' && git pull"
        else
            cd "$ZSH_PLUGINS_DIR/zsh-autosuggestions" && git pull && cd "$SCRIPT_DIR"
        fi
    fi

    adjust_ownership "$ZSH_PLUGINS_DIR"

    echo -e "${G} [✓] Plugins ready! Reload Zsh to verify.${RS}"
    sleep 2
    apply_plugins
}

# Download & Setup Bash Plugins (ble.sh)
apply_bash_plugins() {
    echo -e "${G}\n [*] Setting up ble.sh for Bash (Syntax Highlighting & Auto-suggestions)...${RS}"
    
    local blesh_installed=false
    local blesh_path=""
    
    # Check if ble.sh is already installed
    if [ -f "/usr/share/blesh/ble.sh" ]; then
        blesh_installed=true
        blesh_path="/usr/share/blesh/ble.sh"
    elif [ -f "$TARGET_HOME/.local/share/blesh/ble.sh" ]; then
        blesh_installed=true
        blesh_path="$TARGET_HOME/.local/share/blesh/ble.sh"
    fi
    
    if [ "$blesh_installed" = true ]; then
        echo -e "${G} [✓] ble.sh is already installed at: $blesh_path${RS}"
    else
        # Try installing via system package manager first
        echo -e "${G} [*] Trying to install blesh via apt...${RS}"
        $SUDO_CMD apt install -y blesh 2>/dev/null
        
        # Re-check if apt installation succeeded
        if [ -f "/usr/share/blesh/ble.sh" ]; then
            blesh_installed=true
            blesh_path="/usr/share/blesh/ble.sh"
        fi
        
        # Fallback to nightly pre-built download if package manager failed
        if [ "$blesh_installed" = false ]; then
            echo -e "${Y} [*] Package blesh not found or install failed. Downloading pre-built ble.sh nightly...${RS}"
            local blesh_dir="$TARGET_HOME/.local/share/blesh"
            if [ "$TARGET_USER" != "$(whoami)" ]; then
                sudo -u "$TARGET_USER" mkdir -p "$blesh_dir"
            else
                mkdir -p "$blesh_dir"
            fi
            if command -v curl &>/dev/null && command -v tar &>/dev/null; then
                if [ "$TARGET_USER" != "$(whoami)" ]; then
                    if sudo -u "$TARGET_USER" curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | sudo -u "$TARGET_USER" tar xJf - -C "$blesh_dir" --strip-components=1; then
                        blesh_installed=true
                        blesh_path="$blesh_dir/ble.sh"
                    fi
                else
                    if curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - -C "$blesh_dir" --strip-components=1; then
                        blesh_installed=true
                        blesh_path="$blesh_dir/ble.sh"
                    fi
                fi
            elif command -v wget &>/dev/null && command -v tar &>/dev/null; then
                if [ "$TARGET_USER" != "$(whoami)" ]; then
                    if sudo -u "$TARGET_USER" wget -O - https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | sudo -u "$TARGET_USER" tar xJf - -C "$blesh_dir" --strip-components=1; then
                        blesh_installed=true
                        blesh_path="$blesh_dir/ble.sh"
                    fi
                else
                    if wget -O - https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - -C "$blesh_dir" --strip-components=1; then
                        blesh_installed=true
                        blesh_path="$blesh_dir/ble.sh"
                    fi
                fi
            fi
        fi
    fi
    
    if [ "$blesh_installed" = false ] || [ ! -f "$blesh_path" ]; then
        echo -e "${R} [!] Failed to install ble.sh. Please install git/curl/tar or build manually.${RS}"
        sleep 2
        apply_plugins
        return
    fi
    
    # Configure in ~/.bashrc
    if [ -f "$TARGET_HOME/.bashrc" ]; then
        if ! grep -q "ble.sh" "$TARGET_HOME/.bashrc"; then
            echo -e "${G} [*] Adding ble.sh to .bashrc...${RS}"
            
            # Temporary file to build new .bashrc
            local temp_rc=$(mktemp)
            local added=false
            
            # Write out modified .bashrc line-by-line
            while IFS= read -r line; do
                echo "$line" >> "$temp_rc"
                # Locate where to insert the source command: right after the non-interactive check
                if [[ "$line" == *"[[ $- != *i* ]]"* ]]; then
                    if [ "$added" = false ]; then
                        echo -e "\n# Enable ble.sh" >> "$temp_rc"
                        echo 'if [ -f "/usr/share/blesh/ble.sh" ]; then' >> "$temp_rc"
                        echo '    source /usr/share/blesh/ble.sh --noattach' >> "$temp_rc"
                        echo 'elif [ -f "$HOME/.local/share/blesh/ble.sh" ]; then' >> "$temp_rc"
                        echo '    source "$HOME/.local/share/blesh/ble.sh" --noattach' >> "$temp_rc"
                        echo 'fi' >> "$temp_rc"
                        added=true
                    fi
                fi
            done < "$TARGET_HOME/.bashrc"
            
            if [ "$added" = false ]; then
                # Prepend if no interactive check line was matched
                (
                    echo "# Enable ble.sh"
                    echo 'if [ -f "/usr/share/blesh/ble.sh" ]; then'
                    echo '    source /usr/share/blesh/ble.sh --noattach'
                    echo 'elif [ -f "$HOME/.local/share/blesh/ble.sh" ]; then'
                    echo '    source "$HOME/.local/share/blesh/ble.sh" --noattach'
                    echo 'fi'
                    echo ""
                    cat "$TARGET_HOME/.bashrc"
                ) > "$temp_rc"
            fi
            
            # Append ble-attach at the end
            echo -e "\n# Attach ble.sh\n[[ \${BLE_VERSION-} ]] && ble-attach" >> "$temp_rc"
            
            # Move back to ~/.bashrc
            cp "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak"
            mv "$temp_rc" "$TARGET_HOME/.bashrc"
        fi
    else
        # No .bashrc exists, create a minimal one
        echo -e "${G} [*] Creating a minimal .bashrc with ble.sh configuration...${RS}"
        cat << EOF > "$TARGET_HOME/.bashrc"
# ~/.bashrc - Customized by Kali-TH

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

# Enable ble.sh
if [ -f "/usr/share/blesh/ble.sh" ]; then
    source /usr/share/blesh/ble.sh --noattach
elif [ -f "\$HOME/.local/share/blesh/ble.sh" ]; then
    source "\$HOME/.local/share/blesh/ble.sh" --noattach
fi

# Attach ble.sh
[[ \${BLE_VERSION-} ]] && ble-attach
EOF
    fi
    
    adjust_ownership "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak" "$TARGET_HOME/.local/share/blesh"

    echo -e "${G} [✓] ble.sh is configured! Restart your Bash terminal or run 'source ~/.bashrc' to apply.${RS}"
    sleep 3
    apply_plugins
}

# Download & Setup Fish Plugins (Fisher)
apply_fish_plugins() {
    echo -e "${G}\n [*] Setting up Fisher and plugins for Fish...${RS}"
    
    if ! command -v fish &> /dev/null; then
        echo -e "${Y} [!] Fish is not installed. Installing it first...${RS}"
        $SUDO_CMD apt install -y fish
    fi
    
    # Run Fisher installation via Fish shell
    echo -e "${G} [*] Installing Fisher plugin manager...${RS}"
    if [ "$TARGET_USER" != "$(whoami)" ]; then
        sudo -u "$TARGET_USER" fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
        echo -e "${G} [*] Installing Fish plugins (fzf.fish, sponge, fish-colored-man)...${RS}"
        sudo -u "$TARGET_USER" fish -c 'fisher install PatrickF1/fzf.fish meaningful-ooo/sponge decors/fish-colored-man'
    else
        fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
        echo -e "${G} [*] Installing Fish plugins (fzf.fish, sponge, fish-colored-man)...${RS}"
        fish -c 'fisher install PatrickF1/fzf.fish meaningful-ooo/sponge decors/fish-colored-man'
    fi
    
    echo -e "${G} [✓] Fish plugins setup completed!${RS}"
    sleep 2
    apply_plugins
}

# Download & Setup Plugins (Submenu)
apply_plugins() {
    banner
    echo -e "\n ${C}─── Shell Plugins Configuration ───${RS}"
    printf "  ${DG}[${C}01${DG}]${W} Zsh (Auto-Suggestions & Syntax Highlighting)\n"
    printf "  ${DG}[${C}02${DG}]${W} Bash (ble.sh - Auto-Suggestions & Syntax Highlighting)\n"
    printf "  ${DG}[${C}03${DG}]${W} Fish (Fisher - Auto-Suggestions & Plugins)\n"
    printf "  ${DG}[${C}00${DG}]${R} Back to Main Menu\n"
    echo -e " ${DG}──────────────────────────────────────────────────${RS}"
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read plugin_opt
    case $plugin_opt in
        1|01) apply_zsh_plugins ;;
        2|02) apply_bash_plugins ;;
        3|03) apply_fish_plugins ;;
        0|00) menu ;;
        *) wr ;;
    esac
}

# Install Modern CLI Alternatives
install_modern_cli() {
    echo -e "${G}\n [*] Installing modern CLI replacements (eza, bat, zoxide, ripgrep, fzf, fd-find)...${RS}"
    $SUDO_CMD apt update
    $SUDO_CMD apt install -y eza bat zoxide ripgrep fzf fd-find
    
    # Configure user configs dynamically if they exist
    echo -e "${G} [*] Configuring modern CLI tool configurations & aliases...${RS}"
    
    # Zsh configuration
    if [ -f "$TARGET_HOME/.zshrc" ]; then
        if ! grep -q "Modern CLI Alternatives" "$TARGET_HOME/.zshrc"; then
            cat << 'EOF' >> "$TARGET_HOME/.zshrc"

# Modern CLI Alternatives & Aliases
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
fi
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
fi
if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi
EOF
        fi
    fi
    
    # Bash configuration
    if [ -f "$TARGET_HOME/.bashrc" ]; then
        if ! grep -q "Modern CLI Alternatives" "$TARGET_HOME/.bashrc"; then
            if grep -q "# Attach ble.sh" "$TARGET_HOME/.bashrc"; then
                sed -i '/# Attach ble.sh/i # Modern CLI Alternatives \& Aliases\nif command -v eza \&> \/dev\/null; then\n    alias ls='\''eza --icons --group-directories-first'\''\n    alias la='\''eza -a --icons --group-directories-first'\''\n    alias ll='\''eza -lh --icons --group-directories-first'\''\nfi\nif command -v bat \&> \/dev\/null; then\n    alias cat='\''bat --style=plain --paging=never'\''\nfi\nif command -v fdfind \&> \/dev\/null; then\n    alias fd='\''fdfind'\''\nfi\nif command -v zoxide \&> \/dev\/null; then\n    eval "$(zoxide init bash)"\nfi\n' "$TARGET_HOME/.bashrc"
            else
                cat << 'EOF' >> "$TARGET_HOME/.bashrc"

# Modern CLI Alternatives & Aliases
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
fi
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
fi
if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi
EOF
            fi
        fi
    fi
    
    # Fish configuration
    if [ -f "$TARGET_HOME/.config/fish/config.fish" ]; then
        if ! grep -q "Modern CLI Alternatives" "$TARGET_HOME/.config/fish/config.fish"; then
            cat << 'EOF' >> "$TARGET_HOME/.config/fish/config.fish"

# Modern CLI Alternatives & Aliases
if type -q eza
    alias ls="eza --icons --group-directories-first"
    alias la="eza -a --icons --group-directories-first"
    alias ll="eza -lh --icons --group-directories-first"
end
if type -q bat
    alias cat="bat --style=plain --paging=never"
end
if type -q fdfind
    alias fd="fdfind"
end
if type -q zoxide
    zoxide init fish | source
end
EOF
        fi
    fi
    
    adjust_ownership "$TARGET_HOME/.zshrc" "$TARGET_HOME/.bashrc" "$TARGET_HOME/.config/fish" ; echo -e "${G} [✓] Modern CLI tools installed and configured!${RS}"
    sleep 3
    menu
}

# Helper to write .tmux.conf based on active color configurations
write_tmux_conf() {
    local primary="blue"
    local secondary="red"
    local success="green"
    
    if [ -f "$TARGET_HOME/.config/archify/colors.sh" ]; then
        source "$TARGET_HOME/.config/archify/colors.sh"
        primary="${ARCHIFY_PRIMARY_NAME:-blue}"
        secondary="${ARCHIFY_SECONDARY_NAME:-red}"
        success="${ARCHIFY_SUCCESS_NAME:-green}"
    fi
    
    cat << EOF > "$TARGET_HOME/.tmux.conf"
# Custom tmux configuration by Kali-TH

# Set prefix key to Ctrl-a (instead of Ctrl-b)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Start window/pane indexing at 1 (instead of 0)
set -g base-index 1
setw -g pane-base-index 1

# Automatically renumber windows when one is closed
set -g renumber-windows on

# Enable 256 colors and true colors support
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Enable mouse support
set -g mouse on

# Status bar styling
set -g status-position bottom
set -g status-style bg=black,fg=$primary
set -g status-left-length 40
set -g status-left "#[fg=$secondary,bold] ㉿ #S #[fg=$primary,none]| "
set -g status-right-length 100
set -g status-right "#[fg=$success]%Y-%m-%d %H:%M #[fg=$primary]| #[fg=$secondary,bold]H4CK3R "

# Window title styling
set -g window-status-format "#[fg=$primary,none] #I:#W "
set -g window-status-current-format "#[fg=black,bg=$primary,bold] #I:#W "

# Pane borders
set -g pane-border-style fg=colour235
set -g pane-active-border-style fg=$primary
EOF
}

# Helper to write starship.toml based on active color configurations
write_starship_config() {
    local custom_name="$1"
    
    # Read active colors
    local primary="blue"
    local secondary="red"
    local success="green"
    
    if [ -f "$TARGET_HOME/.config/archify/colors.sh" ]; then
        source "$TARGET_HOME/.config/archify/colors.sh"
        primary="${ARCHIFY_PRIMARY_NAME:-blue}"
        secondary="${ARCHIFY_SECONDARY_NAME:-red}"
        success="${ARCHIFY_SUCCESS_NAME:-green}"
    fi
    
    mkdir -p "$TARGET_HOME/.config"
    cat << EOF > "$TARGET_HOME/.config/starship.toml"
# Custom Starship Config by H4CK3R - Matches Custom Theme Design
format = '''
[┌─\\[](bold $primary)\$username[㉿](bold $primary)\$hostname[\\]-\\[](bold $primary)\$directory[\\]](bold $primary)\$git_branch\$git_status
\$character'''

[username]
show_always = true
style_user = "bold $secondary"
style_root = "bold $secondary"
format = "[$custom_name](\$style)"

[hostname]
ssh_only = false
style = "bold $secondary"
format = "[KALI](\$style)"

[directory]
style = "bold $success"
format = "[\$path](\$style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bold $secondary"
format = '-\\[[git:\\(](bold $primary)\$symbol\$branch[\\)](bold $primary)\\]'

[git_status]
style = "bold $secondary"
format = "[\$all_status\$ahead_behind](\$style)"

[character]
success_symbol = "[└─╼ ](bold $primary)[❯❯❯](bold $secondary)  "
error_symbol = "[└─╼ ](bold $primary)[✗❯❯](bold $secondary)  "
EOF
}


# Setup Custom Tmux configuration
setup_tmux() {
    echo -e "${G}\n [*] Installing tmux...${RS}"
    $SUDO_CMD apt install -y tmux
    
    echo -e "${G} [*] Deploying custom .tmux.conf...${RS}"
    [ -f "$TARGET_HOME/.tmux.conf" ] && cp "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.tmux.conf.bak"
    write_tmux_conf
    
    adjust_ownership "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.tmux.conf.bak" ; echo -e "${G} [✓] tmux successfully configured!${RS}"
    sleep 2
    menu
}

# Choose Theme Color Palette Preset
choose_color_theme() {
    banner
    echo -e "\n ${C}─── Choose Theme Color Palette ───${RS}"
    printf "  ${DG}[${C}01${DG}]${W} Cyberpunk Neon (Magenta & Cyan)\n"
    printf "  ${DG}[${C}02${DG}]${W} Dracula (Purple & Green)\n"
    printf "  ${DG}[${C}03${DG}]${W} Nord (Cyan & Blue)\n"
    printf "  ${DG}[${C}04${DG}]${W} Gruvbox (Yellow & Red)\n"
    printf "  ${DG}[${C}05${DG}]${W} Kali-TH Default (Blue & Red)\n"
    printf "  ${DG}[${C}00${DG}]${R} Back to Main Menu\n"
    echo -e " ${DG}──────────────────────────────────────────────────${RS}"
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read theme_opt
    
    local c_sh="$TARGET_HOME/.config/archify/colors.sh"
    local c_fish="$TARGET_HOME/.config/archify/colors.fish"
    mkdir -p "$TARGET_HOME/.config/archify"
    
    case $theme_opt in
        1|01)
            # Cyberpunk Neon
            cat << 'EOF' > "$c_sh"
export ARCHIFY_PRIMARY='35'
export ARCHIFY_PRIMARY_NAME='magenta'
export ARCHIFY_SECONDARY='36'
export ARCHIFY_SECONDARY_NAME='cyan'
export ARCHIFY_SUCCESS='32'
export ARCHIFY_SUCCESS_NAME='green'
export ARCHIFY_ALERT='31'
export ARCHIFY_ALERT_NAME='red'
export ARCHIFY_WARN='33'
export ARCHIFY_WARN_NAME='yellow'
EOF
            cat << 'EOF' > "$c_fish"
set -gx ARCHIFY_PRIMARY magenta
set -gx ARCHIFY_SECONDARY cyan
set -gx ARCHIFY_SUCCESS green
set -gx ARCHIFY_ALERT red
set -gx ARCHIFY_WARN yellow
EOF
            ;;
        2|02)
            # Dracula
            cat << 'EOF' > "$c_sh"
export ARCHIFY_PRIMARY='35'
export ARCHIFY_PRIMARY_NAME='magenta'
export ARCHIFY_SECONDARY='32'
export ARCHIFY_SECONDARY_NAME='green'
export ARCHIFY_SUCCESS='36'
export ARCHIFY_SUCCESS_NAME='cyan'
export ARCHIFY_ALERT='31'
export ARCHIFY_ALERT_NAME='red'
export ARCHIFY_WARN='33'
export ARCHIFY_WARN_NAME='yellow'
EOF
            cat << 'EOF' > "$c_fish"
set -gx ARCHIFY_PRIMARY magenta
set -gx ARCHIFY_SECONDARY green
set -gx ARCHIFY_SUCCESS cyan
set -gx ARCHIFY_ALERT red
set -gx ARCHIFY_WARN yellow
EOF
            ;;
        3|03)
            # Nord
            cat << 'EOF' > "$c_sh"
export ARCHIFY_PRIMARY='36'
export ARCHIFY_PRIMARY_NAME='cyan'
export ARCHIFY_SECONDARY='34'
export ARCHIFY_SECONDARY_NAME='blue'
export ARCHIFY_SUCCESS='32'
export ARCHIFY_SUCCESS_NAME='green'
export ARCHIFY_ALERT='31'
export ARCHIFY_ALERT_NAME='red'
export ARCHIFY_WARN='33'
export ARCHIFY_WARN_NAME='yellow'
EOF
            cat << 'EOF' > "$c_fish"
set -gx ARCHIFY_PRIMARY cyan
set -gx ARCHIFY_SECONDARY blue
set -gx ARCHIFY_SUCCESS green
set -gx ARCHIFY_ALERT red
set -gx ARCHIFY_WARN yellow
EOF
            ;;
        4|04)
            # Gruvbox
            cat << 'EOF' > "$c_sh"
export ARCHIFY_PRIMARY='33'
export ARCHIFY_PRIMARY_NAME='yellow'
export ARCHIFY_SECONDARY='31'
export ARCHIFY_SECONDARY_NAME='red'
export ARCHIFY_SUCCESS='32'
export ARCHIFY_SUCCESS_NAME='green'
export ARCHIFY_ALERT='31'
export ARCHIFY_ALERT_NAME='red'
export ARCHIFY_WARN='33'
export ARCHIFY_WARN_NAME='yellow'
EOF
            cat << 'EOF' > "$c_fish"
set -gx ARCHIFY_PRIMARY yellow
set -gx ARCHIFY_SECONDARY red
set -gx ARCHIFY_SUCCESS green
set -gx ARCHIFY_ALERT red
set -gx ARCHIFY_WARN yellow
EOF
            ;;
        5|05)
            # Kali-TH Default (Blue & Red)
            cat << 'EOF' > "$c_sh"
export ARCHIFY_PRIMARY='34'
export ARCHIFY_PRIMARY_NAME='blue'
export ARCHIFY_SECONDARY='31'
export ARCHIFY_SECONDARY_NAME='red'
export ARCHIFY_SUCCESS='32'
export ARCHIFY_SUCCESS_NAME='green'
export ARCHIFY_ALERT='31'
export ARCHIFY_ALERT_NAME='red'
export ARCHIFY_WARN='33'
export ARCHIFY_WARN_NAME='yellow'
EOF
            cat << 'EOF' > "$c_fish"
set -gx ARCHIFY_PRIMARY blue
set -gx ARCHIFY_SECONDARY red
set -gx ARCHIFY_SUCCESS green
set -gx ARCHIFY_ALERT red
set -gx ARCHIFY_WARN yellow
EOF
            ;;
        0|00)
            menu
            return
            ;;
        *)
            wr
            return
            ;;
    esac
    
    # If tmux is configured, update the theme there too
    if [ -f "$TARGET_HOME/.tmux.conf" ]; then
        write_tmux_conf
        if command -v tmux &>/dev/null && tmux info &>/dev/null; then
            tmux source-file "$TARGET_HOME/.tmux.conf" 2>/dev/null || true
        fi
    fi
    
    # If Starship is configured, update the theme there too
    if [ -f "$TARGET_HOME/.config/starship.toml" ]; then
        local existing_name="H4CK3R"
        existing_name=$(grep -A 4 "^\[username\]" "$TARGET_HOME/.config/starship.toml" 2>/dev/null | grep "format =" | sed -E 's/.*format = "\[([^]]*)\]\(.*/\1/')
        existing_name=${existing_name:-H4CK3R}
        write_starship_config "$existing_name"
    fi
    
    adjust_ownership "$TARGET_HOME/.config/archify" "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.config/starship.toml" ; echo -e "${G} [✓] Color theme applied successfully! Reload your shell to see changes.${RS}"
    sleep 2
    menu
}

# Setup Atuin History Integration
setup_atuin() {
    echo -e "${G}\n [*] Installing Atuin shell history sync...${RS}"
    $SUDO_CMD apt update
    $SUDO_CMD apt install -y atuin
    
    echo -e "${G} [*] Injecting Atuin integration into user config files...${RS}"
    
    # Zsh configuration
    if [ -f "$TARGET_HOME/.zshrc" ]; then
        if ! grep -q "Atuin History Integration" "$TARGET_HOME/.zshrc"; then
            cat << 'EOF' >> "$TARGET_HOME/.zshrc"

# Atuin History Integration
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi
EOF
        fi
    fi
    
    # Bash configuration
    if [ -f "$TARGET_HOME/.bashrc" ]; then
        if ! grep -q "Atuin History Integration" "$TARGET_HOME/.bashrc"; then
            if grep -q "# Attach ble.sh" "$TARGET_HOME/.bashrc"; then
                sed -i '/# Attach ble.sh/i # Atuin History Integration\nif command -v atuin \&> \/dev\/null; then\n    eval "$(atuin init bash)"\nfi\n' "$TARGET_HOME/.bashrc"
            else
                cat << 'EOF' >> "$TARGET_HOME/.bashrc"

# Atuin History Integration
if command -v atuin &> /dev/null; then
    eval "$(atuin init bash)"
fi
EOF
            fi
        fi
    fi
    
    # Fish configuration
    if [ -f "$TARGET_HOME/.config/fish/config.fish" ]; then
        if ! grep -q "Atuin History Integration" "$TARGET_HOME/.config/fish/config.fish"; then
            cat << 'EOF' >> "$TARGET_HOME/.config/fish/config.fish"

# Atuin History Integration
if type -q atuin
    atuin init fish | source
end
EOF
        fi
    fi
    
    adjust_ownership "$TARGET_HOME/.zshrc" "$TARGET_HOME/.bashrc" "$TARGET_HOME/.config/fish" ; echo -e "${G} [✓] Atuin integration set up successfully!${RS}"
    sleep 2
    menu
}

# Setup Developer Tools (Neovim & Git)
setup_dev_tools() {
    banner
    echo -e "\n ${C}─── Developer Tools Configuration ───${RS}"
    printf "  ${DG}[${C}01${DG}]${W} Install & Configure Neovim (with optional LazyVim config)\n"
    printf "  ${DG}[${C}02${DG}]${W} Install & Configure Git Enhancements (diff-so-fancy)\n"
    printf "  ${DG}[${C}03${DG}]${W} Configure Both\n"
    printf "  ${DG}[${C}00${DG}]${R} Back to Main Menu\n"
    echo -e " ${DG}──────────────────────────────────────────────────${RS}"
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read dev_opt
    
    case $dev_opt in
        1|01)
            configure_nvim
            ;;
        2|02)
            configure_git
            ;;
        3|03)
            configure_nvim
            configure_git
            ;;
        0|00)
            menu
            return
            ;;
        *)
            wr
            return
            ;;
    esac
    
    adjust_ownership "$TARGET_HOME/.config/nvim" "$TARGET_HOME/.local/share/nvim" "$TARGET_HOME/.local/state/nvim" "$TARGET_HOME/.cache/nvim" ; echo -e "${G} [✓] Developer tools configured!${RS}"
    sleep 2
    menu
}

# Helper to configure Neovim
configure_nvim() {
    echo -e "${G}\n [*] Installing Neovim...${RS}"
    $SUDO_CMD apt install -y neovim
    
    read -p " Would you like to install the LazyVim theme starter config? [y/N]: " inst_lazyvim
    if [[ "$inst_lazyvim" =~ ^[Yy]$ ]]; then
        echo -e "${G} [*] Backing up existing Neovim configurations...${RS}"
        [ -d "$TARGET_HOME/.config/nvim" ] && mv "$TARGET_HOME/.config/nvim" "$HOME/.config/nvim.bak"
        [ -d "$TARGET_HOME/.local/share/nvim" ] && mv "$TARGET_HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak"
        [ -d "$TARGET_HOME/.local/state/nvim" ] && mv "$TARGET_HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak"
        [ -d "$TARGET_HOME/.cache/nvim" ] && mv "$TARGET_HOME/.cache/nvim" "$HOME/.cache/nvim.bak"
        
        echo -e "${G} [*] Cloning LazyVim starter config...${RS}"
        if [ "$TARGET_USER" != "$(whoami)" ]; then sudo -u "$TARGET_USER" git clone https://github.com/LazyVim/starter "$TARGET_HOME/.config/nvim"; else git clone https://github.com/LazyVim/starter "$TARGET_HOME/.config/nvim"; fi
        echo -e "${G} [✓] LazyVim config installed. Launch 'nvim' to initialize plugins.${RS}"
    fi
}

# Helper to configure Git
configure_git() {
    echo -e "${G}\n [*] Installing diff-so-fancy for beautiful git diffs...${RS}"
    $SUDO_CMD apt install -y diff-so-fancy
    
    echo -e "${G} [*] Configuring Git preferences (diff-so-fancy pager and colors)...${RS}"
    git config --global color.ui true
    if command -v diff-so-fancy &> /dev/null; then
        git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
        git config --global interactive.diffFilter "diff-so-fancy --patch"
        
        # Color styling compatible with diff-so-fancy
        git config --global color.diff-highlight.oldNormal "red bold"
        git config --global color.diff-highlight.oldHighlight "red bold 52"
        git config --global color.diff-highlight.newNormal "green bold"
        git config --global color.diff-highlight.newHighlight "green bold 22"
        
        git config --global color.diff.meta "11"
        git config --global color.diff.frag "magenta bold"
        git config --global color.diff.func "146 bold"
        git config --global color.diff.old "red bold"
        git config --global color.diff.new "green bold"
        git config --global color.diff.commit "yellow bold"
        git config --global color.diff.whitespace "red reverse"
    fi
    echo -e "${G} [✓] Git configurations applied successfully!${RS}"
}

# Install Nerd Fonts
install_nerd_fonts() {
    echo -e "${G}\n [*] Preparing to install Nerd Fonts...${RS}"
    FONT_DIR="$TARGET_HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    echo -e "${C} Choose font to install:${RS}"
    echo -e " ${B}[1]${G} JetBrains Mono Nerd Font (Recommended)"
    echo -e " ${B}[2]${G} Hack Nerd Font"
    echo -e " ${B}[3]${G} Fira Code Nerd Font"
    read -p " Select option [1-3]: " font_opt

    case $font_opt in
        2) 
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
            FONT_ZIP="Hack.zip"
            ;;
        3)
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
            FONT_ZIP="FiraCode.zip"
            ;;
        *)
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
            FONT_ZIP="JetBrainsMono.zip"
            ;;
    esac

    echo -e "${G} [*] Downloading font archive...${RS}"
    wget -O "/tmp/$FONT_ZIP" "$FONT_URL"
    
    echo -e "${G} [*] Extracting to $FONT_DIR...${RS}"
    unzip -o "/tmp/$FONT_ZIP" -d "$FONT_DIR"
    rm "/tmp/$FONT_ZIP"
    
    echo -e "${G} [*] Rebuilding font cache...${RS}"
    fc-cache -fv &>/dev/null || $SUDO_CMD fc-cache -fv &>/dev/null

    adjust_ownership "$TARGET_HOME/.local/share/fonts" ; echo -e "${G} [✓] Nerd Font files installed!${RS}"
    
    # Detect terminal emulator and give instructions
    TERM_EMULATOR="generic"
    if [ -n "$QTERMINAL_IPC" ]; then
        TERM_EMULATOR="qterminal"
    elif [ -n "$GNOME_TERMINAL_SCREEN" ]; then
        TERM_EMULATOR="gnome-terminal"
    elif [ "$TERM" = "xterm-kitty" ]; then
        TERM_EMULATOR="kitty"
    elif [ "$TERM" = "alacritty" ]; then
        TERM_EMULATOR="alacritty"
    fi

    echo -e "\n${Y} [!] HOW TO SET THE FONT IN YOUR TERMINAL:${RS}"
    case "$TERM_EMULATOR" in
        "qterminal")
            echo -e "   1. Click ${C}File${RS} in the menu bar."
            echo -e "   2. Go to ${C}Preferences${RS} -> ${C}Appearance${RS}."
            echo -e "   3. Click ${C}Change${RS} next to 'Font'."
            echo -e "   4. Choose ${G}JetBrainsMono Nerd Font${RS} (or Hack Nerd Font) and Save."
            ;;
        "gnome-terminal")
            echo -e "   1. Click the ${C}Menu (3 bars)${RS} in the top-right."
            echo -e "   2. Go to ${C}Preferences${RS}."
            echo -e "   3. Under Profiles, click your profile (e.g. Unnamed)."
            echo -e "   4. Check ${C}Custom font${RS}."
            echo -e "   5. Choose ${G}JetBrainsMono Nerd Font${RS} and click Select."
            ;;
        "kitty")
            echo -e "   Add this to your ${C}~/.config/kitty/kitty.conf${RS}:"
            echo -e "   ${G}font_family JetBrainsMono Nerd Font${RS}"
            ;;
        "alacritty")
            echo -e "   Update your ${C}~/.config/alacritty/alacritty.toml${RS}:"
            echo -e "   ${G}[font.normal]"
            echo -e "   family = \"JetBrainsMono Nerd Font\"${RS}"
            ;;
        *)
            echo -e "   1. Open your terminal emulator's ${C}Settings/Preferences${RS}."
            echo -e "   2. Navigate to ${C}Appearance / Font${RS} settings."
            echo -e "   3. Change the font to ${G}JetBrainsMono Nerd Font${RS}."
            ;;
    esac
    echo -e ""
    read -n 1 -s -r -p " Press any key to return to menu... "
    menu
}

# Setup Starship prompt
install_starship() {
    echo -e "${G}\n [*] Checking Starship Prompt...${RS}"
    if ! command -v starship &> /dev/null; then
        echo -e "${G} [*] Installing Starship prompt using installer script...${RS}"
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    echo -e "${G} [*] Deploying Starship configuration...${RS}"
    write_starship_config "$custom_name"

    echo -e "${G} [✓] Starship prompt configured!${RS}"
    
    # Auto-activate Starship in .zshrc
    if [ -f "$TARGET_HOME/.zshrc" ]; then
        if ! grep -q "starship init zsh" "$TARGET_HOME/.zshrc"; then
            echo -e "${G} [*] Activating Starship in your .zshrc...${RS}"
            echo 'eval "$(starship init zsh)"' >> "$TARGET_HOME/.zshrc"
        fi
    fi

    # Auto-activate Starship in .bashrc
    if [ -f "$TARGET_HOME/.bashrc" ]; then
        if ! grep -q "starship init bash" "$TARGET_HOME/.bashrc"; then
            echo -e "${G} [*] Activating Starship in your .bashrc...${RS}"
            echo 'eval "$(starship init bash)"' >> "$TARGET_HOME/.bashrc"
        fi
    fi

    # Auto-activate Starship in config.fish
    if [ -f "$TARGET_HOME/.config/fish/config.fish" ]; then
        if ! grep -q "starship init fish" "$TARGET_HOME/.config/fish/config.fish"; then
            echo -e "${G} [*] Activating Starship in your config.fish...${RS}"
            echo 'starship init fish | source' >> "$TARGET_HOME/.config/fish/config.fish"
        fi
    fi

    adjust_ownership "$TARGET_HOME/.config/starship.toml" "$TARGET_HOME/.zshrc" "$TARGET_HOME/.bashrc" "$TARGET_HOME/.config/fish" ; echo -e "${G} [✓] Starship successfully enabled and configured! Reload your shell to see it.${RS}"
    sleep 4
    menu
}

# Reset Configurations
reset_config() {
    echo -e "${Y}\n [!] Warning: This will back up and reset your current shell configuration files!${RS}"
    read -p " Proceed? [y/N]: " confirm_reset
    if [[ "$confirm_reset" =~ ^[Yy]$ ]]; then
        echo -e "${G} [*] Backing up and resetting .zshrc, .bashrc, and config.fish...${RS}"
        [ -f "$TARGET_HOME/.zshrc" ] && cp "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zshrc.bak" && rm "$TARGET_HOME/.zshrc"
        [ -f "$TARGET_HOME/.bashrc" ] && cp "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak" && rm "$TARGET_HOME/.bashrc"
        [ -f "$TARGET_HOME/.config/fish/config.fish" ] && cp "$TARGET_HOME/.config/fish/config.fish" "$TARGET_HOME/.config/fish/config.fish.bak" && rm "$TARGET_HOME/.config/fish/config.fish"
        
        # Simple default configs
        echo -e "PROMPT='%F{cyan}%n@%m %F{blue}%~ %F{yellow}❯ %f'" > "$TARGET_HOME/.zshrc"
        echo -e "PS1='[\u@\h \W]\$ '" > "$TARGET_HOME/.bashrc"
        mkdir -p "$TARGET_HOME/.config/fish"
        echo -e "set fish_greeting\nfunction fish_prompt\n    set_color cyan\n    printf '%s ' (prompt_pwd)\n    set_color normal\nend" > "$TARGET_HOME/.config/fish/config.fish"
        
        adjust_ownership "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zshrc.bak" "$TARGET_HOME/.bashrc" "$TARGET_HOME/.bashrc.bak" "$TARGET_HOME/.config/fish"
        
        echo -e "${G} [✓] Configs reset. Backups saved as .zshrc.bak / .bashrc.bak / config.fish.bak${RS}"
    fi
    sleep 2
    menu
}

# Customize Welcome Banner
customize_banner() {
    banner
    echo -e "\n ${C}─── Custom Welcome Banner Setup ───${RS}"
    printf "  ${DG}[${C}01${DG}]${W} Fastfetch Banner (Default)\n"
    printf "  ${DG}[${C}02${DG}]${W} Custom Text Figlet Banner\n"
    printf "  ${DG}[${C}03${DG}]${W} Simple Kali ASCII Art\n"
    printf "  ${DG}[${C}04${DG}]${W} Disable Welcome Banner\n"
    printf "  ${DG}[${C}00${DG}]${R} Back to Main Menu\n"
    echo -e " ${DG}──────────────────────────────────────────────────${RS}"
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read banner_opt
    
    local banner_script="$TARGET_HOME/.archify-banner.sh"
    
    case $banner_opt in
        1|01)
            echo -e "${G} [*] Setting up Fastfetch Welcome Banner...${RS}"
            if ! command -v fastfetch &>/dev/null; then
                echo -e "${Y} [!] Fastfetch is not installed. Installing...${RS}"
                $SUDO_CMD apt install -y fastfetch
            fi
            
            mkdir -p "$TARGET_HOME/.config/fastfetch"
            if [ ! -f "$TARGET_HOME/.config/fastfetch/config.jsonc" ]; then
                cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$TARGET_HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true
            fi
            
            cat << 'EOF' > "$banner_script"
#!/usr/bin/env bash
clear
if command -v fastfetch &>/dev/null; then
    if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        fastfetch --config "$HOME/.config/fastfetch/config.jsonc"
    else
        fastfetch
    fi
else
    echo -e "\033[1;34m  / \__\033[0m"
    echo -e "\033[1;34m (    @\___ \033[1;37m  Kali Linux\033[0m"
    echo -e "\033[1;34m /         O\033[0m"
    echo -e "\033[1;34m/   (_____/\033[0m"
fi
EOF
            chmod +x "$banner_script"
            adjust_ownership "$banner_script" "$TARGET_HOME/.config/fastfetch"
            echo -e "${G} [✓] Fastfetch Welcome Banner configured!${RS}"
            ;;
        2|02)
            echo -ne "${C} Enter Custom Banner Text [Default: Kali-TH] ❯ ${RS}"
            read banner_text
            banner_text=${banner_text:-Kali-TH}
            
            echo -e "\n ${C}─── Choose Figlet Font ───${RS}"
            printf "  ${DG}[${C}1${DG}]${W} Standard\n"
            printf "  ${DG}[${C}2${DG}]${W} Slant\n"
            printf "  ${DG}[${C}3${DG}]${W} Shadow\n"
            printf "  ${DG}[${C}4${DG}]${W} Doom\n"
            printf "  ${DG}[${C}5${DG}]${W} Block\n"
            printf "  ${DG}[${C}6${DG}]${W} ANSI Shadow\n"
            echo -e " ${DG}──────────────────────────${RS}"
            echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
            read font_choice
            
            local font_name="standard"
            case $font_choice in
                2) font_name="slant" ;;
                3) font_name="shadow" ;;
                4) font_name="doom" ;;
                5) font_name="block" ;;
                6) font_name="ANSI Shadow" ;;
                *) font_name="standard" ;;
            esac
            
            echo -e "\n ${C}─── Choose Color Style ───${RS}"
            printf "  ${DG}[${C}1${DG}]${W} Rainbow (lolcat)\n"
            printf "  ${DG}[${C}2${DG}]${W} Cyberpunk (Cyan)\n"
            printf "  ${DG}[${C}3${DG}]${W} Matrix (Green)\n"
            printf "  ${DG}[${C}4${DG}]${W} Plain (White)\n"
            echo -e " ${DG}──────────────────────────${RS}"
            echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
            read color_choice
            
            local color_code=""
            if [ "$color_choice" = "2" ]; then
                color_code="\\\\033[1;36m"
            elif [ "$color_choice" = "3" ]; then
                color_code="\\\\033[1;32m"
            elif [ "$color_choice" = "4" ]; then
                color_code="\\\\033[1;37m"
            fi
            
            read -p " Include System Info Box? [y/N]: " include_info
            
            local figlet_dir="$TARGET_HOME/.local/share/figlet"
            mkdir -p "$figlet_dir"
            
            if ! command -v figlet &>/dev/null; then
                echo -e "${Y} [!] Figlet is not installed. Installing...${RS}"
                $SUDO_CMD apt install -y figlet
            fi
            
            if [ "$color_choice" = "1" ] && ! command -v lolcat &>/dev/null; then
                echo -e "${Y} [!] Lolcat is not installed. Installing...${RS}"
                $SUDO_CMD apt install -y lolcat || gem install lolcat
            fi
            
            local font_file="$figlet_dir/$font_name.flf"
            # Delete corrupted/404 cached font files (valid figlet files start with 'flf2a')
            if [ -f "$font_file" ] && ! head -n 1 "$font_file" 2>/dev/null | grep -q "^flf2a"; then
                rm -f "$font_file"
            fi
            
            if [ ! -f "$font_file" ]; then
                echo -e "${Y} [*] Downloading $font_name font...${RS}"
                if [ "$font_name" = "ANSI Shadow" ]; then
                    curl -s -L "https://raw.githubusercontent.com/h4ck3r0/Termux-os/master/.object/ANSI%20Shadow.flf" -o "$font_file"
                else
                    curl -s -L "https://raw.githubusercontent.com/phracker/figlet-fonts/master/$font_name.flf" -o "$font_file"
                fi
                if [ ! -f "$font_file" ] || [ ! -s "$font_file" ]; then
                    echo -e "${R} [!] Failed to download $font_name font. Using default standard font.${RS}"
                    font_file=""
                fi
            fi
            
            cat << EOF > "$banner_script"
#!/usr/bin/env bash
clear
BOX_WIDTH=56
cyan='\\033[1;36m'
reset='\\033[0m'

print_center() {
    local text="\$1"
    local len=\${#text}
    local space_len=\$(( (BOX_WIDTH - 2 - len) / 2 ))
    printf "\${cyan}║%*s\${reset}%s\${cyan}%*s║\${reset}\\n" \$space_len "" "\$text" \$(( BOX_WIDTH - 2 - len - space_len )) ""
}

draw_line() {
    local char=\$1
    local end=\$2
    printf "\${cyan}%s" "\$char"
    for ((i=0; i<BOX_WIDTH-2; i++)); do
        printf "═"
    done
    printf "%s\${reset}\\n" "\$end"
}
EOF
            
            local fig_cmd="figlet"
            if [ -n "$font_file" ]; then
                fig_cmd="figlet -d \"$figlet_dir\" -f \"$font_name\""
            fi
            
            if [ "$color_choice" = "1" ]; then
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null | lolcat 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
            elif [ -n "$color_code" ]; then
                echo "echo -e \"$color_code\"" >> "$banner_script"
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
                echo "echo -e \"\\\\033[0m\"" >> "$banner_script"
            else
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
            fi
            
            if [[ "$include_info" =~ ^[Yy]$ ]]; then
                cat << 'EOF' >> "$banner_script"
echo ""
draw_line '╔' '╗'
print_center ""
print_center "SYSTEM: ONLINE  |  USER: $(whoami)"
if command -v free &>/dev/null; then
    mem_info=$(free -m | awk '/Mem:/ {print "RAM: " $3 "MB / " $2 "MB"}')
    [ -n "$mem_info" ] && print_center "$mem_info"
fi
print_center "KERNEL: $(uname -r)"
print_center ""
draw_line '╚' '╝'
EOF
            fi
            
            chmod +x "$banner_script"
            adjust_ownership "$banner_script" "$figlet_dir"
            echo -e "${G} [✓] Custom Text figlet Banner configured!${RS}"
            ;;
        3|03)
            echo -e "${G} [*] Setting up Simple Kali ASCII Art...${RS}"
            cat << 'EOF' > "$banner_script"
#!/usr/bin/env bash
clear
R='\033[1;31m'
W='\033[1;37m'
G='\033[1;32m'
B='\033[1;34m'
RS='\033[0m'

echo -e "${B}  / \__${RS}"
echo -e "${B} (    @\___ ${W}  Kali Linux${RS}"
echo -e "${B} /         O${G}  Kernel: $(uname -r)${RS}"
echo -e "${B}/   (_____/${B}  Uptime: $(uptime -p)${RS}"
echo ""
EOF
            chmod +x "$banner_script"
            adjust_ownership "$banner_script"
            echo -e "${G} [✓] Simple Kali ASCII Art configured!${RS}"
            ;;
        4|04)
            echo -e "${Y} [*] Disabling Welcome Banner...${RS}"
            echo -e "#!/usr/bin/env bash\n# Welcome Banner Disabled" > "$banner_script"
            chmod +x "$banner_script"
            adjust_ownership "$banner_script"
            echo -e "${G} [✓] Welcome Banner disabled!${RS}"
            ;;
        0|00)
            menu
            return
            ;;
        *)
            echo -e "${R} [!] Invalid Option Selected!${RS}"
            sleep 1
            customize_banner
            return
            ;;
    esac
    
    # Fix any existing broken banner references
    for rc in "$TARGET_HOME/.bashrc" "$TARGET_HOME/.zshrc" "$TARGET_HOME/.config/fish/config.fish"; do
        if [ -f "$rc" ]; then
            sed -i 's/\$TARGET_HOME\/\.archify-banner\.sh/\$HOME\/\.archify-banner\.sh/g' "$rc"
        fi
    done

    # Ensure all configurations source/run the banner
    if [ -f "$TARGET_HOME/.bashrc" ] && ! grep -q ".archify-banner.sh" "$TARGET_HOME/.bashrc"; then
        echo -e "\n# Kali-TH Welcome Banner\nif [ -f \"\$HOME/.archify-banner.sh\" ]; then\n    bash \"\$HOME/.archify-banner.sh\"\nfi" >> "$TARGET_HOME/.bashrc"
    fi
    if [ -f "$TARGET_HOME/.zshrc" ] && ! grep -q ".archify-banner.sh" "$TARGET_HOME/.zshrc"; then
        echo -e "\n# Kali-TH Welcome Banner\nif [ -f \"\$HOME/.archify-banner.sh\" ]; then\n    bash \"\$HOME/.archify-banner.sh\"\nfi" >> "$TARGET_HOME/.zshrc"
    fi
    if [ -f "$TARGET_HOME/.config/fish/config.fish" ] && ! grep -q ".archify-banner.sh" "$TARGET_HOME/.config/fish/config.fish"; then
        echo -e "\n# Kali-TH Welcome Banner\nif test -f \"\$HOME/.archify-banner.sh\"\n    bash \"\$HOME/.archify-banner.sh\"\nend" >> "$TARGET_HOME/.config/fish/config.fish"
    fi
    
    sleep 2
    menu
}

# Update Tool
update_tool() {
    echo -e "${Y}\n [!] Updating customizer tool...${RS}"
    if [ -d "$SCRIPT_DIR/.git" ]; then
        cd "$SCRIPT_DIR"
        git fetch --all
        git reset --hard origin/main || git reset --hard origin/master || true
        
        if git pull; then
            echo -e "${G} [✓] Update complete! Reloading script...${RS}"
            sleep 2
            # Use absolute path to the script to prevent failure after CWD changes
            exec bash "$SCRIPT_DIR/${0##*/}"
        else
            echo -e "${R} [!] Update failed. Please check network/git.${RS}"
            sleep 2
        fi
    else
        echo -e "${R} [!] Git repository not found. Please manually git pull to update.${RS}"
        sleep 2
    fi
}

# Interactive Menu
menu() {
    banner
    echo -e "\n ${C}┌──────────────────────────────────────────────────┐"
    echo -e " ${C}│ ${W}           MAIN MENU - KALI-TH CUSTOMIZER        ${C}│"
    echo -e " ${C}└──────────────────────────────────────────────────┘${RS}"

    echo -e "\n ${C}─── Core Setup & Shell Themes ───${RS}"
    printf "  ${DG}[${C}01${DG}]${W} Install Core Dependencies\n"
    printf "  ${DG}[${C}02${DG}]${W} Apply Custom Zsh Theme & Fastfetch\n"
    printf "  ${DG}[${C}03${DG}]${W} Apply Custom Bash Theme & Fastfetch\n"
    printf "  ${DG}[${C}04${DG}]${W} Apply Custom Fish Theme & Fastfetch\n"
    printf "  ${DG}[${C}05${DG}]${W} Enable Plugins (Zsh, Bash, Fish)\n"

    echo -e "\n ${C}─── Shell Customization & Styling ───${RS}"
    printf "  ${DG}[${C}06${DG}]${W} Install Custom Nerd Fonts\n"
    printf "  ${DG}[${C}07${DG}]${W} Install Starship Prompt Preset\n"
    printf "  ${DG}[${C}08${DG}]${W} Customize Welcome Banner\n"
    printf "  ${DG}[${C}11${DG}]${W} Choose Theme Color Palette\n"

    echo -e "\n ${C}─── CLI Utilities & Dev Tools ───${RS}"
    printf "  ${DG}[${C}09${DG}]${W} Install Modern CLI Utilities (eza, bat, zoxide, etc.)\n"
    printf "  ${DG}[${C}10${DG}]${W} Customize Tmux Multiplexer\n"
    printf "  ${DG}[${C}12${DG}]${W} Enable Unified Command History (Atuin)\n"
    printf "  ${DG}[${C}13${DG}]${W} Configure Dev Tools (Neovim & Git)\n"

    echo -e "\n ${C}─── System Maintenance ───${RS}"
    printf "  ${DG}[${C}14${DG}]${Y} Reset Shell Configuration\n"
    printf "  ${DG}[${C}00${DG}]${R} Exit Script\n"

    echo -e ""
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read opt
    case $opt in
        1|01) install_packages ;;
        2|02) apply_zsh_theme ;;
        3|03) apply_bash_theme ;;
        4|04) apply_fish_theme ;;
        5|05) apply_plugins ;;
        6|06) install_nerd_fonts ;;
        7|07) install_starship ;;
        8|08) customize_banner ;;
        9|09) install_modern_cli ;;
        10) setup_tmux ;;
        11) choose_color_theme ;;
        12) setup_atuin ;;
        13) setup_dev_tools ;;
        14|14) reset_config ;;
        0|00) exit ;;
        *) wr ;;
    esac
}

# Check for updates on startup
check_for_updates() {
    if [ -d "$SCRIPT_DIR/.git" ] && command -v git &>/dev/null; then
        echo -e "${G} [*] Checking for updates...${RS}"
        # Timeout after 3 seconds to avoid hanging if user is offline
        timeout 3 git fetch --quiet &>/dev/null
        
        LOCAL=$(git rev-parse HEAD 2>/dev/null)
        UPSTREAM=$(git rev-parse @{u} 2>/dev/null)
        
        if [ "$LOCAL" != "$UPSTREAM" ] && [ -n "$UPSTREAM" ]; then
            echo -e "${Y}\n [!] A new update is available for this tool!${RS}"
            read -p " Do you want to update now? [y/N]: " confirm_update
            if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
                update_tool
            fi
        fi
    fi
}

# Entry Point
check_kali
check_for_updates
menu
