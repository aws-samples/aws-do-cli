#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

if [ ! "$current_resource" == "" ]; then
	filters="--filters Name=resource-id,Values=${current_resource}"
fi

CMD="aws ec2 describe-tags $filters --output ${output_format}"

#echo "$CMD"
eval "$CMD"

