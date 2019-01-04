#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.findutils-done ]];then
    pushd $BUILDDIR;
    findutils=$(grep findutils /sources/wget-list | sed 's/^.*findutils/findutils/');

    tar -xf /sources/$findutils
    cd ${findutils/.tar*}

    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
    sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
    echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

    ./configure --prefix=/tools
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${findutils/.tar*}
    popd
    unset findutils
    touch $BUILDDIR/.findutils-done
fi
