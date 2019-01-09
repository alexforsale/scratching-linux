#!/bin/bash
set -e

# dependency for libsasl & libtirpc
if [[ ! -f /sources/krb5-1.16.1.tar.gz ]];then
    pushd /sources
    wget https://web.mit.edu/kerberos/dist/krb5/1.16/krb5-1.16.1.tar.gz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-krb5.sh
new_chroot_lfs /sources/scripts/chroot/addition-krb5.sh

# dependencies for linux-pam
if [[ ! -f /sources/libtirpc-1.1.4.tar.bz2 ]];then
    pushd /sources
    wget http://downloads.sourceforge.net/sourceforge/libtirpc/libtirpc-1.1.4.tar.bz2
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-libtirpc.sh
new_chroot_lfs /sources/scripts/chroot/addition-libtirpc.sh

if [[ ! -f /sources/cracklib-2.9.6.tar.gz ]];then
    pushd /sources
    wget https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz
    popd
fi
if [[ ! -f /sources/cracklib-words-2.9.6.gz ]];then
    pushd /sources
    wget https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.gz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-cracklib.sh
new_chroot_lfs /sources/scripts/chroot/addition-cracklib.sh

new_chroot_lfs_pacman /sources/scripts/chroot/addition-pambase.sh
new_chroot_lfs /sources/scripts/chroot/addition-pambase.sh

if [[ ! -f /sources/db-5.3.28.tar.gz ]];then
    pushd /sources
    wget http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-berkeley-db.sh
new_chroot_lfs /sources/scripts/chroot/addition-berkeley-db.sh

# dependencies for libldap

if [[ ! -f /sources/cyrus-sasl-2.1.26.tar.gz ]];then
    pushd /sources
    wget https://www.cyrusimap.org/releases/cyrus-sasl-2.1.26.tar.gz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-cyrus-sasl.sh
new_chroot_lfs /sources/scripts/chroot/addition-cyrus-sasl.sh

new_chroot_lfs_pacman /sources/scripts/chroot/addition-chrpath.sh
new_chroot_lfs /sources/scripts/chroot/addition-chrpath.sh

new_chroot_lfs_pacman /sources/scripts/chroot/addition-unixodbc.sh
new_chroot_lfs /sources/scripts/chroot/addition-unixodbc.sh

# dependency for libgcrypt
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libgpg-error.sh
new_chroot_lfs /sources/scripts/chroot/addition-libgpg-error.sh

# dependencies for sudo
if [[ ! -f /sources/libgcrypt-1.8.4.tar.bz2 ]];then
    pushd /sources
    wget https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.4.tar.bz2
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-libgcrypt.sh
new_chroot_lfs /sources/scripts/chroot/addition-libgcrypt.sh

if [[ ! -f /sources/openldap-2.4.46.tgz ]];then
    pushd /sources
    wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.46.tgz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-openldap.sh
new_chroot_lfs /sources/scripts/chroot/addition-openldap.sh
new_chroot_lfs_pacman /sources/scripts/chroot/addition-openldap.sh pass-2
new_chroot_lfs /sources/scripts/chroot/addition-openldap.sh pass-2

if [[ ! -f /sources/Linux-PAM-1.3.0.tar.bz2 ]];then
    pushd /sources
    wget http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-linux-pam.sh
new_chroot_lfs /sources/scripts/chroot/addition-linux-pam.sh

# sudo
if [[ ! -f /sources/sudo-1.8.23.tar.gz ]];then
    pushd /sources
    wget https://www.sudo.ws/sudo/dist/sudo-1.8.23.tar.gz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-sudo.sh
new_chroot_lfs /sources/scripts/chroot/addition-sudo.sh
new_chroot_lfs /sources/scripts/chroot/addition-sudo.sh post-install

# dependencies for gnutls
if [[ ! -f /sources/libtasn1-4.13.tar.gz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libtasn1.sh

if [[ ! -f /sources/nettle-3.4.1.tar.gz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-nettle.sh

if [[ ! -f /sources/p11-kit-0.23.13.tar.gz ]];then
    pushd /sources
    wget https://github.com/p11-glue/p11-kit/releases/download/0.23.13/p11-kit-0.23.13.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-p11-kit.sh

if [[ ! -f /sources/libidn-1.35.tar.gz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/libidn/libidn-1.35.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libidn.sh

if [[ ! -f /sources/libunistring-0.9.10.tar.xz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libunistring.sh

# dependencies for gnupg
if [[ ! -f /sources/gnutls-3.6.5.tar.xz ]];then
    pushd /sources
    wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.5.tar.xz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-gnutls.sh

if [[ ! -f /sources/libassuan-2.5.1.tar.bz2 ]];then
    pushd /sources
    wget https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.1.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libassuan.sh

if [[ ! -f /sources/libksba-1.3.5.tar.bz2 ]];then
    pushd /sources
    wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.5.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libksba.sh

if [[ ! -f /sources/npth-1.6.tar.bz2 ]];then
    pushd /sources
    wget ftp://ftp.gnupg.org/gcrypt/npth/npth-1.6.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-npth.sh

if [[ ! -f /sources/pinentry-1.1.0.tar.bz2 ]];then
    pushd /sources
    wget https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-pinentry.sh

# dependency for libusb-compat
if [[ ! -f /sources/libusb-1.0.22.tar.bz2 ]];then
    pushd /sources
    wget https://github.com/libusb/libusb/releases/download/v1.0.22/libusb-1.0.22.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libusb.sh

if [[ ! -f /sources/libusb-compat-0.1.5.tar.bz2 ]];then
    pushd /sources
    wget http://downloads.sourceforge.net/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libusb-compat.sh

if [[ ! -f /sources/pcsc-lite-1.8.24.tar.bz2 ]];then
    pushd /sources
    wget https://pcsclite.apdu.fr/files/pcsc-lite-1.8.24.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-pcsclite.sh

# dependencies for gpgme
if [[ ! -f /sources/gnupg-2.2.11.tar.bz2 ]];then
    pushd /sources
    wget https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.11.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-gnupg.sh

# dependency for wget
if [[ ! -f /sources/pcre-8.42.tar.bz2 ]];then
    pushd /sources
    wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-pcre.sh

# dependency for make-ca
if [[ ! -f /sources/wget-1.19.5.tar.lz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.lz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-wget.sh

# dependencies for curl
if [[ ! -f /sources/make-ca-1.0.tar.xz ]];then
    pushd /sources
    wget https://github.com/djlucas/make-ca/releases/download/v1.0/make-ca-1.0.tar.xz
    popd
fi

new_chroot_lfs_pacman /sources/scripts/chroot/addition-make-ca.sh

if [[ ! -f /sources/nghttp2-1.34.0.tar.xz ]];then
    pushd /sources
    wget https://github.com/nghttp2/nghttp2/releases/download/v1.34.0/nghttp2-1.34.0.tar.xz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libnghttp2.sh

if [[ ! -f /sources/libssh2-1.8.0.tar.gz ]];then
    pushd /sources
    wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-libssh2.sh

# dependencies for pacman
if [[ ! -f /sources/curl-7.61.0.tar.gz ]];then
    pushd /sources
    wget https://curl.haxx.se/download/curl-7.61.0.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-curl.sh

# dependency for gpgme
if [[ ! -f /sources/Python-2.7.15.tar.xz ]];then
    pushd /sources
    wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tar.xz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-python2.sh

if [[ ! -f /sources/which-2.21.tar.gz ]];then
    pushd /sources
    wget https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-which.sh

if [[ ! -f /sources/gpgme-1.11.1.tar.bz2 ]];then
    pushd /sources
    wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.11.1.tar.bz2
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-gpgme.sh

# pacman
if [[ ! -f /sources/pacman-5.1.2.tar.gz ]];then
    pushd /sources
    wget https://sources.archlinux.org/other/pacman/pacman-5.1.2.tar.gz
    popd
fi
new_chroot_lfs_pacman /sources/scripts/chroot/addition-pacman.sh
