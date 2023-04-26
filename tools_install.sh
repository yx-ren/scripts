#/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

jobs_num=8
tmp_dir=tmp

function install_universal_ctags
{
    echo "install universal ctags"
    git clone https://github.com/universal-ctags/ctags.git ${tmp_dir}/ctags
    cd ${tmp_dir}/ctags
    sh ./autogen.sh
    ./configure
    make -j${jobs_num}
    make install # may require extra privileges depending on where to install
    cd -

    return 0
}

function install_fzf
{
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
    BCS_CHK_RC0 "failed to install fzf"

    install_universal_ctags
    BCS_CHK_RC0 "failed to install ctags"
}

main $?
