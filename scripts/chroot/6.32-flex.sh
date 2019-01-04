#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-flex-done ]];then
    pushd $BUILDDIR
    flex=$(grep flex- /sources/wget-list | grep tar | sed 's/^.*flex-/flex-/');
    tar -xf /sources/$flex;
    cd ${flex/.tar*}

    sed -i "/math.h/a #include <malloc.h>" src/flexdef.h

    HELP2MAN=/tools/bin/true \
            ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    ln -sv flex /usr/bin/lex

    cd $BUILDDIR
    rm -rf ${flex/.tar*}
    popd
    unset flex
    touch $BUILDDIR/.chroot-flex-done
fi
