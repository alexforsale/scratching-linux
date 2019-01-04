#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-pkg-config-done ]];then
    pushd $BUILDDIR
    pkg_config=$(grep pkg-config- /sources/wget-list | grep tar | sed 's/^.*pkg-config-/pkg-config-/');
    tar -xf /sources/$pkg_config;
    cd ${pkg_config/.tar*}

    ./configure --prefix=/usr --with-internal-glib --disable-host-tool \
                --docdir=/usr/share/doc/pkg-config-0.29.2
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${pkg_config/.tar*}
    popd
    unset pkg_config
    touch $BUILDDIR/.chroot-pkg-config-done
fi
