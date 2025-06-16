# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="tjkirch"
# THis is my theme
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# function set_terminal_title() {
#   echo -en "\033]0;${PWD/#$HOME/~}\007"
# }
precmd() { echo -en "\033]0;${PWD/#$HOME/~}\007" }
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git zsh-syntax-highlighting zsh-autosuggestions
	sudo history jsontools ssh-agent fzf vi-mode
    copypath copyfile copybuffer dirhistory fzf-zsh-plugin)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
EDITOR='nvim'
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Path management
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Scripts
# alias vpnc='. vpn/conn.sh'
# alias vpnd='. vpn/disc.sh'
alias vpnc='sudo tailscale set --exit-node=remote-laptop.tailfa8e1.ts.net.'
alias vpnd='sudo tailscale up --exit-node='

# Git
alias glog='git log --graph --oneline --all --decorate'
alias gst='git status'
alias gca='git commit -am'
alias gbv='git branch -vv'
alias g-='git checkout -'
alias gdev='git checkout develop'
# alias floorp='flatpak run one.ablaze.floorp'

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
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --level=2 --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'

# Flag
alias df='df -h'

# Misc
alias duh='du -sh * | sort -h'

# youtube-dl
alias ytd=". scripts/download_video.sh"

# mixxx
alias mixxx="pasuspender mixxx"

# nvim as vi
alias vo="nvim -c 'Telescope oldfiles'"
# also have the vis for the stable version, since nvim is nightly.
alias vos="vis -c 'Telescope oldfiles'"
# alias vi="nvim" # Temp disable because v0.12.0 has issues
alias vi="vis" # TODO: re-add, when all ok. vis is my stable version of nvim

# others
alias mouse="keep-presence"
#alias cat="bat"
alias db="dbeaver-ce"
alias ncspot="flatpak run io.github.hrkfdn.ncspot"
# alias music="ncspot"
# Find and activate virtualenv
alias venv="source ~/scripts/venv.sh"
# Show characteristics of laptop
alias mypc="neofetch"
# Tmux
alias ta="source ~/scripts/tmux-anything.sh"
# Qbittorrent
alias qbt="z ~/Downloads/torrents/ && ./qbittorrent-4.6.6_x86_64_1.AppImage"
# File manager
alias fm='nautilus .'
# Wezterm
alias wz='WAYLAND_DISPLAY= XWAYLAND=1 wezterm'
alias lg='lazygit'
alias backup-rsync='rsync -av --progress --exclude-from="exclude.txt" "/home/xouzoura/" "/media/xouzoura/T7 Touch/backups/rsync"'
# NVIM-BASED
# Notes 
alias notes="vi ~/vaults/notes"
alias notesw="vi ~/vaults/notes/_weekend-goals.md"
alias notesq="vi ~/vaults/notes/_work.md"
alias notesd="vi ~/vaults/notes/_daily.md"
# k8s 
alias k8s='nvim +"lua require(\"kubectl\").open()"'
alias oil='nvim +"Oil"'
alias dbui='nvim +"DBUIToggle"'
# alias gitgraph='nvim +"lua require(\"gitgraph\").draw({}, {all=true, max_count=5000})"'
#
# PYTHON
# Python aliases for my code 
alias pnew='poetry run pytest -s -m new'
alias plf='poetry run pytest -s --lf'
alias pdb='poetry run pytest -s --pdb'
alias pca='pre-commit run --all-files'
alias jp='python -m jupyter notebook'

# Yazi (yy)
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"

	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# adding a second one because of the stupid issue with wayland on preview.
function yyf() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    # Workaround to view images.
    env -u WAYLAND_DISPLAY wezterm start -- yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
## Autofold (fold_md)
fold_md() {
  local file="$1"
  if [ -f "$file" ]; then
    fold -s -w 80 "$file" > temp.md && mv temp.md "$file"
    echo "Formatted $file with a width of 80 characters."
  else
    echo "Error: $file not found."
  fi
}

source ~/.zshrc_secrets

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH="$HOME/.local/bin:$PATH" # <-- maybe re-add?
# # DELETE AFTER NOTE:
# PATH="$HOME/repos-for-binaries/google-cloud-sdk/bin:$PATH" # remove after.
# export KOPS_STATE_STORE=gs://cca-eth-2025-group-043-ethzid/
# export PROJECT=`gcloud config get-value project`

# export PATH="$HOME/.fzf/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(zoxide init zsh)"
bindkey '^ ' autosuggest-accept
bindkey '^]' autosuggest-execute
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
# Exit with jj and kj 
bindkey -M viins 'jj' vi-cmd-mode 
bindkey -M viins 'kj' vi-cmd-mode 
# git stuff
source ~/scripts/fzf-git.sh/fzf-git.sh 
# The hotkeys for git stuff
# 
    # CTRL-G - CTRL-F for Files
    # CTRL-G - CTRL-B for Branches
    # CTRL-G - CTRL-T for Tags
    # CTRL-G - CTRL-R for Remotes
    # CTRL-G - CTRL-G for Commits
# control + u = backspace
# control + m = enter
bindkey '^U' backward-delete-char
bindkey '^M' accept-line
# Capture last command outputs to a file and open it in Vim
capture_and_edit_last_command_output() {
    # Get the last command from history
    local last_command=$(fc -ln -1)

    # Re-run the last command and save its output to a temporary file
    eval "$last_command" | sed 's/\x1B\[[0-9;]*[JKmsu]//g' > /tmp/last_command_output.txt 2>&1

    # Open the output in Vim
    vi /tmp/last_command_output.txt
}

# Alias to capture the last command output and open it in Vim
alias capture='capture_and_edit_last_command_output'
# Always keep at the end
eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Load Angular CLI autocompletion.
source <(ng completion script)
