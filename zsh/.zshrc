# This is the legendary .zshrc!
export PATH=$HOME/.local/bin:$HOME/.local/bin/scripts:$HOME/bin:/usr/local/bin:$HOME/.nix-profile:$HOME/Development/fzf-zsh-plugin/bin:$HOME/.cargo/bin:/opt/nvim-linux-x86_64/bin:$HOME/.npm/bin:$PATH

export BROWSER="google-chrome-stable"
export EDITOR="nvim"
#export TERM="tmux-256color"

export ICAROOT="/opt/Citrix/ICAClient"
export TFTP_DIRECTORY="/srv/tftp"

ZSH_THEME="garyblessington"
HYPHEN_INSENSITIVE="true"

export UPDATE_ZSH_DAYS=30

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git
         wd
         zsh-autosuggestions
         zsh-syntax-highlighting
         fzf-zsh-plugin)

# Path to your oh-my-zsh installation.
if [ -n "$ZSH" ]; then
    # If $ZSH is set by Nix
    source "$ZSH/oh-my-zsh.sh"
else
    # Fallback to manually installed version
    export ZSH=$HOME/.oh-my-zsh
    [ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
fi

source $HOME/.fonts/*.sh

# Accept autosuggestion
bindkey '^n' autosuggest-accept
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Always start tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux && exit
fi

# History stuff
HISTFILE=~/.zsh_history
HISTSIZE=10000
HISTSAVE=10000

# Having this just in the .xinitrc doesn't really work
xset r rate 250 25

alias ls='LC_COLLATE=C ls --color=auto --group-directories-first'
alias ll='LC_COLLATE=C ls -lah --color=auto --group-directories-first'
alias ..='cd ..'
alias ...='cd ../../'
alias nano='nvim'
alias vi='nvim'
alias fuck='pkill -9'
alias ':q'=exit
alias ':wq'=exit
alias psx='ps ax | grep -i'
#alias ssh='TERM="xterm-256color" && ssh'
alias pgrep='pgrep -l'

# Whitelisting specific commands for zsh autocorrect
alias git='nocorrect git'
alias pytest='nocorrect pytest'

# Nevermind that, just disable that shit
#unsetopt correct # doesn't seem to work unfortunately :'(

function fdt() {
    if [ "$1" = "1" ]; then
        echo $(date +%Y-%m-%d_%H_%M)
    else
        echo $(date +%Y-%m-%d)
    fi
}

function mkcd() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1" && cd "$1"
    else
        echo "Directory already exists, pleb!"
    fi
}

function pwin_start_cmd() {
    echo "LD_LIBRARY_PATH=/home/jonas/Development/pwin/timbeter.opencv3.4.1/lib/:/home/jonas/Development/pwin/pylon-5.2.0.13457-x86_64/lib64/"
}

function build-deb () {
        (
                cd debian
                ./gen_deb_version.sh
        )
        fakeroot dpkg-buildpackage -tc -uc -us --build=binary
}

function md2b() {
    pandoc $1 > /tmp/$1.html && google-chrome-stable /tmp/$1.html
}

function ff() {
    find . -type f -iname "*$1*"
}

function zaffura() {
    nohup zathura $1 & > /dev/null 2&>1
}

#if [ -e /home/jonas/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jonas/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
