#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gzip-done ]];then
    pushd $BUILDDIR
    gzip=$(grep gzip- /sources/wget-list | grep tar | sed 's/^.*gzip-/gzip-/');
    tar -xf /sources/$gzip;
    cd ${gzip/.tar*}

    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    mv -v /usr/bin/gzip /bin

    cd $BUILDDIR
    rm -rf ${gzip/.tar*}
    popd
    unset gzip
    touch $BUILDDIR/.chroot-gzip-done
fi
