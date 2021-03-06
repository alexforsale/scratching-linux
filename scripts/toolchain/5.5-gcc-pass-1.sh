#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.gcc-pass-1-done ]];then
    pushd $BUILDDIR
    gcc=$(grep gcc /sources/wget-list | sed 's/^.*gcc/gcc/');
    mpfr=$(grep mpfr /sources/wget-list | sed 's/^.*mpfr/mpfr/');
    gmp=$(grep gmp /sources/wget-list | sed 's/^.*gmp/gmp/');
    mpc=$(grep mpc /sources/wget-list | sed 's/^.*mpc/mpc/');

    tar -xf /sources/$gcc
    cd ${gcc/.tar*}

    for file in gcc/config/{linux,i386/linux{,64}}.h
    do
        cp -uv $file{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
            -e 's@/usr@/tools@g' $file.orig > $file
        echo '
        #undef STANDARD_STARTFILE_PREFIX_1
        #undef STANDARD_STARTFILE_PREFIX_2
        #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
        #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
        touch $file.orig
    done

    case $(uname -m) in
        x86_64)
            sed -e '/m64=/s/lib64/lib/' \
                -i.orig gcc/config/i386/t-linux64
            ;;
    esac

    tar -xf /sources/$mpfr
    mv ${mpfr/.tar*} mpfr
    tar -xf /sources/$gmp
    mv ${gmp/.tar*} gmp
    tar -xf /sources/$mpc
    mv ${mpc/.tar*} mpc

    mkdir -v build && cd $_
    ../configure \
    --target=$LFS_TGT \
    --prefix=/tools \
    --with-glibc-version=2.11 \
    --with-sysroot=$LFS \
    --with-newlib \
    --without-headers \
    --with-local-prefix=/tools \
    --with-native-system-header-dir=/tools/include \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-decimal-float \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libmpx \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++
    make
    make install
    cd $BUILDDIR
    rm -rf ${gcc/.tar*}
    popd
    unset gcc mpfr mpc gmp
    touch $BUILDDIR/.gcc-pass-1-done
fi
