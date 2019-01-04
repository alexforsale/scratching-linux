#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-expat-done ]];then
    pushd $BUILDDIR
    expat=$(grep expat- /sources/wget-list | grep tar | sed 's/^.*expat-/expat-/');
    tar -xf /sources/$expat;
    cd ${expat/.tar*}

    sed -i 's|usr/bin/env |bin/|' run.sh.in

    ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/expat-2.2.6
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6

    cd $BUILDDIR
    rm -rf ${expat/.tar*}
    popd
    unset expat
    touch $BUILDDIR/.chroot-expat-done
fi
