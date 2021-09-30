#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

filters="--filters Name=root-device-type,Values=ebs"
if [ "${response_format}" == "short" ]; then
	CMD="aws ec2 describe-images --owners self amazon --query \"Images[*].{ImageId:ImageId,ImageName:Name,Platform:PlatformDetails,Owner:ImageOwnerAlias}\" $filters --output ${output_format}"

else
	CMD="aws ec2 describe-images --owners self amazon --query \"Images[*].{ImageId:ImageId,ImageName:Name,Description:Description,Platform:PlatformDetails,Owner:ImageOwnerAlias}\" $filters --output ${output_format}"

fi

echo "$CMD"
eval "$CMD"

