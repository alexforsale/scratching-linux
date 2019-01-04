#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-linux-done ]];then
    pushd $BUILDDIR
    linux=$(grep linux-4 /sources/wget-list | grep tar | sed 's/^.*linux-4/linux-4/');
    tar -xf /sources/$linux;
    cd ${linux/.tar*}

    make mrproper
    make x86_64_defconfig
    cat > lfs.config << "EOF"
CONFIG_UNWINDER_FRAME_POINTER=y
EOF
    ./scripts/kconfig/merge_config.sh .config lfs.config
    ./scripts/kconfig/merge_config.sh .config /sources/kernelconfig.conf 
    make
    make modules_install

    cp -iv arch/x86/boot/bzImage /boot/vmlinuz-4.18.5-lfs-8.3
    cp -iv System.map /boot/System.map-4.18.5
    cp -iv .config /boot/config-4.18.5

    install -d /usr/share/doc/linux-4.18.5
    cp -r Documentation/* /usr/share/doc/linux-4.18.5

    install -v -m755 -d /etc/modprobe.d
    cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

    cd $BUILDDIR
    rm -rf ${linux/.tar*}
    popd
    unset linux
    touch $BUILDDIR/.chroot-linux-done
fi
