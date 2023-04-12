#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <instnce_id>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Extracting launch template from instance $1 ..."
	# Check if instance exists
	CMD="aws ec2 get-launch-template-data --instance-ids $1"
	echo "$CMD"
	echo ""
	eval "$CMD"
	echo ""
fi

