#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-perl-done ]];then
    pushd $BUILDDIR
    perl=$(grep perl- /sources/wget-list | grep tar | sed 's/^.*perl-/perl-/');
    tar -xf /sources/$perl;
    cd ${perl/.tar*}

    echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
    export BUILD_ZLIB=False
    export BUILD_BZIP2=0
    
    sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr -Dman1dir=/usr/share/man/man1 \
       -Dman3dir=/usr/share/man/man3 -Dpager="/usr/bin/less -isR" -Duseshrplib -Dusethreads
    make
    [[ ${TEST} -eq 1 ]] && make -k test || true
    make install

    cd $BUILDDIR
    rm -rf ${perl/.tar*}
    popd
    unset perl BUILD_ZLIB BUILD_BZIP2
    touch $BUILDDIR/.chroot-perl-done
fi
