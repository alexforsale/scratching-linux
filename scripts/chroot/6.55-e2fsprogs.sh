#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-e2fsprogs-done ]];then
    pushd $BUILDDIR
    e2fsprogs=$(grep e2fsprogs- /sources/wget-list | grep tar | sed 's/^.*e2fsprogs-/e2fsprogs-/');
    tar -xf /sources/$e2fsprogs;
    cd ${e2fsprogs/.tar*}

    mkdir -v build && cd $_
    ../configure --prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs \
                 --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck
    make
    if [[ ${TEST} -eq 1 ]];then
        ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
        make LD_LIBRARY_PATH=/tools/lib check
    fi
    make install
    make install-libs
    chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info /usr/share/info
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

    cd $BUILDDIR
    rm -rf ${e2fsprogs/.tar*}
    popd
    unset e2fsprogs
    touch $BUILDDIR/.chroot-e2fsprogs-done
fi
