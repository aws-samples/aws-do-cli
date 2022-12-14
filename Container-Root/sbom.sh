#!/bin/sh

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

# Software bill of material generation script
echo ""
echo "Generating SBOM.txt"

wget https://github.com/daald/dpkg-licenses/archive/master.zip -O master.zip; unzip master.zip; rm master.zip
cd ./dpkg-licenses-master
./dpkg-licenses > SBOM.txt
cp -f ./SBOM.txt /wd/SBOM.txt

echo ""
echo "Done"

