#!/usr/bin/env bash

# Kali Linux Shell Customizer (Kali-TH)
# Created by Antigravity / Raj Aryan (H4CK3R)

# Color variables
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;93m'
B='\033[1;34m'
C='\033[1;36m'
W='\033[1;97m'
RS='\033[0m'

clear
SUDO_CMD=$(command -v sudo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    
    echo -e "${G} [*] Installing core tools (zsh, fastfetch, figlet, toilet, git, wget, curl, unzip, ruby)...${RS}"
    $SUDO_CMD apt install -y zsh fastfetch figlet toilet git wget curl unzip ruby
    
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
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        read -p " Oh My Zsh is not installed. Install it now? [y/N]: " inst_omz
        if [[ "$inst_omz" =~ ^[Yy]$ ]]; then
            echo -e "${G} [*] Downloading & installing Oh My Zsh (unattended)...${RS}"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi
    fi

    # Deploy Theme File
    echo -e "${G} [*] Copying theme file to Zsh directory...${RS}"
    OMZ_THEMES="$HOME/.oh-my-zsh/themes"
    STANDALONE_THEMES="$HOME/.zsh/themes"
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        mkdir -p "$OMZ_THEMES"
        cp "$SCRIPT_DIR/.object/.h4Ck3r.zsh-theme" "$OMZ_THEMES/h4Ck3r.zsh-theme"
    fi
    mkdir -p "$STANDALONE_THEMES"
    cp "$SCRIPT_DIR/.object/.h4Ck3r.zsh-theme" "$STANDALONE_THEMES/h4Ck3r.zsh-theme"

    # Set up Config
    echo -e "${G} [*] Deploying custom .zshrc...${RS}"
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.zshrc_template" > "$HOME/.zshrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */zsh ]]; then
        read -p " Change default shell to Zsh? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v zsh)" "$USER"
            echo -e "${G} [✓] Shell changed to Zsh. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

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
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.bashrc_template" > "$HOME/.bashrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

    echo -e "${G} [✓] Bash theme applied successfully! Run 'source ~/.bashrc' to apply.${RS}"
    sleep 2
    menu
}

# Download & Setup Plugins
apply_plugins() {
    echo -e "${G}\n [*] Setting up autosuggestions and syntax highlighting...${RS}"
    
    # Try system packages first
    echo -e "${G} [*] Installing plugin system packages if available...${RS}"
    $SUDO_CMD apt install -y zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null
    
    # Backup setup: Clone to user directories
    ZSH_PLUGINS_DIR="$HOME/.zsh"
    mkdir -p "$ZSH_PLUGINS_DIR"

    # Syntax Highlighting
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
        echo -e "${G} [*] Cloning zsh-syntax-highlighting...${RS}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
    else
        echo -e "${G} [*] Updating zsh-syntax-highlighting...${RS}"
        cd "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" && git pull && cd "$SCRIPT_DIR"
    fi

    # Autosuggestions
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
        echo -e "${G} [*] Cloning zsh-autosuggestions...${RS}"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
    else
        echo -e "${G} [*] Updating zsh-autosuggestions...${RS}"
        cd "$ZSH_PLUGINS_DIR/zsh-autosuggestions" && git pull && cd "$SCRIPT_DIR"
    fi

    echo -e "${G} [✓] Plugins ready! Reload Zsh to verify.${RS}"
    sleep 2
    menu
}

# Install Nerd Fonts
install_nerd_fonts() {
    echo -e "${G}\n [*] Preparing to install Nerd Fonts...${RS}"
    FONT_DIR="$HOME/.local/share/fonts"
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

    echo -e "${G} [✓] Nerd Font files installed!${RS}"
    
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

    echo -e "${G} [*] Deploying Starship configuration...${RS}"
    mkdir -p "$HOME/.config"
    cat << 'EOF' > "$HOME/.config/starship.toml"
# Custom Starship Config by H4CK3R - Matches Custom Theme Design
format = '''
[┌─\[](bold blue)[㉿ ](bold red)$username[@](bold blue)$hostname[\]-\[](bold blue)$directory[\]](bold blue)$git_branch$git_status
$character'''

[username]
show_always = true
style_user = "bold white"
format = "$user"

[hostname]
ssh_only = false
style = "bold red"
format = "$hostname"

[directory]
style = "bold green"
format = "$path"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bold red"
format = '-\[[git:\(](bold blue)$symbol$branch[\)](bold blue)\]'

[git_status]
style = "bold red"
format = "[$all_status$ahead_behind]($style)"

[character]
success_symbol = "[└─╼ ](bold blue)[❯❯❯](bold cyan) "
error_symbol = "[└─╼ ](bold blue)[✗❯❯](bold red) "
EOF

    echo -e "${G} [✓] Starship prompt configured!${RS}"
    
    # Auto-activate Starship in .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "starship init zsh" "$HOME/.zshrc"; then
            echo -e "${G} [*] Activating Starship in your .zshrc...${RS}"
            echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
        fi
    fi

    # Auto-activate Starship in .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "starship init bash" "$HOME/.bashrc"; then
            echo -e "${G} [*] Activating Starship in your .bashrc...${RS}"
            echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        fi
    fi

    echo -e "${G} [✓] Starship successfully enabled and configured! Reload your shell (e.g. run 'zsh') to see it.${RS}"
    sleep 4
    menu
}

# Reset Configurations
reset_config() {
    echo -e "${Y}\n [!] Warning: This will back up and reset your current shell configuration files!${RS}"
    read -p " Proceed? [y/N]: " confirm_reset
    if [[ "$confirm_reset" =~ ^[Yy]$ ]]; then
        echo -e "${G} [*] Backing up and resetting .zshrc and .bashrc...${RS}"
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak" && rm "$HOME/.zshrc"
        [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.bak" && rm "$HOME/.bashrc"
        
        # Simple default configs
        echo -e "PROMPT='%F{cyan}%n@%m %F{blue}%~ %F{yellow}❯ %f'" > "$HOME/.zshrc"
        echo -e "PS1='[\u@\h \W]\$ '" > "$HOME/.bashrc"
        
        echo -e "${G} [✓] Configs reset. Backups saved as .zshrc.bak / .bashrc.bak${RS}"
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
        git pull
    else
        echo -e "${R} [!] Git repository not found. Please manually git pull to update.${RS}"
    fi
    echo -e "${G} [✓] Update complete! Reloading script...${RS}"
    sleep 2
    exec bash "$0"
}

# Interactive Menu
menu() {
    banner
    echo -e "\n ${B}Select an option:${RS}\n"
    printf " ${B}[${W}01${B}]${G} Install Core Dependencies\n"
    printf " ${B}[${W}02${B}]${G} Apply Custom Zsh Theme & Fastfetch\n"
    printf " ${B}[${W}03${B}]${G} Apply Custom Bash Theme & Fastfetch\n"
    printf " ${B}[${W}04${B}]${G} Enable Plugins (Auto-Suggestions/Syntax)\n"
    printf " ${B}[${W}05${B}]${C} Install Custom Nerd Fonts\n"
    printf " ${B}[${W}06${B}]${C} Install Starship Prompt Preset\n"
    printf " ${B}[${W}07${B}]${Y} Reset Shell Configuration\n"
    printf " ${B}[${W}08${B}]${C} Update Customizer Tool\n"
    printf " ${B}[${W}00${B}]${R} Exit Script\n"
    echo -e ""
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read opt
    case $opt in
        1|01) install_packages ;;
        2|02) apply_zsh_theme ;;
        3|03) apply_bash_theme ;;
        4|04) apply_plugins ;;
        5|05) install_nerd_fonts ;;
        6|06) install_starship ;;
        7|07) reset_config ;;
        8|08) update_tool ;;
        0|00) exit ;;
        *) wr ;;
    esac
}

# Entry Point
check_kali
menu

