#/bin/bash
repo_list=(
vim
tcpdump
strace
systool
lsof
ss
)

for repo in ${repo_list[@]}
do
    echo "install repo"
    yum install -y $repo
done
