#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-intltool-done ]];then
    pushd $BUILDDIR
    intltool=$(grep intltool- /sources/wget-list | grep tar | sed 's/^.*intltool-/intltool-/');
    tar -xf /sources/$intltool;
    cd ${intltool/.tar*}

    sed -i 's:\\\${:\\\$\\{:' intltool-update.in
    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

    cd $BUILDDIR
    rm -rf ${intltool/.tar*}
    popd
    unset intltool
    touch $BUILDDIR/.chroot-intltool-done
fi
