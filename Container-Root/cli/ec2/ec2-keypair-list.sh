#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

CMD="aws ec2 describe-key-pairs --query \"KeyPairs[*].{KeyPairId:KeyPairId,KeyName:KeyName,KeyType:KeyType}\" --output ${output_format}"

echo "$CMD"
eval "$CMD"
 
