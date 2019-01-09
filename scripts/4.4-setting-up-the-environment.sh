#!/bin/bash
set -e

. $SCRIPTDIR/settings.conf

if [[ "${UID}" != "9000" ]];then
    echo -e "this script must run under lfs user";
    exit 1
fi

if [[ ! -e ~/.bash_profile ]];then
    cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
fi

if [[ ! -e ~/.bashrc ]];then
    cat > ~/.bashrc << "EOF"
set +h
umask 022
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF
    echo "LFS=$LFS" >> ~/.bashrc
fi
