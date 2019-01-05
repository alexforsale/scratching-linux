#!/bin/bash
set -ex

[ -z ${SCRIPTDIR} ] &&
    SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export SCRIPTDIR

. settings.conf
export MAKEFLAGS BUILDDIR LFS SOURCES
# check host system requirement
bash scripts/2.2-host-system-requirements.sh 

# mount partition
bash scripts/2.7-mounting-the-new-partition.sh

# packages and patches
bash scripts/3-packages-and-patches.sh 

# 4. Final Preparations

[[ ! -d $LFS/tools ]] && sudo mkdir -pv $LFS/tools
if [[ ! -e /tools ]];then
    sudo ln -sv $LFS/tools /
fi

## 4.3 Adding the lfs user
bash scripts/4.3-Adding-the-lfs-users.sh

[[ ! -d $BUILDDIR ]] && sudo mkdir -pv $BUILDDIR
if [[ "$(stat -c '%U' $BUILDDIR)" != "lfs" ]];then
    sudo chown lfs:$USER $BUILDDIR -R
fi

# pass variable for lfs user to source
sudo touch $BUILDDIR/.env
sudo chown lfs:$USER $BUILDDIR/.env
sudo chmod 777 $BUILDDIR/.env
echo "SCRIPTDIR=$SCRIPTDIR" > $BUILDDIR/.env
echo "MAKEFLAGS=\"$MAKEFLAGS\"" >> $BUILDDIR/.env
echo "BUILDDIR=$BUILDDIR" >> $BUILDDIR/.env
if [[ -n "${TEST}" ]] && [[ ${TEST} -ne 0 ]];then
    echo "TEST=$TEST" >> $BUILDDIR/.env
fi

# Constructing a Temporary System
# as lfs user
if [[ ! -f $SCRIPTDIR/tools.tar.xz ]];then
    if [[ ! -f /sources/build/.strip-done ]];then
        su -c "${SCRIPTDIR}/scripts/toolchain/make-toolchain.sh" lfs
    fi
elif [[ -f $SCRIPTDIR/tools.tar.xz ]];then
    if [[ -f /sources/build/.strip-done ]];then
        pushd $LFS
        tar -xf $SCRIPTDIR/tools.tar.xz
    fi
fi

# 5.36 Changing ownership
sudo chown -R root:root $LFS/tools

# compress /tools for backup
if [[ ! -f $SCRIPTDIR/tools.tar.xz ]];then
    pushd $LFS;
    tar -cavf $SCRIPTDIR/tools.tar.xz tools
    popd
fi

bash scripts/6.2-Preparing-virtual-kernel-filesystem.sh

# mount the scripts folder
[[ ! -d /sources/scripts ]] && mkdir -pv /sources/scripts
[[ -z "$(mount | grep /sources/scripts)" ]] &&
    sudo mount --bind $SCRIPTDIR/scripts /sources/scripts

# 6.4. Entering the Chroot Environment
chroot_lfs(){
    sudo chroot ${LFS} /tools/bin/env -i \
         HOME=/root \
         TERM=${TERM} \
         PS1='(lfs chroot) \u:\w\$ ' \
         PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
         BUILDDIR="$BUILDDIR" \
         SCRIPTDIR=/sources/scripts \
         TEST=$TEST \
         /tools/bin/bash --login +h $@
}

chroot_lfs /sources/scripts/chroot/6.5-Creating-directories.sh
chroot_lfs /sources/scripts/chroot/6.6-Creating-essential-files-and-symlinks.sh
exit
# 6. Installing Basic System Software

[[ ! -f $BUILDDIR/.chroot-bash-done ]] &&
    chroot_lfs /sources/scripts/chroot/make-chroot-1.sh

[[ ! -f $BUILDDIR/.chroot-vim-done ]] &&
    chroot_lfs /sources/scripts/chroot/make-chroot-2.sh

# strip
[[ ! -f $BUILDDIR/.chroot-strips-done ]] &&
    chroot_lfs /sources/scripts/chroot/6.79-strips.sh 

new_chroot_lfs(){
    sudo chroot "$LFS" /usr/bin/env -i \
         HOME=/root TERM="$TERM" \
         PS1='(lfs chroot) \u:\w\$ ' \
         PATH=/bin:/usr/bin:/sbin:/usr/sbin \
         BUILDDIR="$BUILDDIR" \
         SCRIPTDIR=/sources/scripts \
         TEST=$TEST \
         /bin/bash --login $@
}

# cleanup
[[ ! -f $BUILDDIR/.chroot-cleanup-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/6.80-cleanup.sh

[[ ! -f $BUILDDIR/.chroot-bootscripts-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/7.2-bootscripts.sh

# edit /etc/sysconfig/ifconfig.eth0, /etc/resolv.conf /etc/hosts afterward
[[ ! -f $BUILDDIR/.chroot-network-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/7.5-general-network-configuration.sh

# bootscripts config
[[ ! -f $BUILDDIR/.chroot-bootscripts-config-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/7.6-bootscripts-configuration.sh

# bash startup files
[[ ! -f $BUILDDIR/.chroot-startup-files-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/7.7-startup-files.sh

# Creating the /etc/fstab File
# edit this.
[[ ! -f $BUILDDIR/.chroot-fstab-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/8.2-creating-fstab.sh

# linux kernel
cp -v $SCRIPTDIR/kernelconfig.conf /sources/
if [[ -n "$(mount | grep boot)" ]];then
    sudo mount --bind /boot $LFS/boot
fi
[[ ! -f $BUILDDIR/.chroot-linux-done ]] &&
    new_chroot_lfs /sources/scripts/chroot/8.3-linux.sh

# 8.4. Using GRUB to Set Up the Boot Process
# skipped

# 9.1 The End
[[ ! -f $LFS/etc/lfs-release ]] &&
    sudo sh -c "echo 8.3 > $LFS/etc/lfs-release"
[[ ! -f $LFS/etc/lsb-release ]] &&
    sudo sh -c "cat > $LFS/etc/lsb-release << EOF
DISTRIB_ID=Linux From Scratch
DISTRIB_RELEASE=8.3
DISTRIB_CODENAME=$(whoami)
DISTRIB_DESCRIPTION=Linux From Scratch
EOF
"

sudo umount -Rv $LFS
if [[ "-n ${SOURCES}" ]];then
    rm $SOURCES/wget-list
    rm $SOURCES/.lfs-wget-done
    sudo rm $BUILDDIR/.*
fi
