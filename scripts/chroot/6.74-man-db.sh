#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-man-db-done ]];then
    pushd $BUILDDIR
    man_db=$(grep man-db- /sources/wget-list | grep tar | sed 's/^.*man-db-/man-db-/');
    tar -xf /sources/$man_db;
    cd ${man_db/.tar*}

    ./configure --prefix=/usr --docdir=/usr/share/doc/man-db-2.8.4 --sysconfdir=/etc --disable-setuid \
                --enable-cache-owner=bin --with-browser=/usr/bin/lynx --with-vgrind=/usr/bin/vgrind \
                --with-grap=/usr/bin/grap --with-systemdtmpfilesdir=
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${man_db/.tar*}
    popd
    unset man_db
    touch $BUILDDIR/.chroot-man-db-done
fi
