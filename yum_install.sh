#/bin/bash
repo_list=(
vim
tcpdump
strace
systool
lsof
ss
bash-c*
tmux
cargo
rust
glibc-common
epel-release
the_silver_searcher
openssl
openssl-devel
libevent
libevent-devel
ncurses
ncurses-devel
)

for repo in ${repo_list[@]}
do
    echo "install repo"
    yum install -y $repo
done
