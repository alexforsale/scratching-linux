#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-bash-done ]];then
    pushd $BUILDDIR
    bash=$(grep bash- /sources/wget-list | grep tar | sed 's/^.*bash-/bash-/');
    tar -xf /sources/$bash;
    cd ${bash/.tar*}

    ./configure --prefix=/usr --docdir=/usr/share/doc/bash-4.4.18 \
                --without-bash-malloc --with-installed-readline
    make

    if [[ ${TEST} -eq 1 ]];then
        chown -Rv nobody .
        su nobody -s /bin/bash -c "PATH=$PATH make tests" || true
    fi
    
    make install
    mv -vf /usr/bin/bash /bin
    
    cd $BUILDDIR
    rm -rf ${bash/.tar*}
    popd
    unset bash
    touch $BUILDDIR/.chroot-bash-done
fi
