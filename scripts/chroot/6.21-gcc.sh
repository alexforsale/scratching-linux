#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gcc-done ]];then
    pushd $BUILDDIR
    gcc=$(grep gcc- /sources/wget-list | grep tar | sed 's/^.*gcc-/gcc-/');
    tar -xf /sources/$gcc;
    cd ${gcc/.tar*}

    case $(uname -m) in
        x86_64)
            sed -e '/m64=/s/lib64/lib/' \
                -i.orig gcc/config/i386/t-linux64
            ;;
    esac

    rm -f /usr/lib/gcc

    mkdir -v build && cd $_
    SED=sed \
       ../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap \
       --disable-libmpx --with-system-zlib
    make

    if [[ ${TEST} -eq 1 ]];then
        ulimit -s 32768
        rm ../gcc/testsuite/g++.dg/pr83239.C
        chown -Rv nobody .
        su nobody -s /bin/bash -c "PATH=$PATH make -k check" || true
        ../contrib/test_summary
    fi

    make install
    ln -sv ../usr/bin/cpp /lib
    ln -sv gcc /usr/bin/cc

    install -v -dm755 /usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
       /usr/lib/bfd-plugins/

    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    readelf -l a.out | grep ': /lib'

    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

    grep -B4 '^ /usr/include' dummy.log

    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

    grep "/lib.*/libc.so.6 " dummy.log

    grep found dummy.log

    rm -v dummy.c a.out dummy.log

    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

    cd $BUILDDIR
    rm -rf ${gcc/.tar*}
    popd
    unset gcc
    touch $BUILDDIR/.chroot-gcc-done
fi
