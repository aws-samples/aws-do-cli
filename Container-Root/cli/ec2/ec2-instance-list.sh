#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ ! "$current_vpc" == "" ]; then
	filters="--filters Name=vpc-id,Values=${current_vpc}"
fi

if [ "${response_format}" == "long" ]; then
	CMD="aws ec2 describe-instances --query \"Reservations[*].Instances[*].{InstanceId:InstanceId,Keypair:KeyName,InstanceType:InstanceType,ImageId:ImageId,PrivateIpAddress:PrivateIpAddress,AvailabilityZone:Placement.AvailabilityZone,SubnetId:SubnetId,VpcId:VpcId,Status:State.Name,PublicDnsName:PublicDnsName,Name:Tags[?Key=='Name']|[0].Value}\" $filters --output ${output_format}"

else 
	CMD="aws ec2 describe-instances --query \"Reservations[*].Instances[*].{InstanceId:InstanceId,Keypair:KeyName,InstanceType:InstanceType,PrivateIpAddress:PrivateIpAddress,SubnetId:SubnetId,Status:State.Name,Name:Tags[?Key=='Name']|[0].Value}\" $filters --output ${output_format}"

fi

#echo "$CMD"
eval "$CMD"

