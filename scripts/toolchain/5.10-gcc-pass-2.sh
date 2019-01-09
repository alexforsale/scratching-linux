#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.gcc-pass-2-done ]];then
    pushd $BUILDDIR
    gcc=$(grep gcc /sources/wget-list | sed 's/^.*gcc/gcc/');
    mpfr=$(grep mpfr /sources/wget-list | sed 's/^.*mpfr/mpfr/');
    gmp=$(grep gmp /sources/wget-list | sed 's/^.*gmp/gmp/');
    mpc=$(grep mpc /sources/wget-list | sed 's/^.*mpc/mpc/');

    if [[ ! -f /sources/gcc-pure64.patch ]];then
        pushd /sources
        wget https://gist.githubusercontent.com/alexforsale/a1339a64882ac7df065404f0af9bb639/raw/9586520039c5b83b96aadfff9aa206bd1bb6972d/gcc-pure64.patch
        popd
    fi

    tar -xf /sources/$gcc
    cd ${gcc/.tar*}

    patch -Np1 -i /sources/gcc-pure64.patch
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

    sed -i "s|\$(if \$(wildcard \$(shell echo \$(SYSTEM_HEADER_DIR))/../../usr/lib32),../lib32)|../lib32|" gcc/config/i386/t-linux64
    
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

    CC=$LFS_TGT-gcc \
      CXX=$LFS_TGT-g++ \
      AR=$LFS_TGT-ar \
      RANLIB=$LFS_TGT-ranlib \
      ../configure \
      --prefix=/tools \
      --with-local-prefix=/tools \
      --with-native-system-header-dir=/tools/include \
      --enable-languages=c,c++ \
      --disable-libstdcxx-pch \
      --enable-multilib \
      --disable-bootstrap \
      --disable-libgomp

    make
    make install

    ln -sv gcc /tools/bin/cc

    echo 'int main(){}' > dummy.c
    cc -m64 dummy.c -o dummy64
    cc -m32 dummy.c -o dummy32
    readelf -l dummy32 | grep ': /tools'
    readelf -l dummy64 | grep ': /tools'

    rm -v dummy*

    cd $BUILDDIR
    rm -rf ${gcc/.tar*}
    popd
    unset gcc mpfr mpc gmp
    touch $BUILDDIR/.gcc-pass-2-done
fi
