# Custom Arch Zsh Theme
# Requires a Nerd Font for full glyph support (e.g. Arch Logo 󰣇)

# Load git information
autoload -Uz vcs_info
precmd_vcs_info() {
    vcs_info
}
precmd_functions+=(precmd_vcs_info)
setopt prompt_subst

# Format VCS info for prompt
zstyle ':vcs_info:git:*' formats '%F{blue}git:(%F{red}%b%F{blue})%r%f'
zstyle ':vcs_info:git:*' actionformats '%F{blue}git:(%F{red}%b%F{blue}|%F{yellow}%a%F{blue})%r%f'

# Define git_prompt_info only if not already defined (e.g. by Oh-My-Zsh)
if ! declare -f git_prompt_info > /dev/null; then
    git_prompt_info() {
        echo -n "${vcs_info_msg_0_}"
    }
fi

# Main Prompt Layout
# ┌─[󰣇 name@ARCH]-[~/path] [git status]
# └─╼ ❯❯❯
PROMPT="
%F{cyan}┌─%F{cyan}[%F{blue}󰣇 %B\${SHELL_NAME:-H4CK3R}%b%F{cyan}@%B%F{blue}ARCH%b%F{cyan}]%F{cyan}-%F{cyan}[%B%F{green}%~%b%F{cyan}]%f \$(git_prompt_info)
%F{cyan}└─╼ %B%F{cyan}❯%F{blue}❯%F{white}❯ %f%b"

# Git Prompt configuration for Oh-My-Zsh (used if OMZ is loaded)
ZSH_THEME_GIT_PROMPT_PREFIX="%F{blue}git:(%F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{blue}) %f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}✔%f"
