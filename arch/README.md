<p align="center">
<a href="https://github.com/h4ck3r0"><img title="Language" src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg?v=103&style=flat-square"></a>
<a href="https://github.com/h4ck3r0"><img title="Platform" src="https://img.shields.io/badge/Platform-Arch%20Linux-blue?style=flat-square"></a>
</p>

# Arch Linux Shell Customizer (Archify)

Welcome to the **Arch Linux** adaptation of the Kali Shell Theme Installer! This tool provides an interactive menu-driven script to customize your Arch terminal using Zsh, Bash, Fastfetch, Starship, custom Nerd Fonts, and syntax-highlighting plugins.

---

## Features

- **Package Installer**: Installs standard tools (`zsh`, `git`, `lolcat`, `figlet`, `toilet`, `unzip`, `fastfetch`) using `pacman`.
- **AUR Helper Integration**: Detects and offers to automatically install `yay` if no AUR helper is present.
- **Custom Zsh & Bash Themes**: Deploys professional twin-line prompt designs featuring Arch branding and styled colors.
- **Fastfetch Presets**: Modern JSONC configuration that prints a beautiful Arch logo with customized information panels and borders.
- **Nerd Fonts Installer**: Interactive option to download and install popular developer Nerd Fonts (JetBrains Mono, Hack, Fira Code) to render symbols and icons properly.
- **Starship Prompt Integration**: Installs and applies a customized Starship prompt config that matches the twin-line custom theme.
- **Zsh Plugins Setup**: Auto-downloads and links `zsh-syntax-highlighting` and `zsh-autosuggestions`.
- **Safe Reset**: Provides a function to reset shell configuration and restore settings with backups.
- **Self-Update**: Built-in option to pull remote script modifications and reload instantly.

---

## Installation & Usage

To execute the Arch customization tool:

1. Open your terminal in Arch Linux.
2. Navigate to the `arch` directory:
   ```bash
   cd arch
   ```
3. Give execution permissions to the script:
   ```bash
   chmod +x setup.sh
   ```
4. Run the installer:
   ```bash
   ./setup.sh
   ```

---

## Visual Setup Requirements

Most of the prompts and custom displays use special Unicode icons (like `󰣇`). You **MUST** select option `05` in the script to install Nerd Fonts, and then configure your terminal emulator to use the installed font (e.g. `JetBrainsMono Nerd Font` or `Hack Nerd Font`) for the icons to display correctly.
