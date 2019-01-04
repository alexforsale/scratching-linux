#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-sysklogd-done ]];then
    pushd $BUILDDIR
    sysklogd=$(grep sysklogd- /sources/wget-list | grep tar | sed 's/^.*sysklogd-/sysklogd-/');
    tar -xf /sources/$sysklogd;
    cd ${sysklogd/.tar*}
    
    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
    sed -i 's/union wait/int/' syslogd.c

    make
    make BINDIR=/sbin install

    cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF

    cd $BUILDDIR
    rm -rf ${sysklogd/.tar*}
    popd
    unset sysklogd
    touch $BUILDDIR/.chroot-sysklogd-done
fi
