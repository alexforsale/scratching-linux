#!/bin/bash
set -e
set -x

. settings.conf

if [[ -z "LFS" ]];then
    echo -e "LFS not specified in settings.conf";
    echo -e "using default location /mnt/lfs";
    export LFS=/mnt/lfs
fi

if [[ -z "${PARTITION}" ]];then
    echo -e "PARTITION not set";
    echo -e "please set the value in settings.conf";
    exit 1
fi

[[ ! -d ${LFS} ]] && sudo mkdir -pv ${LFS}
if [[ -z "$(mount | grep ${LFS})" ]];then
    sudo mount -t ${PARTITION_TYPE} -o "${PARTITION_OPTS}" ${PARTITION} ${LFS};
fi

# boot
if [[ -n "${PARTITION_BOOT}" ]];then
    if [[ -z "$(mount | grep ${PARTITION_BOOT})" ]];then
        sudo mount -t ${PARTITION_BOOT_TYPE} -o ${PARTITION_BOOT_OPTS} ${PARTITION_BOOT} ${LFS}/boot
    fi
fi

# swap
if [[ -n "${SWAP}" ]];then
    if [[ -z "$(mount | grep $SWAP)" ]];then
        sudo swapon $SWAP;
    fi
fi

# sources dir
[[ ! -d $LFS/sources ]] && sudo mkdir -pv $LFS/sources;
if [[ -n "$SOURCES" ]];then
    if [[ -n ${SOURCES} ]];then
        [[ -z "$(mount | grep $LFS/sources)" ]] &&
            sudo mount --bind ${SOURCES} $LFS/sources;
    fi
    # symlink $LFS/sources/ to /sources
    if [[ ! -e /sources ]];then
        sudo ln -sv $LFS/sources /
    fi
fi
sudo chmod a+wt $LFS/sources

# location for pacman local repo
[[ ! -d $LFS/srv/pacman/ ]] && sudo mkdir -pv $LFS/srv/pacman/{repos,recipes}
[[ ! -d $LFS/srv/pacman/repos ]] && sudo mkdir -pv $LFS/srv/pacman/repos
[[ ! -d $LFS/srv/pacman/recipes ]] && sudo mkdir -pv $LFS/srv/pacman/recipes

# mount bind $SCRIPTDIR/recipes
if [[ -z "$(mount | grep $LFS/srv/pacman/recipes)" ]];then
    sudo mount -v --bind ${SCRIPTDIR}/recipes $LFS/srv/pacman/recipes
fi
