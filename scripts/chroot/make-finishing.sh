#!/bin/bash
set -e

new_chroot_lfs_pacman /sources/scripts/chroot/make-local-repositories.sh

_args=(--nocheck --clean --cleanbuild --syncdeps --rmdeps --noconfirm --install)

# deps for openssh
new_chroot_lfs_pacman make_package libedit ${_args[@]} --asdeps
new_chroot_lfs_pacman make_package ldns ${_args[@]} --asdeps

# openssh
new_chroot_lfs_pacman make_package openssh ${_args[@]}

# git
new_chroot_lfs_pacman make_package git ${_args[@]}

# deps for glib2
new_chroot_lfs_pacman make_package autoconf-archive ${_args[@]} --asdeps
new_chroot_lfs_pacman make_package dbus ${_args[@]} --asdeps

# deps for sshfs
new_chroot_lfs_pacman make_package fuse3 ${_args[@]} --asdeps
new_chroot_lfs_pacman make_package glib2 ${_args[@]} --asdeps
new_chroot_lfs_pacman make_package docutils ${_args[@]} --asdeps

# sshfs
new_chroot_lfs_pacman make_package sshfs ${_args[@]}

# dhcpcd
new_chroot_lfs_pacman make_package dhcpcd ${_args[@]}

# lsb release
new_chroot_lfs_pacman make_package perl-locale-gettext \
                      help2man lsb_release ${_args[@]}

# end
# rebuild linux kernel with additional configs from packages
new_chroot_lfs_pacman make_package linux ${_args[@]} -f

new_chroot_lfs /sources/scripts/chroot/make-cleanups.sh
