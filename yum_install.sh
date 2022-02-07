#/bin/bash
repos="\
    gdb
    jq
    vim
    tcpdump traceroute
    nc
    telent
    strace
    systool sysstat iotop
    ncdu
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
    ruby ruby-devel lua lua-devel luajit
    luajit-devel ctags git python python-devel
    python36 python36-devel tcl-devel
    perl perl-devel perl-ExtUtils-ParseXS
    perl-ExtUtils-XSpp perl-ExtUtils-CBuilder
    perl-ExtUtils-Embed libX* ncurses-devel gtk2-devel
    readline-devel
    rlwrap
    flex
    flex-devel
    bison
    byacc byaccj
    man tldr
    valgrind
    perf
    unzip
"

echo $repos
sudo yum install -y $repos

exit 0
