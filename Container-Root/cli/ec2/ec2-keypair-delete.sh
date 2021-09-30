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
	echo "Deleting keypair $1 ..."
	# Check if keypair exists
	CMD="aws ec2 describe-key-pairs --key-name $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws ec2 delete-key-pair --key-name $1"
		eval "$CMD"
		echo ""
		if [ "$?" == "0" ]; then
			echo "Key pair $1 deleted."
		else
			echo "Failed to delete key pair $1"
		fi
	fi
	echo ""
fi

