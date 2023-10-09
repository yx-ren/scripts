source /opt/rh/devtoolset-7/enable
LANG="zh_CN.UTF-8"

alias vi='vim'
alias tmux='tmux -2'

export TERM=xterm-256color

HOME_DIR=$(echo ~)
export PATH="$PATH:$HOME_DIR/work/github/yx-ren/scripts"

ulimit -c unlimited

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
export PIPENV_PIPFILE=$(pwd)/Pipfile
alias aldaba-ops='~/.local/bin/pipenv run aldaba-ops'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
# DISABLE_AUTO_TITLE="true"

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
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    autojump
    colored-man-pages
    bazel
    extract
    cp
    git-open
    #vi-mode
    rand-quote
)

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

source /opt/rh/devtoolset-7/enable
LANG="zh_CN.UTF-8"

# User specific aliases and functions

alias vi='vim'
alias tmux='tmux -2'
alias ag='ag --noaffinity'

HOME_DIR=$(echo ~)
# for yx-ren scripts
export PATH="$PATH:$HOME_DIR/work/github/yx-ren/scripts"

# for local bin
export PATH="$PATH:$HOME_DIR/.local/bin"

# enable zoxide
eval "$(zoxide init zsh)"

ulimit -c unlimited

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

alias aldaba-ops='~/.local/bin/pipenv run aldaba-ops'

fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

# disable shared history
setopt no_share_history


# 设置git颜色
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%{$fg[yellow]%}|%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}?"

GIT_PROMPT_THEME_NAME="Custom"

# 获取当前git分支
function current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo ${ref#refs/heads/}
}

# 显示当前git分支和状态
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "%{$fg[yellow]%}($(current_branch)%{$fg[yellow]%})"
}

# 设置git分支和状态的颜色
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUPSTREAM="auto"

# 设置ls颜色
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

# 设置提示符
PROMPT='%{$fg[white]%}%n%{$reset_color%} at %{$fg[green]%}%m %{$reset_color%} in %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)%{$reset_color%}
%{$fg[white]%}\$%{$reset_color%} '


## Configures bindings for jumping/deleting full and sub-words, similar to
## the keybindings in bash.
#
## Jumping:
## Alt + B                Backward sub-word
## Ctrl + Alt + B         Backward full-word
## Alt + F                Forward sub-word
## Ctrl + Alt + F         Forward full-word
#
## Deleting:
## Ctrl + W               Backward delete full-word
## Ctrl + Alt + H         Backward delete sub-word
## Alt + D                Forward delete sub-word
## Ctrl + Alt + D         Forward delete full-word
#
## Which characters, besides letters and numbers, that are jumped over by a
## full-word jump:
#FULLWORDCHARS="*?_-.,[]~=/&:;!#$%^(){}<>'\""
#
#backward-full-word() { WORDCHARS=$FULLWORDCHARS zle .backward-word ; }
#backward-sub-word() { WORDCHARS="" zle .backward-word ; }
#forward-full-word() { WORDCHARS=$FULLWORDCHARS zle .forward-word ; }
#backward-kill-full-word() { WORDCHARS=$FULLWORDCHARS zle .backward-kill-word ; }
#backward-kill-sub-word() { WORDCHARS="" zle .backward-kill-word ; }
#forward-kill-full-word() { WORDCHARS=$FULLWORDCHARS zle .kill-word ; }
#forward-kill-sub-word() { WORDCHARS="" zle .kill-word ; }
#
#zle -N backward-full-word
#zle -N backward-sub-word
#zle -N forward-full-word
#zle -N backward-kill-full-word
#zle -N backward-kill-sub-word
#zle -N forward-kill-full-word
#zle -N forward-kill-sub-word
#
## For `forward-sub-word` we use the built-in `emacs-forward-word` widget,
## because that simulates bash behavior.
#zle -A emacs-forward-word forward-sub-word
#
#bindkey "^[b" backward-sub-word
#bindkey "^[^b" backward-full-word
#bindkey "^[f" forward-sub-word
#bindkey "^[^f" forward-full-word
#bindkey "^[^h" backward-kill-sub-word
#bindkey "^w" backward-kill-full-word
#bindkey "^[d" forward-kill-sub-word
#bindkey "^[^d" forward-kill-full-word

# Ctrl-u - delete a full line
bindkey \^U backward-kill-line
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

# Ctrl-w - delete a full WORD (including colon, dot, comma, quotes...)
my-backward-kill-word () {
    # Add colon, comma, single/double quotes to word chars
    local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>:,"'"'"
    zle -f kill # Append to the kill ring on subsequent kills.
    zle backward-kill-word
}
zle -N my-backward-kill-word
bindkey '^w' my-backward-kill-word


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
