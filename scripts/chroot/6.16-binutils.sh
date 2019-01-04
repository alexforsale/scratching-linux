#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-binutils-done ]];then
    pushd $BUILDDIR
    binutils=$(grep binutils- /sources/wget-list | grep tar | sed 's/^.*binutils-/binutils-/');
    tar -xf /sources/$binutils;
    cd ${binutils/.tar*}

    expect -c "spawn ls"

    mkdir -v build && cd $_

    ../configure --prefix=/usr --enable-gold --enable-ld=default --enable-plugins \
                 --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib

    make tooldir=/usr
    [[ ${TEST} -eq 1 ]] && make -k check || true
    
    make tooldir=/usr install

    cd $BUILDDIR
    rm -rf ${binutils/.tar*}
    popd
    unset binutils
    touch $BUILDDIR/.chroot-binutils-done
fi
