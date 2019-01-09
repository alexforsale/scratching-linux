#!/tools/bin/bash
set -e

pathappend /tools/bin

if [[ ! -f $BUILDDIR/.chroot-adjust-toolchain-done ]];then
    [[ -n "$(ld --verbose | grep SEARCH_DIR | grep /usr)" ]] &&
        touch $BUILDDIR/.chroot-adjust-toolchain-done && exit 0

    pushd /
    mv -v /tools/bin/{ld,ld-old}
    mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
    mv -v /tools/bin/{ld-new,ld}
    ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
                         -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
                         -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
                         `dirname $(gcc --print-libgcc-file-name)`/specs
    touch $BUILDDIR/.chroot-adjust-toolchain-done
    popd

    pushd /tmp
    echo 'int main(){}' > dummy.c
    cc -m64 dummy.c -v -Wl,--verbose -o dummy64 &> dummy.log
    cc -m32 dummy.c -v -Wl,--verbose -o dummy32 &>> dummy.log

    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

    grep -B1 '^ /usr/include' dummy.log

    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

    grep "/lib.*/libc.so.6 " dummy.log

    grep found dummy.log

    popd
fi
