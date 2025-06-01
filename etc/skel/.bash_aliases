PS1='\[\033[01;33m\](container) \u@\h\[\033[01;34m\] \w $\[\033[00m\] '

function rgc()
{
    rg --colors path:fg:cyan --colors path:style:bold -p "$@" | less -RFX
}

eval "`dircolors`"

alias ls='ls --time-style=long-iso --color=auto'
alias ll='ls --time-style=long-iso --color=auto -al'
alias  l='ls --time-style=long-iso --color=always -al'

alias ..='cd ..'
alias ...='cd ../..'

alias v=vim
alias vv="vim -R"
alias s=screen
alias t="screen -dr || screen"
alias o='less -R'
alias rg='rg --colors path:fg:cyan --colors path:style:bold'
alias g="grep --exclude-dir .git --exclude-dir .svn --color=auto"
alias grep="grep --exclude-dir .git --exclude-dir .svn --color=auto"
alias dt="date --utc '+%Y-%m-%d %H:%M:%S UTC'"

