#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

echo ""
echo "Listing auto scaling groups ..."
echo ""
CMD="aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].{Name: AutoScalingGroupName,LaunchTemplate: MixedInstancesPolicy.LaunchTemplate.LaunchTemplateSpecification.LaunchTemplateId, MinSize: MinSize, MaxSize: MaxSize, TargetSize: DesiredCapacity, CurrentSize: length(Instances), Subnet: VPCZoneIdentifier}' --output ${output_format}"
echo "$CMD"
eval "$CMD"
