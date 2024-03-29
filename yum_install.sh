#/bin/bash
repos="\
    PyYAML.x86_64
    acl.x86_64
    adobe-mappings-cmap.noarch
    adobe-mappings-cmap-deprecated.noarch
    adobe-mappings-pdf.noarch
    adwaita-cursor-theme.noarch
    adwaita-icon-theme.noarch
    aether-api.noarch
    aether-connector-wagon.noarch
    aether-impl.noarch
    aether-spi.noarch
    aether-util.noarch
    alsa-lib.x86_64
    ansible.noarch
    aopalliance.noarch
    apache-commons-cli.noarch
    apache-commons-codec.noarch
    apache-commons-io.noarch
    apache-commons-lang.noarch
    apache-commons-logging.noarch
    apache-commons-net.noarch
    apr.x86_64
    apr-util.x86_64
    at-spi2-atk.x86_64
    at-spi2-core.x86_64
    atinject.noarch
    atk.x86_64
    atk-devel.x86_64
    audit-libs.x86_64
    audit-libs-python.x86_64
    autoconf.noarch
    automake.noarch
    avahi-libs.x86_64
    avalon-framework.noarch
    avalon-logkit.noarch
    basesystem.noarch
    bash.x86_64
    bash-completion.noarch
    bash-completion-extras.noarch
    bazel.x86_64
    bc.x86_64
    bcc.x86_64
    bcc-doc.noarch
    bcc-tools.x86_64
    bcel.noarch
    bind-license.noarch
    binutils.x86_64
    bison.x86_64
    boost.x86_64
    boost-atomic.x86_64
    boost-chrono.x86_64
    boost-context.x86_64
    boost-date-time.x86_64
    boost-devel.x86_64
    boost-doc.noarch
    boost-filesystem.x86_64
    boost-graph.x86_64
    boost-iostreams.x86_64
    boost-locale.x86_64
    boost-math.x86_64
    boost-program-options.x86_64
    boost-python.x86_64
    boost-random.x86_64
    boost-regex.x86_64
    boost-serialization.x86_64
    boost-signals.x86_64
    boost-static.x86_64
    boost-system.x86_64
    boost-test.x86_64
    boost-thread.x86_64
    boost-timer.x86_64
    boost-wave.x86_64
    byacc.x86_64
    byaccj.x86_64
    bzip2.x86_64
    bzip2-libs.x86_64
    ca-certificates.noarch
    cabal-install.x86_64
    cairo.x86_64
    cairo-devel.x86_64
    cairo-gobject.x86_64
    cal10n.noarch
    cargo.x86_64
    cdi-api.noarch
    centos-indexhtml.noarch
    centos-release.x86_64
    centos-release-scl.noarch
    centos-release-scl-rh.noarch
    cglib.noarch
    checkpolicy.x86_64
    chkconfig.x86_64
    cjkuni-uming-fonts.noarch
    clang.x86_64
    cloc.noarch
    cmake3.x86_64
    cmake3-data.noarch
    colord-libs.x86_64
    copy-jdk-configs.noarch
    coreutils.x86_64
    cpio.x86_64
    cpp.x86_64
    cracklib.x86_64
    cracklib-dicts.x86_64
    cronie.x86_64
    cronie-anacron.x86_64
    crontabs.noarch
    cryptsetup-libs.x86_64
    ctags.x86_64
    cups-libs.x86_64
    curl.x86_64
    cyrus-sasl-lib.x86_64
    dbus.x86_64
    dbus-glib.x86_64
    dbus-libs.x86_64
    dbus-python.x86_64
    dconf.x86_64
    dejavu-fonts-common.noarch
    dejavu-sans-fonts.noarch
    dejavu-sans-mono-fonts.noarch
    dejavu-serif-fonts.noarch
    device-mapper.x86_64
    device-mapper-libs.x86_64
    devtoolset-7-binutils.x86_64
    devtoolset-7-gcc.x86_64
    devtoolset-7-gcc-c++.x86_64
    devtoolset-7-libstdc++-devel.x86_64
    devtoolset-7-runtime.x86_64
    diffutils.x86_64
    doxygen.x86_64
    dracut.x86_64
    dwz.x86_64
    easymock2.noarch
    elfutils-debuginfo.x86_64
    elfutils-default-yama-scope.noarch
    elfutils-libelf.x86_64
    elfutils-libelf-devel.x86_64
    elfutils-libs.x86_64
    emacs-filesystem.noarch
    epel-release.noarch
    ethtool.x86_64
    expat.x86_64
    expat-devel.x86_64
    expect.x86_64
    fcitx.x86_64
    fcitx-data.noarch
    fcitx-gtk2.x86_64
    fcitx-gtk3.x86_64
    fcitx-libs.x86_64
    fcitx-pinyin.x86_64
    fcitx-table.x86_64
    fcitx-table-chinese.noarch
    felix-framework.noarch
    file.x86_64
    file-libs.x86_64
    filesystem.x86_64
    findutils.x86_64
    fipscheck.x86_64
    fipscheck-lib.x86_64
    firefox.x86_64
    flex.x86_64
    flex-devel.x86_64
    fontconfig.x86_64
    fontconfig-devel.x86_64
    fontpackages-filesystem.noarch
    freetype.x86_64
    freetype-devel.x86_64
    fribidi.x86_64
    fribidi-devel.x86_64
    gawk.x86_64
    gcc.x86_64
    gcc-c++.x86_64
    gd.x86_64
    gdb.x86_64
    gdbm.x86_64
    gdbm-devel.x86_64
    gdk-pixbuf2.x86_64
    gdk-pixbuf2-devel.x86_64
    geronimo-annotation.noarch
    geronimo-jms.noarch
    gettext.x86_64
    gettext-libs.x86_64
    ghc-Cabal.x86_64
    ghc-HTTP.x86_64
    ghc-array.x86_64
    ghc-base.x86_64
    ghc-base-devel.x86_64
    ghc-bytestring.x86_64
    ghc-compiler.x86_64
    ghc-containers.x86_64
    ghc-deepseq.x86_64
    ghc-directory.x86_64
    ghc-filepath.x86_64
    ghc-mtl.x86_64
    ghc-network.x86_64
    ghc-old-locale.x86_64
    ghc-old-time.x86_64
    ghc-parsec.x86_64
    ghc-pretty.x86_64
    ghc-process.x86_64
    ghc-random.x86_64
    ghc-text.x86_64
    ghc-time.x86_64
    ghc-transformers.x86_64
    ghc-unix.x86_64
    ghc-zlib.x86_64
    ghostscript.x86_64
    giflib.x86_64
    git.x86_64
    gl-manpages.noarch
    glances.noarch
    glib-networking.x86_64
    glib2.x86_64
    glib2-devel.x86_64
    glibc.x86_64
    glibc-common.x86_64
    glibc-debuginfo.x86_64
    glibc-debuginfo-common.x86_64
    glibc-devel.x86_64
    glibc-headers.x86_64
    gmp.x86_64
    gmp-devel.x86_64
    gnu-free-fonts-common.noarch
    gnu-free-mono-fonts.noarch
    gnu-free-sans-fonts.noarch
    gnu-free-serif-fonts.noarch
    gnupg2.x86_64
    gnutls.x86_64
    gobject-introspection.x86_64
    golang.x86_64
    golang-bin.x86_64
    golang-src.noarch
    google-crosextra-caladea-fonts.noarch
    google-crosextra-carlito-fonts.noarch
    google-guice.noarch
    google-noto-emoji-fonts.noarch
    gpgme.x86_64
    gpm-libs.x86_64
    graphite2.x86_64
    graphite2-devel.x86_64
    graphviz.x86_64
    grep.x86_64
    groff-base.x86_64
    gsettings-desktop-schemas.x86_64
    gtk-update-icon-cache.x86_64
    gtk2.x86_64
    gtk2-devel.x86_64
    gtk3.x86_64
    guava.noarch
    gzip.x86_64
    hamcrest.noarch
    hardlink.x86_64
    harfbuzz.x86_64
    harfbuzz-devel.x86_64
    harfbuzz-icu.x86_64
    hicolor-icon-theme.noarch
    hostname.x86_64
    hping3.x86_64
    htop.x86_64
    httpcomponents-client.noarch
    httpcomponents-core.noarch
    hwdata.x86_64
    imsettings.x86_64
    imsettings-gsettings.x86_64
    imsettings-libs.x86_64
    info.x86_64
    initscripts.x86_64
    inotify-tools.x86_64
    iotop.noarch
    iproute.x86_64
    iptables.x86_64
    iputils.x86_64
    iso-codes.noarch
    jakarta-commons-httpclient.noarch
    jasper-libs.x86_64
    java-1.8.0-openjdk.x86_64
    java-1.8.0-openjdk-devel.x86_64
    java-1.8.0-openjdk-headless.x86_64
    java-11-openjdk.x86_64
    java-11-openjdk-devel.x86_64
    java-11-openjdk-headless.x86_64
    javamail.noarch
    javapackages-tools.noarch
    javassist.noarch
    jbigkit-libs.x86_64
    jboss-ejb-3.1-api.noarch
    jboss-el-2.2-api.noarch
    @base
    jboss-interceptors-1.1-api.noarch
    @base
    jboss-jaxrpc-1.1-api.noarch
    jboss-servlet-3.0-api.noarch
    jboss-transaction-1.1-api.noarch
    jemalloc.x86_64
    jline.noarch
    jomolhari-fonts.noarch
    jq.x86_64
    jsch.noarch
    json-c.x86_64
    json-glib.x86_64
    jsoncpp.x86_64
    jsoup.noarch
    junit.noarch
    jzlib.noarch
    kde-filesystem.x86_64
    kde-l10n.noarch
    kde-l10n-Chinese.noarch
    kernel-debuginfo-common-x86_64.x86_64
    kernel-devel.x86_64
    kernel-headers.x86_64
    keyutils-libs.x86_64
    keyutils-libs-devel.x86_64
    khmeros-base-fonts.noarch
    khmeros-fonts-common.noarch
    kmod.x86_64
    kmod-libs.x86_64
    kpartx.x86_64
    krb5-devel.x86_64
    krb5-libs.x86_64
    lcms2.x86_64
    lcov.noarch
    less.x86_64
    libICE.x86_64
    libICE-devel.x86_64
    libNX_X11.x86_64
    libNX_X11-devel.x86_64
    libSM.x86_64
    libSM-devel.x86_64
    libX11.x86_64
    libX11-common.noarch
    libX11-debuginfo.x86_64
    libX11-devel.x86_64
    libXNVCtrl.x86_64
    libXNVCtrl-debuginfo.x86_64
    libXNVCtrl-devel.x86_64
    libXScrnSaver.x86_64
    libXScrnSaver-debuginfo.x86_64
    libXScrnSaver-devel.x86_64
    libXau.x86_64
    libXau-debuginfo.x86_64
    libXau-devel.x86_64
    libXaw.x86_64
    libXaw-debuginfo.x86_64
    libXaw-devel.x86_64
    libXcomp.x86_64
    libXcomp-devel.x86_64
    libXcomposite.x86_64
    libXcomposite-debuginfo.x86_64
    libXcomposite-devel.x86_64
    libXcompshad.x86_64
    libXcompshad-devel.x86_64
    libXcursor.x86_64
    libXcursor-debuginfo.x86_64
    libXcursor-devel.x86_64
    libXdamage.x86_64
    libXdamage-debuginfo.x86_64
    libXdamage-devel.x86_64
    libXdmcp.x86_64
    libXdmcp-debuginfo.x86_64
    libXdmcp-devel.x86_64
    libXevie.x86_64
    libXevie-debuginfo.x86_64
    libXevie-devel.x86_64
    libXext.x86_64
    libXext-debuginfo.x86_64
    libXext-devel.x86_64
    libXfixes.x86_64
    libXfixes-debuginfo.x86_64
    libXfixes-devel.x86_64
    libXfont.x86_64
    libXfont-debuginfo.x86_64
    libXfont-devel.x86_64
    libXfont2.x86_64
    libXfont2-debuginfo.x86_64
    libXfont2-devel.x86_64
    libXft.x86_64
    libXft-debuginfo.x86_64
    libXft-devel.x86_64
    libXi.x86_64
    libXi-debuginfo.x86_64
    libXi-devel.x86_64
    libXinerama.x86_64
    libXinerama-debuginfo.x86_64
    libXinerama-devel.x86_64
    libXmu.x86_64
    libXmu-debuginfo.x86_64
    libXmu-devel.x86_64
    libXp.x86_64
    libXp-debuginfo.x86_64
    libXp-devel.x86_64
    libXpm.x86_64
    libXpm-debuginfo.x86_64
    libXpm-devel.x86_64
    libXrandr.x86_64
    libXrandr-debuginfo.x86_64
    libXrandr-devel.x86_64
    libXrender.x86_64
    libXrender-debuginfo.x86_64
    libXrender-devel.x86_64
    libXres.x86_64
    libXres-debuginfo.x86_64
    libXres-devel.x86_64
    libXt.x86_64
    libXt-debuginfo.x86_64
    libXt-devel.x86_64
    libXtst.x86_64
    libXtst-debuginfo.x86_64
    libXtst-devel.x86_64
    libXv.x86_64
    libXv-debuginfo.x86_64
    libXv-devel.x86_64
    libXvMC.x86_64
    libXvMC-debuginfo.x86_64
    libXvMC-devel.x86_64
    libXxf86dga.x86_64
    libXxf86dga-debuginfo.x86_64
    libXxf86dga-devel.x86_64
    libXxf86misc.x86_64
    libXxf86misc-debuginfo.x86_64
    libXxf86misc-devel.x86_64
    libXxf86vm.x86_64
    libXxf86vm-debuginfo.x86_64
    libXxf86vm-devel.x86_64
    libacl.x86_64
    libarchive.x86_64
    libassuan.x86_64
    libattr.x86_64
    libblkid.x86_64
    libcap.x86_64
    libcap-ng.x86_64
    libcgroup.x86_64
    libcom_err.x86_64
    libcom_err-devel.x86_64
    libcroco.x86_64
    libcurl.x86_64
    libcurl-devel.x86_64
    libdb.x86_64
    libdb-devel.x86_64
    libdb-utils.x86_64
    libdrm.x86_64
    libdrm-devel.x86_64
    libedit.x86_64
    libepoxy.x86_64
    liberation-fonts-common.noarch
    liberation-mono-fonts.noarch
    liberation-sans-fonts.noarch
    liberation-serif-fonts.noarch
    libevent.x86_64
    libevent-devel.x86_64
    libffi.x86_64
    libffi-devel.x86_64
    libfontenc.x86_64
    libfontenc-devel.x86_64
    libgcc.x86_64
    libgcrypt.x86_64
    libglvnd.x86_64
    libglvnd-core-devel.x86_64
    libglvnd-devel.x86_64
    libglvnd-egl.x86_64
    libglvnd-gles.x86_64
    libglvnd-glx.x86_64
    libglvnd-opengl.x86_64
    libgomp.x86_64
    libgpg-error.x86_64
    libgs.x86_64
    libgusb.x86_64
    libibverbs.x86_64
    libicu.x86_64
    libicu-devel.x86_64
    libidn.x86_64
    libjpeg-turbo.x86_64
    libkadm5.x86_64
    libmng.x86_64
    libmnl.x86_64
    libmodman.x86_64
    libmount.x86_64
    libmpc.x86_64
    libmpc-devel.x86_64
    libnetfilter_conntrack.x86_64
    libnfnetlink.x86_64
    libnl3.x86_64
    libnotify.x86_64
    libpaper.x86_64
    libpcap.x86_64
    libpciaccess.x86_64
    libpipeline.x86_64
    libpng.x86_64
    libpng-devel.x86_64
    libproxy.x86_64
    libpwquality.x86_64
    librdmacm.x86_64
    librsvg2.x86_64
    libselinux.x86_64
    libselinux-devel.x86_64
    libselinux-python.x86_64
    libselinux-utils.x86_64
    libsemanage.x86_64
    libsemanage-python.x86_64
    libsepol.x86_64
    libsepol-devel.x86_64
    libsmartcols.x86_64
    libsoup.x86_64
    libssh2.x86_64
    libstdc++.x86_64
    libstdc++-devel.x86_64
    libtasn1.x86_64
    libtermkey.x86_64
    libthai.x86_64
    libtiff.x86_64
    libtirpc.x86_64
    libtool.x86_64
    libtool-ltdl.x86_64
    libunistring.x86_64
    libunwind.x86_64
    libunwind-devel.x86_64
    libusbx.x86_64
    libuser.x86_64
    libutempter.x86_64
    libuuid.x86_64
    libuuid-devel.x86_64
    libuv.x86_64
    libverto.x86_64
    libverto-devel.x86_64
    libvterm.x86_64
    libwayland-client.x86_64
    libwayland-cursor.x86_64
    libwayland-egl.x86_64
    libwayland-server.x86_64
    libxcb.x86_64
    libxcb-devel.x86_64
    libxkbcommon.x86_64
    libxkbfile.x86_64
    libxml2.x86_64
    libxml2-python.x86_64
    libxshmfence.x86_64
    libxslt.x86_64
    libyaml.x86_64
    libzstd.x86_64
    lklug-fonts.noarch
    lksctp-tools.x86_64
    llvm.x86_64
    llvm-libs.x86_64
    llvm-private.x86_64
    llvm11-libs.x86_64
    lm_sensors-libs.x86_64
    @base
    log4j.noarch
    lohit-assamese-fonts.noarch
    lohit-bengali-fonts.noarch
    lohit-devanagari-fonts.noarch
    lohit-gujarati-fonts.noarch
    lohit-kannada-fonts.noarch
    lohit-malayalam-fonts.noarch
    lohit-marathi-fonts.noarch
    lohit-nepali-fonts.noarch
    lohit-oriya-fonts.noarch
    lohit-punjabi-fonts.noarch
    lohit-tamil-fonts.noarch
    lohit-telugu-fonts.noarch
    lsof.x86_64
    lua.x86_64
    lua-bit32.x86_64
    lua-devel.x86_64
    luajit.x86_64
    luajit-devel.x86_64
    lz4.x86_64
    lzo.x86_64
    m4.x86_64
    madan-fonts.noarch
    make.x86_64
    man-db.x86_64
    man-pages.noarch
    maven.noarch
    maven-wagon.noarch
    mercurial.x86_64
    mesa-khr-devel.x86_64
    mesa-libEGL.x86_64
    mesa-libEGL-devel.x86_64
    mesa-libGL.x86_64
    mesa-libGL-devel.x86_64
    mesa-libgbm.x86_64
    mesa-libglapi.x86_64
    mozilla-filesystem.x86_64
    mpfr.x86_64
    mpfr-devel.x86_64
    msgpack.x86_64
    multitail.x86_64
    ncdu.x86_64
    ncurses.x86_64
    ncurses-base.noarch
    ncurses-devel.x86_64
    ncurses-libs.x86_64
    nekohtml.noarch
    neon.x86_64
    neovim.x86_64
    net-tools.x86_64
    nethogs.x86_64
    nettle.x86_64
    nhn-nanum-fonts-common.noarch
    nhn-nanum-gothic-fonts.noarch
    nmap-ncat.x86_64
    nspr.x86_64
    nss.x86_64
    nss-pem.x86_64
    nss-softokn.x86_64
    nss-softokn-debuginfo.x86_64
    nss-softokn-freebl.x86_64
    nss-sysinit.x86_64
    nss-tools.x86_64
    nss-util.x86_64
    numactl-debuginfo.x86_64
    numactl-libs.x86_64
    nx-libs.x86_64
    nx-libs-devel.x86_64
    nx-proto-devel.x86_64
    objectweb-asm.noarch
    oniguruma.x86_64
    open-sans-fonts.noarch
    openjpeg2.x86_64
    openldap.x86_64
    openssh.x86_64
    openssh-clients.x86_64
    openssh-server.x86_64
    openssl.x86_64
    openssl-devel.x86_64
    openssl-libs.x86_64
    overpass-fonts.noarch
    p11-kit.x86_64
    p11-kit-trust.x86_64
    pakchois.x86_64
    paktype-naskh-basic-fonts.noarch
    pam.x86_64
    pango.x86_64
    pango-devel.x86_64
    paratype-pt-sans-fonts.noarch
    passwd.x86_64
    patch.x86_64
    pciutils.x86_64
    pciutils-libs.x86_64
    pcre.x86_64
    pcre-devel.x86_64
    pcsc-lite-libs.x86_64
    perf.x86_64
    perf-debuginfo.x86_64
    perl.x86_64
    perl-Algorithm-Diff.noarch
    perl-Carp.noarch
    perl-Data-Dumper.x86_64
    perl-Digest.noarch
    perl-Digest-MD5.x86_64
    perl-Encode.x86_64
    perl-Error.noarch
    perl-Exporter.noarch
    perl-ExtUtils-CBuilder.noarch
    perl-ExtUtils-Embed.noarch
    perl-ExtUtils-Install.noarch
    perl-ExtUtils-MakeMaker.noarch
    perl-ExtUtils-Manifest.noarch
    perl-ExtUtils-ParseXS.noarch
    perl-ExtUtils-XSpp.noarch
    perl-File-Path.noarch
    perl-File-Slurp.noarch
    perl-File-Temp.noarch
    perl-Filter.x86_64
    perl-GD.x86_64
    perl-Getopt-Long.noarch
    perl-Git.noarch
    perl-HTTP-Tiny.noarch
    perl-IPC-Cmd.noarch
    perl-Locale-Maketext.noarch
    perl-Locale-Maketext-Simple.noarch
    perl-Module-CoreList.noarch
    perl-Module-Load.noarch
    perl-Module-Load-Conditional.noarch
    perl-Module-Metadata.noarch
    perl-Params-Check.noarch
    perl-PathTools.x86_64
    perl-Perl-OSType.noarch
    perl-Pod-Escapes.noarch
    perl-Pod-Perldoc.noarch
    perl-Pod-Simple.noarch
    perl-Pod-Usage.noarch
    perl-Regexp-Common.noarch
    perl-Scalar-List-Utils.x86_64
    perl-Socket.x86_64
    perl-Storable.x86_64
    perl-TermReadKey.x86_64
    perl-Test-Harness.noarch
    perl-Text-ParseWords.noarch
    perl-Thread-Queue.noarch
    perl-Time-HiRes.x86_64
    perl-Time-Local.noarch
    perl-constant.noarch
    perl-debuginfo.x86_64
    perl-devel.x86_64
    perl-libs.x86_64
    perl-macros.x86_64
    perl-parent.noarch
    perl-podlators.noarch
    perl-srpm-macros.noarch
    perl-threads.x86_64
    perl-threads-shared.x86_64
    perl-version.x86_64
    pigz.x86_64
    pinentry.x86_64
    pixman.x86_64
    pixman-devel.x86_64
    pkgconfig.x86_64
    plexus-cipher.noarch
    plexus-classworlds.noarch
    plexus-component-api.noarch
    plexus-containers-component-annotations.noarch
    1.5.5-14.el7
    plexus-containers-container-default.noarch
    1.5.5-14.el7
    plexus-interactivity.noarch
    plexus-interpolation.noarch
    plexus-sec-dispatcher.noarch
    plexus-utils.noarch
    policycoreutils.x86_64
    policycoreutils-python.x86_64
    popt.x86_64
    procps-ng.x86_64
    pth.x86_64
    pygpgme.x86_64
    pyliblzma.x86_64
    pyparsing.noarch
    python.x86_64
    python-IPy.noarch
    python-babel.noarch
    python-backports.x86_64
    python-backports-ssl_match_hostname.noarch
    3.5.0.1-1.el7
    python-bcc.x86_64
    python-cffi.x86_64
    python-chardet.noarch
    python-debuginfo.x86_64
    python-devel.x86_64
    python-enum34.noarch
    python-gobject-base.x86_64
    python-idna.noarch
    python-iniparse.noarch
    python-ipaddress.noarch
    python-javapackages.noarch
    python-jinja2.noarch
    python-kitchen.noarch
    python-libs.x86_64
    python-lxml.x86_64
    python-markupsafe.x86_64
    python-meld3.x86_64
    python-netaddr.noarch
    python-paramiko.noarch
    python-ply.noarch
    python-pycparser.noarch
    python-pycurl.x86_64
    python-rpm-macros.noarch
    python-setuptools.noarch
    python-six.noarch
    python-srpm-macros.noarch
    python-urlgrabber.noarch
    python2-cryptography.x86_64
    python2-httplib2.noarch
    python2-jmespath.noarch
    python2-psutil.x86_64
    python2-pyasn1.noarch
    python2-rpm-macros.noarch
    python3.x86_64
    python3-devel.x86_64
    python3-libs.x86_64
    python3-pip.noarch
    python3-rpm-generators.noarch
    python3-rpm-macros.noarch
    python3-setuptools.noarch
    python3-termcolor.noarch
    python36-argcomplete.noarch
    python36-colorama.noarch
    python36-pydot.noarch
    python36-pyparsing.noarch
    python36-six.noarch
    pyxattr.x86_64
    qdox.noarch
    qperf.x86_64
    qrencode-libs.x86_64
    qt.x86_64
    qt-settings.noarch
    qt-x11.x86_64
    rdma-core.x86_64
    readline.x86_64
    readline-devel.x86_64
    redhat-rpm-config.noarch
    regexp.noarch
    rest.x86_64
    rhash.x86_64
    rlwrap.x86_64
    rootfiles.noarch
    rpm.x86_64
    rpm-build-libs.x86_64
    rpm-libs.x86_64
    rpm-python.x86_64
    rsync.x86_64
    ruby.x86_64
    ruby-devel.x86_64
    ruby-irb.noarch
    ruby-libs.x86_64
    rubygem-bigdecimal.x86_64
    rubygem-io-console.x86_64
    rubygem-json.x86_64
    rubygem-psych.x86_64
    rubygem-rdoc.noarch
    rubygems.noarch
    rust.x86_64
    rust-std-static.x86_64
    scl-utils.x86_64
    scl-utils-build.x86_64
    screen.x86_64
    @updates
    sed.x86_64
    setools-libs.x86_64
    setup.noarch
    shadow-utils.x86_64
    shared-mime-info.x86_64
    sil-abyssinica-fonts.noarch
    sil-nuosu-fonts.noarch
    sil-padauk-fonts.noarch
    sisu-inject-bean.noarch
    sisu-inject-plexus.noarch
    slang.x86_64
    slang-debuginfo.x86_64
    slf4j.noarch
    smc-fonts-common.noarch
    smc-meera-fonts.noarch
    sqlite.x86_64
    sshpass.x86_64
    stix-fonts.noarch
    strace.x86_64
    subversion.x86_64
    subversion-libs.x86_64
    sudo.x86_64
    supervisor.noarch
    sysstat.x86_64
    systemd.x86_64
    systemd-libs.x86_64
    systemd-sysv.x86_64
    systemtap-sdt-devel.x86_64
    sysvinit-tools.x86_64
    tar.x86_64
    tcl.x86_64
    tcl-devel.x86_64
    tcp_wrappers-libs.x86_64
    tcpdump.x86_64
    thai-scalable-fonts-common.noarch
    thai-scalable-waree-fonts.noarch
    the_silver_searcher.x86_64
    tldr.noarch
    tmux.x86_64
    tomcat-servlet-3.0-api.noarch
    traceroute.x86_64
    tree.x86_64
    trousers.x86_64
    ttmkfdir.x86_64
    tzdata.noarch
    tzdata-java.noarch
    ucs-miscfixed-fonts.noarch
    unibilium.x86_64
    unzip.x86_64
    urw-base35-bookman-fonts.noarch
    urw-base35-c059-fonts.noarch
    urw-base35-d050000l-fonts.noarch
    urw-base35-fonts.noarch
    urw-base35-fonts-common.noarch
    urw-base35-gothic-fonts.noarch
    urw-base35-nimbus-mono-ps-fonts.noarch
    20170801-10.el7
    urw-base35-nimbus-roman-fonts.noarch
    urw-base35-nimbus-sans-fonts.noarch
    urw-base35-p052-fonts.noarch
    urw-base35-standard-symbols-ps-fonts.noarch
    20170801-10.el7
    urw-base35-z003-fonts.noarch
    ustr.x86_64
    util-linux.x86_64
    valgrind.x86_64
    vim-common.x86_64
    vim-enhanced.x86_64
    vim-filesystem.x86_64
    vim-minimal.x86_64
    vlgothic-fonts.noarch
    wget.x86_64
    which.x86_64
    wqy-microhei-fonts.noarch
    wqy-zenhei-fonts.noarch
    xalan-j2.noarch
    xbean.noarch
    xerces-j2.noarch
    xkeyboard-config.noarch
    xml-common.noarch
    xml-commons-apis.noarch
    xml-commons-resolver.noarch
    xorg-x11-font-utils.x86_64
    xorg-x11-fonts-Type1.noarch
    xorg-x11-proto-devel.noarch
    xorg-x11-server-utils.x86_64
    xorg-x11-xauth.x86_64
    xorg-x11-xinit.x86_64
    xz.x86_64
    xz-debuginfo.x86_64
    xz-libs.x86_64
    yum.noarch
    yum-metadata-parser.x86_64
    yum-plugin-auto-update-debug-info.noarch
    1.1.31-54.el7_8
    yum-plugin-fastestmirror.noarch
    yum-plugin-ovl.noarch
    yum-utils.noarch
    zip.x86_64
    zlib.x86_64
    zlib-debuginfo.x86_64
    zlib-devel.x86_64
    zlib-static.x86_64
    zsh.x86_64
"

echo $repos
sudo yum install -y $repos
