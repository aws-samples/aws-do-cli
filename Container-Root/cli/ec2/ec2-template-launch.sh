#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <template_id>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Launching instance from template $1 ..."
	# Check if template exists
	CMD="aws ec2 describe-launch-templates --launch-template-ids $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		echo ""
		CMD="aws ec2 run-instances --launch-template LaunchTemplateId=$1"
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo ""
			echo "Instance launched from template $1"
		else
			echo ""
			echo "Failed to launch instance from template $1"
		fi
	fi
	echo ""
fi

