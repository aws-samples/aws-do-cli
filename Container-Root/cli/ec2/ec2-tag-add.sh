#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ ! "$current_resource" == "" ]; then
	if [ "$2" == "" ]; then
		echo ""
		echo "Usage: $0 <key> <value>"
	else
		CMD="aws ec2 create-tags --resources ${current_resource} --tags Key=${1},Value=${2}"
		echo "$CMD"
		eval "$CMD"
	fi
	
else
	echo "Please set current_resource in ./ec2.conf or in shell environment"
fi

