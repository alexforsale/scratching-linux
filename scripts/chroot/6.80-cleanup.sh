#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-cleanup-done ]];then

    rm -rf /tmp/*

    rm -f /usr/lib/lib{bfd,opcodes}.a
    rm -f /usr/lib/libbz2.a
    rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
    rm -f /usr/lib/libltdl.a
    rm -f /usr/lib/libfl.a
    rm -f /usr/lib/libz.a
    find /usr/lib /usr/libexec -name \*.la -delete
    touch $BUILDDIR/.chroot-cleanup-done
fi
