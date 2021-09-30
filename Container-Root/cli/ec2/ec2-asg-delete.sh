#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <auto_scaling_group_name>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Deleting Auto Scaling Group $1 ..."
	# Check if auto scaling group exists
	CMD="aws ec2 describe-auto-scaling-groups --auto-scaling-group-names $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $1"
		echo ""
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Auto Scaling Group $1 deleted."
		else
			echo "Failed to delete Auto Scaling Group $1"
		fi
	fi
	echo ""
fi

