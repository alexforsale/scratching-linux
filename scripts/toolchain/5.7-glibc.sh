#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.glibc-done ]];then
    pushd $BUILDDIR
    glibc=$(grep glibc /sources/wget-list | grep tar.* | sed 's/^.*glibc/glibc/');
    tar -xf /sources/$glibc;
    mv ${glibc/.tar*} glibc
    cd glibc

    mkdir -p glibc-build lib32-glibc-build
    mkdir -v build && cd $_

    _configure_flags=(
        --prefix=/tools
        --build=$(${BUILDDIR}/glibc/scripts/config.guess)
        --enable-kernel=3.2
        --with-headers=/tools/include
        --disable-werror
        libc_cv_forced_unwind=yes
        libc_cv_c_cleanup=yes
    )

    cd ${BUILDDIR}/glibc/glibc-build
    echo "slibdir=/tools/lib" >> configparms
    echo "rtlddir=/tools/lib" >> configparms

    ../configure \
        --host=$LFS_TGT \
        --libdir=/tools/lib \
        --libexecdir=/tools/lib \
        ${_configure_flags[@]}

    cd ${BUILDDIR}/glibc/lib32-glibc-build
    echo "slibdir=/tools/lib32" >> configparms
    echo "rtlddir=/tools/lib32" >> configparms

    CC="$LFS_TGT-gcc -m32 -mstackrealign" \
      ../configure \
      --host=i686-pc-linux-gnu \
      --libdir=/tools/lib32 \
      --libexecdir=/tools/lib32 \
      ${_configure_flags[@]}

    cd ${BUILDDIR}/glibc/glibc-build
    make

    cd ${BUILDDIR}/glibc/lib32-glibc-build
    make

    cd ${BUILDDIR}/glibc/lib32-glibc-build
    pkgdir=${BUILDDIR}/glibc/lib32-glibc-build/package32
    make install_root="$pkgdir" install
    rm -rvf "$pkgdir"/tools/{etc,sbin,bin,share,var}
    find "$pkgdir/tools/include" -type f -not -name '*-32.h' -delete
    install -d "$pkgdir/tools/lib"
    ln -s ../lib32/ld-linux.so.2 "$pkgdir/tools/lib/"

    cd "${BUILDDIR}/glibc/glibc-build"
    pkgdir=${BUILDDIR}/glibc/glibc-build/package
    make  install_root="$pkgdir" install

    install -v -d "$pkgdir/tools/etc/ld.so.conf.d"
    install -v -Dm644 "${SCRIPTDIR}/scripts/ld.so.conf" "$pkgdir/cross-tools/etc/ld.so.conf"
    install -v -Dm644 "${SCRIPTDIR}/scripts/lib32-glibc.conf" "$pkgdir/cross-tools/etc/ld.so.conf.d/lib32-glibc.conf"

    cd ${BUILDDIR}/glibc
    cp -rv glibc-build/package/tools/* /tools/
    cp -rv lib32-glibc-build/package32/tools/* /tools

    if [[ -f /tools/bin/${LFS_TGT}-gcc ]] && [[ ! -f /tools/bin/cc ]];then
    cd /tmp/
    echo 'int main(){}' > dummy.c
    $LFS_TGT-gcc -m64 dummy.c -o dummy64
    $LFS_TGT-gcc -m32 dummy.c -o dummy32
    readelf -l dummy{32,64} | grep ': /tools'
    fi
    
    cd $BUILDDIR
    rm -rf glibc
    popd
    unset glibc
    touch $BUILDDIR/.glibc-done
fi
