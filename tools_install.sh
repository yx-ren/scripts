#/bin/bash
#source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

jobs_num=8
tmp_dir=tmp

function install_universal_ctags
{
    universal_ctags_version=`ctags --version | grep -i 'Universal Ctags' | head -n1`
    if [ ! "z${universal_ctags_version}" = "z" ]; then
        echo "Universal Ctags has been installed, version:${universal_ctags_version}"
        return 0
    fi

    echo "start to install universal ctags"
    git clone https://github.com/universal-ctags/ctags.git ${tmp_dir}/ctags
    cd ${tmp_dir}/ctags
    sh ./autogen.sh
    ./configure
    make -j${jobs_num}
    make install # may require extra privileges depending on where to install
    cd -
    mv /usr/bin/ctags /usr/bin/ctags.bak
    ln -s /usr/local/bin/ctags  /usr/bin/ctags

    universal_ctags_version=`ctags --version | grep -i 'Universal Ctags' | head -n1`
    echo "install ctags:${universal_ctags_version}"

    return 0
}

function install_fzf
{
    if [ -f ~/.fzf/bin/fzf ]; then
        echo "fzf has been installed"
        return 0
    fi

    echo "start to install fzf......"

    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

function main
{
    set -e

    if [[ -d ${tmp_dir} && ! -z ${tmp_dir} ]]; then
        rm -rf ${tmp_dir}
    fi

    install_fzf
    if [ $? != 0 ]; then
        echo "failed to install fzf"
    fi

    install_universal_ctags
    if [ $? != 0 ]; then
        echo "failed to install universal ctags"
    fi
}

main $?
