#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gawk-done ]];then
    pushd $BUILDDIR
    gawk=$(grep gawk- /sources/wget-list | grep tar | sed 's/^.*gawk-/gawk-/');
    tar -xf /sources/$gawk;
    cd ${gawk/.tar*}
    
    sed -i 's/extras//' Makefile.in
    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    mkdir -v /usr/share/doc/gawk-4.2.1
    cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.2.1

    cd $BUILDDIR
    rm -rf ${gawk/.tar*}
    popd
    unset gawk
    touch $BUILDDIR/.chroot-gawk-done
fi
