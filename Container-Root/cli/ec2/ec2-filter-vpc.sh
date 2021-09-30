#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ec2.conf

sed -i.bak "s/^[#]*\s*current_vpc=.*/current_vpc=$1/" ec2.conf
