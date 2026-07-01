#!/bin/bash

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

banner() {
    clear
    figlet -f standard "Kali-TH" | lolcat
    echo -e "${B} ┌──────────────────────────────────────────────────┐"
    echo -e "${B} │ ${W}Coder  : ${C}Raj Aryan ${B}│ ${W}YouTube : ${G}H4Ck3R ${B}        │"
    echo -e "${B} │ ${W}Version: ${Y}3.0       ${B}│ ${W}Target  : ${R}Kali Linux ${B}    │"
    echo -e "${B} └──────────────────────────────────────────────────┘${RS}"
}

wr() {
    echo -e "${R}\n [!] Invalid Input!${RS}"
    sleep 1
    menu
}

1line() {
    $SUDO_CMD apt update && $SUDO_CMD apt upgrade -y
    $SUDO_CMD apt install zsh ruby wget curl git figlet toilet -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    cd "$SCRIPT_DIR" && bash os.sh
}

2line() {
    [ -d "$SCRIPT_DIR/.object" ] && cd "$SCRIPT_DIR/.object" && bash .1.sh
    $SUDO_CMD chsh -s $(command -v zsh) $USER
    sleep 2
    cd "$SCRIPT_DIR" && bash os.sh
}

3line() {
    [ -d "$SCRIPT_DIR/.object" ] && cd "$SCRIPT_DIR/.object" && bash .2.sh
    sleep 2
    cd "$SCRIPT_DIR" && bash os.sh
}

4line() {
    rm -rf "$HOME/.zshrc"
    [ -f "$SCRIPT_DIR/.object/.zshrc" ] && cp "$SCRIPT_DIR/.object/.zshrc" "$HOME/.zshrc"
    sleep 2
    cd "$SCRIPT_DIR" && bash os.sh
}

5line() {
    echo -e "${Y}\n [!] Updating Kali-TH script...${RS}"
    if [ -d "$SCRIPT_DIR/.git" ]; then
        cd "$SCRIPT_DIR"
        git fetch --all
        git reset --hard origin/main || git reset --hard origin/master || true
        git pull
    else
        PARENT_DIR="$(dirname "$SCRIPT_DIR")"
        DIR_NAME="$(basename "$SCRIPT_DIR")"
        GIT_URL=$(git config --get remote.origin.url 2>/dev/null || echo "https://github.com/h4ck3r0/kali-theme")
        cd "$PARENT_DIR"
        rm -rf "$DIR_NAME"
        git clone "$GIT_URL" "$DIR_NAME"
    fi
    cd "$SCRIPT_DIR" && bash os.sh
}

menu() {
    banner
    echo -e "\n ${B}Select an option:${RS}\n"
    printf " ${B}[${W}01${B}]${G} Full Environment Setup\n"
    printf " ${B}[${W}02${B}]${G} Apply Custom Zsh Theme\n"
    printf " ${B}[${W}03${B}]${G} Enable Plugins (Highlight/Suggest)\n"
    printf " ${B}[${W}04${B}]${Y} Reset Shell Configuration\n"
    printf " ${B}[${W}05${B}]${C} Update Kali-TH Script\n"
    printf " ${B}[${W}00${B}]${R} Exit Script\n"
    echo -e ""
    echo -ne "${B} kali-th${W}@${R}root${W}:${C}~${RS}# "
    read a
    case $a in
        1|01) 1line ;;
        2|02) 2line ;;
        3|03) 3line ;;
        4|04) 4line ;;
        5|05) 5line ;;
        0|00) exit ;;
        *) wr ;;
    esac
}

if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
    cd "$SCRIPT_DIR" 2>/dev/null
fi
menu
