#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-bc-done ]];then
    pushd $BUILDDIR
    bc=$(grep bc-1 /sources/wget-list | grep tar | sed 's/^.*bc-1/bc-1/');
    tar -xf /sources/$bc;
    cd ${bc/.tar*}

    cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

    ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
    ln -sfv libncurses.so.6 /usr/lib/libncurses.so

    sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

    ./configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info
    make
    [[ ${TEST} -eq 1 ]] && echo "quit" | ./bc/bc -l Test/checklib.b
    make install
    
    cd $BUILDDIR
    rm -rf ${bc/.tar*}
    popd
    unset bc
    touch $BUILDDIR/.chroot-bc-done
fi
