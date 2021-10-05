#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage() {
	echo ""
	echo "Usage: $0 <instance_id>"
	echo
}

if [ "$1" == "" ]; then
	usage
else
	CMD="aws ec2 describe-instances --instance-id $1"
	echo "$CMD"
	eval "$CMD"
fi
