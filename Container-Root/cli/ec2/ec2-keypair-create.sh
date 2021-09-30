#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

function usage(){
	echo ""
	echo "Usage: $0 <key_name>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Creating keypair $1 ..."
	CMD="aws ec2 create-key-pair --key-name $1 --query 'KeyMaterial' --output text > $1.pem"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		echo ""
		cat $1.pem
		echo ""
		echo "Key file saved in: $(pwd)/$1.pem"
		echo ""
	fi
fi

