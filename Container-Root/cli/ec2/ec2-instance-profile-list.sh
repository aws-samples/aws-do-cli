#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ "${response_format}" == "long" -o "$1" == "long" ]; then
	CMD="aws iam list-instance-profiles --query \"InstanceProfiles[*].{InstanceProfileId:InstanceProfileId,InstanceProfileName:InstanceProfileName,Arn:Arn,Role0:Roles[0].RoleName,Role1:Roles[1].RoleName}\" --output ${output_format}"
else
	CMD="aws iam list-instance-profiles --query \"InstanceProfiles[*].{InstanceProfileId:InstanceProfileId,InstanceProfileName:InstanceProfileName,Role0:Roles[0].RoleName,Role1:Roles[1].RoleName}\" --output ${output_format}"

fi

echo "$CMD"
eval "$CMD"

