#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.m4-done ]];then
    pushd $BUILDDIR;
    m4=$(grep m4 /sources/wget-list | sed 's/^.*m4/m4/');

    tar -xf /sources/$m4
    cd ${m4/.tar*}

    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

    ./configure --prefix=/tools
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${m4/.tar*}
    popd
    unset m4
    touch $BUILDDIR/.m4-done
fi
