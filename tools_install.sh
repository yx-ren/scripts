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

function install_tmux
{
    git clone git@github.com:tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make -j8
    mv /usr/bin/tmux /usr/bin/tmux.bak
    cp tmux /usr/bin/tmux

    install_tmux_plugin
}

function install_tmux_plugin
{
    tmux_conf="~/.tmux.conf"
    mkdir ~/.tmux
    cd ~/.tmux
    git clone https://github.com/tmux-plugins/tmux-resurrect.git
    echo "run-shell ~/.tmux/tmux-resurrect/resurrect.tmux" >> ~/.tmux.conf
    cd -
    tmux source-file ~/.tmux.conf
}

function install_vim_8
{
    cd ${tmp_dir}
    git clone git@github.com:vim/vim.git
    cd vim
	./configure --with-features=huge \
	--enable-pythoninterp \
	--enable-python3interp \
	--enable-rubyinterp \
	--enable-luainterp \
	--enable-perlinterp \
	--with-python-config-dir=/usr/lib64/python2.7/config/ \
	--with-python3-config-dir=/usr/local/python3.6/lib/python3.6/config-3.6m-x86_64-linux-gnu/ \
	--enable-cscope \
	--enable-multibyte \
	--prefix=/usr/local/vim

	make -j8
	make install

	cp /usr/bin/vim /usr/bin/vim.bak
	sudo ln -s /usr/local/vim/bin/vim /usr/bin/vim
}

function main
{
    set -e

    if [[ -d ${tmp_dir} && ! -z ${tmp_dir} ]]; then
        rm -rf ${tmp_dir}
    fi

    install_universal_ctags
    if [ $? != 0 ]; then
        echo "failed to install universal ctags"
    fi

    install_tmux
    if [ $? != 0 ]; then
        echo "failed to install tmux"
    fi

    install_fzf
    if [ $? != 0 ]; then
        echo "failed to install fzf"
    fi
}

main $?
