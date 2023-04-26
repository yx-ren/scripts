# .bashrc

# User specific aliases and functions

alias vi='vim'
alias tmux='tmux -2 -u'
alias ag='ag --noaffinity'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export TZ='Asia/Shanghai'

export LANGUAGE="en_US.UTF-8"
export LANG="zh_CN.UTF-8" 
#export LC_ALL=C

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

export PATH="$PATH:/root/common/script/:/root/work/github/FlameGraph"
export PATH="$HOME/.cargo/bin:$PATH"
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
