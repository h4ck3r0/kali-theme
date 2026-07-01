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

    echo -e "${G} [✓] Nerd Font installed! Set your terminal font in your emulator settings.${RS}"
    sleep 3
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
# Custom Starship Config by H4CK3R
format = """
[░▒▓](#a3aed2)\
[ ㉿ ](bg:#a3aed2 fg:#090d16)\
[](deno_blue)\
$directory\
[](fg:#e3e5e5 bg:#769ff0)\
$git_branch\
$git_status\
[](fg:#769ff0 bg:#394260)\
$character\
"""

[directory]
style = "bg:#e3e5e5 fg:#090d16"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bg:#769ff0 fg:#090d16"
format = "[[ $symbol$branch ]($style)]"

[git_status]
style = "bg:#769ff0 fg:#090d16"
format = "[[$all_status$ahead_behind ]($style)]"

[character]
success_symbol = "[ ❯ ](bold fg:#769ff0 bg:#394260)"
error_symbol = "[ ✗ ](bold fg:#e06c75 bg:#394260)"
EOF

    echo -e "${G} [✓] Starship prompt configured! To activate, add this to your shell RC file:${RS}"
    echo -e "     Zsh  -> ${C}eval \"\$(starship init zsh)\"${RS}"
    echo -e "     Bash -> ${C}eval \"\$(starship init bash)\"${RS}"
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
        0|00) exit ;;
        *) wr ;;
    esac
}

# Entry Point
check_kali
menu
