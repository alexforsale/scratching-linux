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
