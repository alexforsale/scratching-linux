#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-ninja-done ]];then
    pushd $BUILDDIR
    ninja=$(grep ninja- /sources/wget-list | grep tar | sed 's/^.*ninja-/ninja-/');
    tar -xf /sources/$ninja;
    cd ${ninja/.tar*}

    patch -Np1 -i /sources/ninja-1.8.2-add_NINJAJOBS_var-1.patch
    python3 configure.py --bootstrap

    python3 configure.py
    if [[ ${TEST} -eq 1 ]];then
        ./ninja ninja_test
        ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
    fi

    install -vm755 ninja /usr/bin/
    install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
    install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

    cd $BUILDDIR
    rm -rf ${ninja/.tar*}
    popd
    unset ninja
    touch $BUILDDIR/.chroot-ninja-done
fi
