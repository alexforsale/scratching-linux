#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-texinfo-done ]];then
    pushd $BUILDDIR
    texinfo=$(grep texinfo- /sources/wget-list | grep tar | sed 's/^.*texinfo-/texinfo-/');
    tar -xf /sources/$texinfo;
    cd ${texinfo/.tar*}

    sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm
    ./configure --prefix=/usr --disable-static
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    make TEXMF=/usr/share/texmf install-tex

    pushd /usr/share/info
    rm -v dir
    for f in *
    do install-info $f dir 2>/dev/null
    done
    popd

    cd $BUILDDIR
    rm -rf ${texinfo/.tar*}
    popd
    unset texinfo
    touch $BUILDDIR/.chroot-texinfo-done
fi
