#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <auto_scaling_group_name> <min_size> <max_size> <desired_size>"
	echo ""
}

if [ "$4" == "" ]; then
	usage
else
	echo ""
	echo "Updating Auto Scaling Group $1 ..."
	# Check if auto scaling group exists
	CMD="aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws autoscaling update-auto-scaling-group --auto-scaling-group-name $1  --min-size $2 --max-size $3 --desired-capacity $4"
		echo ""
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Auto Scaling Group $1 updated."
		else
			echo "Failed to update Auto Scaling Group $1"
		fi
	fi
	echo ""
fi

