# Custom Kali Zsh Theme
# Requires a Nerd Font for full glyph support (e.g. Kali Logo ㉿ or Skull 💀)

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
# ┌─[💀 name@KALI]-[~/path] [git status]
# └─╼ ❯❯❯
PROMPT="
%F{blue}┌─%F{blue}[%F{red}㉿ %B\${SHELL_NAME:-H4CK3R}%b%F{blue}@%B%F{red}KALI%b%F{blue}]%F{blue}-%F{blue}[%B%F{green}%~%b%F{blue}]%f \$(git_prompt_info)
%F{blue}└─╼ %B%F{blue}❯%F{red}❯%F{white}❯ %f%b"

# Git Prompt configuration for Oh-My-Zsh (used if OMZ is loaded)
ZSH_THEME_GIT_PROMPT_PREFIX="%F{blue}git:(%F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{blue}) %f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}✔%f"
