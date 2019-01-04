#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-findutils-done ]];then
    pushd $BUILDDIR
    findutils=$(grep findutils- /sources/wget-list | grep tar | sed 's/^.*findutils-/findutils-/');
    tar -xf /sources/$findutils;
    cd ${findutils/.tar*}

    sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
    sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
    echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

    ./configure --prefix=/usr --localstatedir=/var/lib/locate
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    mv -v /usr/bin/find /bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

    cd $BUILDDIR
    rm -rf ${findutils/.tar*}
    popd
    unset findutils
    touch $BUILDDIR/.chroot-findutils-done
fi
