#!/bin/bash
set -ex

. settings.conf

# check host system requirement
bash scripts/2.2-host-system-requirements.sh 

# mount partition
bash scripts/2.7-mounting-the-new-partition.sh

# packages and patches
bash scripts/3-packages-and-patches.sh 
