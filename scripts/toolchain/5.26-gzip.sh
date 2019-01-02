#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.gzip-done ]];then
    pushd $BUILDDIR;
    gzip=$(grep gzip /sources/wget-list | sed 's/^.*gzip/gzip/');

    tar -xf /sources/$gzip
    cd ${gzip/.tar*}

    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

    ./configure --prefix=/tools

    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${gzip/.tar*}
    popd
    unset gzip
    touch $BUILDDIR/.gzip-done
fi
