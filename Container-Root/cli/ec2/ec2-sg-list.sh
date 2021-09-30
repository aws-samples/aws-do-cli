#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ ! "$current_vpc" == "" ]; then
	filters="--filters Name=vpc-id,Values=${current_vpc}"
fi

if [ "${response_format}" == "long" -o "$1" == "long" ]; then
	CMD="aws ec2 describe-security-groups --query \"SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName,Description:Description,VpcId:VpcId}\" $filters --output ${output_format}"
else
	CMD="aws ec2 describe-security-groups --query \"SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName,VpcId:VpcId}\" $filters --output ${output_format}"
fi

echo "$CMD"
eval "$CMD"

