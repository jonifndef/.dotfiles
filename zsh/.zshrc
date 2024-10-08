# This is the legendary .zshrc!
# # If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/.local/bin/scripts:$HOME/bin:/usr/local/bin:$HOME/.nix-profile:$HOME/Development/fzf-zsh-plugin/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export BROWSER="google-chrome-stable"
export EDITOR="nvim"
#export TERM="tmux-256color"

export ICAROOT="/opt/Citrix/ICAClient"
export TFTP_DIRECTORY="/srv/tftp"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="garyblessington"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
         wd
         zsh-autosuggestions
         zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Accept autosuggestion
bindkey '^n' autosuggest-accept

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# LC_COLLATE=C sorts ls output with dotfiles on top

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

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/Development/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh ] && source ~/Development/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/jonas/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/jonas/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/jonas/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/jonas/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

if [ -e /home/jonas/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jonas/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
