#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ ! "$current_vpc" == "" ]; then
	filters="--filters Name=vpc-id,Values=${current_vpc}"
fi

CMD="aws ec2 describe-subnets ${filters} --query \"Subnets[*].{Name:Tags[?Key=='Name']|[0].Value,CidrBlock:CidrBlock,AvailabilityZone:AvailabilityZone,IPs:AvailableIpAddressCount,Public:MapPublicIpOnLaunch,SubnetId:SubnetId,VpcId:VpcId}\" --output ${output_format}"

#echo "$CMD"
eval "$CMD"
