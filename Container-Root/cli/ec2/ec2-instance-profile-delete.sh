#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

CMD="aws iam delete-instance-profile --instance-profile-name $1"

echo "$CMD"
eval "$CMD"

