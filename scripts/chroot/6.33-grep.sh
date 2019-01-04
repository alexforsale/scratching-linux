#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-grep-done ]];then
    pushd $BUILDDIR
    grep=$(grep "grep-" /sources/wget-list | grep tar | sed 's/^.*grep-/grep-/');
    tar -xf /sources/$grep;
    cd ${grep/.tar*}

    ./configure --prefix=/usr --bindir=/bin
    make
    [[ ${TEST} -eq 1 ]] && make -k check
    make install
    
    cd $BUILDDIR
    rm -rf ${grep/.tar*}
    popd
    unset grep
    touch $BUILDDIR/.chroot-grep-done
fi
