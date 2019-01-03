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
[[ ! -f /sources/build/.strip-done ]] &&
    su -c "${SCRIPTDIR}/scripts/toolchain/make-toolchain.sh" lfs
