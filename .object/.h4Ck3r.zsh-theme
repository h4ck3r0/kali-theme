# Custom Kali Zsh Theme
# Requires a Nerd Font for full glyph support (e.g. Kali Logo ㉿ or Skull 💀)

# Load Archify colors
if [ -f "$HOME/.config/archify/colors.sh" ]; then
    source "$HOME/.config/archify/colors.sh"
fi

# Set fallbacks if not defined (default to blue and red for Kali Linux)
ARCHIFY_PRIMARY="${ARCHIFY_PRIMARY:-blue}"
ARCHIFY_SECONDARY="${ARCHIFY_SECONDARY:-red}"
ARCHIFY_SUCCESS="${ARCHIFY_SUCCESS:-green}"
ARCHIFY_ALERT="${ARCHIFY_ALERT:-red}"
ARCHIFY_WARN="${ARCHIFY_WARN:-yellow}"

# Load git information
autoload -Uz vcs_info
precmd_vcs_info() {
    vcs_info
}
precmd_functions+=(precmd_vcs_info)
setopt prompt_subst

# Format VCS info for prompt
zstyle ':vcs_info:git:*' formats "%F{${ARCHIFY_PRIMARY}}git:(%F{${ARCHIFY_ALERT}}%b%F{${ARCHIFY_PRIMARY}})%r%f"
zstyle ':vcs_info:git:*' actionformats "%F{${ARCHIFY_PRIMARY}}git:(%F{${ARCHIFY_ALERT}}%b%F{${ARCHIFY_PRIMARY}}|%F{${ARCHIFY_WARN}}%a%F{${ARCHIFY_PRIMARY}})%r%f"

# Define git_prompt_info only if not already defined (e.g. by Oh-My-Zsh)
if ! declare -f git_prompt_info > /dev/null; then
    git_prompt_info() {
        echo -n "${vcs_info_msg_0_}"
    }
fi

# Main Prompt Layout
# ┌─[㉿ name@KALI]-[~/path] [git status]
# └─╼ ❯❯❯
PROMPT="
%F{\${ARCHIFY_PRIMARY}}┌─%F{\${ARCHIFY_PRIMARY}}[%F{\${ARCHIFY_SUCCESS}}%B\${SHELL_NAME:-H4CK3R}%b%F{white}@%B%F{\${ARCHIFY_SECONDARY}}KALI%b%F{\${ARCHIFY_PRIMARY}}]%F{\${ARCHIFY_PRIMARY}}-%F{\${ARCHIFY_PRIMARY}}[%B%F{\${ARCHIFY_SUCCESS}}%~%b%F{\${ARCHIFY_PRIMARY}}]%f \$(git_prompt_info)
%F{\${ARCHIFY_PRIMARY}}└─╼ %B%F{\${ARCHIFY_PRIMARY}}❯%F{\${ARCHIFY_SECONDARY}}❯%F{\${ARCHIFY_SUCCESS}}❯ %f%b"

# Git Prompt configuration for Oh-My-Zsh (used if OMZ is loaded)
ZSH_THEME_GIT_PROMPT_PREFIX="%F{${ARCHIFY_PRIMARY}}git:(%F{${ARCHIFY_ALERT}}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{${ARCHIFY_PRIMARY}}) %f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{${ARCHIFY_WARN}}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{${ARCHIFY_SUCCESS}}✔%f"
