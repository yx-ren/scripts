#/bin/bash
github_repositories="\
    https://github.com/yx-ren/vimrc
    https://github.com/yx-ren/common
    https://github.com/yx-ren/scripts
    https://github.com/yx-ren/tcp-server-windows-and-linux
    https://github.com/yx-ren/awesome-cheatsheets
    https://github.com/yx-ren/LinuxDetours
    https://github.com/yx-ren/algorithms
    "
cd ../

for repo in $github_repositories
do
    git clone --recurse-submodules $repo
    if [ $? != 0 ]; then
        echo "failed to clone repo:${repo}"
    fi
done

cd -
