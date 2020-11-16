local current_dir='%{$fg_bold[red]%}[%{$reset_color%}%~% %{$fg_bold[red]%}]%{$reset_color%}'
local git_branch='$()%{$reset_color%}'


PROMPT="
%(?,%{$fg[red]%} ┌─╼%{$fg_bold[red]%}[%{$fg_bold[blue]%}H4CK3R%{$fg_bold[yellow]%}@%{$fg_bold[cyan]%}LINUX%{$fg_bold[red]%}]%{$fg_bold[green]%}-%{$fg_bold[red]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[red]%}]%{$reset_color%} ${git_branch}
%{$fg[red]%} └────╼%{$fg_bold[white]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} ,%{$fg[red]%} ┌─╼%{$fg_bold[red]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[red]%}]%{$reset_color%}
%{$fg[red]%} └╼%{$fg_bold[white]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"






