#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

CMD="aws ec2 describe-instance-types --query \"InstanceTypes[*].{InstanceType:InstanceType,vCPUs:VCpuInfo.DefaultVCpus,MemoryMiB:MemoryInfo.SizeInMiB,StorageGB:InstanceStorageInfo.TotalSizeInGB,NetworkPerformance:NetworkInfo.NetworkPerformance,MaxNICs:NetworkInfo.MaximumNetworkInterfaces,GPUs:GpuInfo.Gpus[0].Count,IPUs:InferenceAcceleratorInfo.Accelerators[0].Count,EFA:NetworkInfo.EfaInfo.MaximumEfaInterfaces}\" $filters --output ${output_format}"

echo "$CMD"
eval "$CMD"

