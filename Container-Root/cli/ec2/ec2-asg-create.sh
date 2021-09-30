#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <auto_scaling_group_name> <template_id> <min_size> <max_size> <desired_size>"
	echo ""
}

if [ "$5" == "" ]; then
	usage
else
	echo ""
	echo "Creating Auto Scaling Group $1 from Launch Template $2 ..."
	# Check if launch template exists
	CMD="aws ec2 describe-launch-templates --launch-template-ids $2 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws autoscaling create-auto-scaling-group --auto-scaling-group-name $1 --launch-template LaunchTemplateId=$2 --min-size $3 --max-size $4 --desired-capacity $5"
		echo ""
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Auto Scaling Group $1 created."
		else
			echo "Failed to create Auto Scaling Group $1"
		fi
	fi
	echo ""
fi

