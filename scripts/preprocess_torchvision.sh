#!/bin/bash
set -o errexit -o pipefail

# this script is meant to be used with 'datalad run'

_SNAME=$(basename "$0")

source scripts/utils.sh echo -n

mkdir -p logs/

python3 -m pip install -r scripts/requirements_torchvision.txt

# Move data files to caltech101/ as it is where torchvision looks for caltech101 raw files
mkdir -p caltech101/
git mv 101_ObjectCategories.tar.gz caltech101/101_ObjectCategories.tar.gz
git mv Annotations.tar caltech101/101_Annotations.tar
git-annex fsck --fast caltech101/

python3 scripts/preprocess_torchvision.py \
	1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$

./scripts/stats.sh caltech101/*_ObjectCategories/*/ caltech101/Annotations/*/
# Protect metadata files not caught by stats.sh
chmod -R a-w caltech101/*_ObjectCategories/ caltech101/Annotations/

# Delete raw files
git rm -rf caltech101/101_*.tar* md5sums
