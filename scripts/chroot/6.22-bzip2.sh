#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-bzip2-done ]];then
    pushd $BUILDDIR
    bzip2=$(grep bzip2- /sources/wget-list | grep tar | sed 's/^.*bzip2-/bzip2-/');
    tar -xf /sources/$bzip2;
    cd ${bzip2/.tar*}

    patch -Np1 -i /sources/bzip2-1.0.6-install_docs-1.patch
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    make -f Makefile-libbz2_so
    make clean

    make
    make PREFIX=/usr install

    cp -v bzip2-shared /bin/bzip2
    cp -av libbz2.so* /lib
    ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
    rm -v /usr/bin/{bunzip2,bzcat,bzip2}
    ln -sv bzip2 /bin/bunzip2
    ln -sv bzip2 /bin/bzcat

    cd $BUILDDIR
    rm -rf ${bzip2/.tar*}
    popd
    unset bzip2
    touch $BUILDDIR/.chroot-bzip2-done
fi
