#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

echo ""
echo "Listing launch templates ..."
echo ""
CMD="aws ec2 describe-launch-templates --query 'LaunchTemplates[*].{LaunchTemplateId:LaunchTemplateId,LaunchTemplateName:LaunchTemplateName,DefaultVersion:DefaultVersionNumber}' --output ${output_format}"
echo "$CMD"
eval "$CMD"

