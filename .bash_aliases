# Path management
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Scripts
alias bkw-max='. scripts/maxpower.sh'
alias vpnc='. vpn/conn.sh'
alias vpnd='. vpn/disc.sh'

# Git
alias glog='git log --graph --oneline --all --decorate'
alias gst='git status'
alias gca='git commit -am'
alias gbv='git branch -vv'

# Ip
alias myip='curl ipinfo.io/ip'

# Text processing
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Update and upgrade
alias aptu='sudo nala update'
alias aptug='sudo nala update && sudo nala upgrade -y'
alias apti='sudo nala install -y'
alias aptr='sudo nala remove -y'
alias aptp='sudo nala purge -y'

# Logs
alias btail='multitail'

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --level=2 --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

# Kubectl
alias kubepodmax='kubectl get pods -n max-power-dev -l app=max-power-backend'

# Flag
alias df='df -h'

# Misc
alias duh='du -sh * | sort -h'

# youtube-dl
alias ytd=". scripts/download_video.sh"

# mixxx
alias mixxx="pasuspender mixxx"
