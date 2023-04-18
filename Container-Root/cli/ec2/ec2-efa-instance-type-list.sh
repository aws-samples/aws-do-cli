#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

export filters="--filters Name=network-info.efa-supported,Values=true"

CMD="aws ec2 describe-instance-types --query \"InstanceTypes[*].{InstanceType:InstanceType,vCPUs:VCpuInfo.DefaultVCpus,MemoryMiB:MemoryInfo.SizeInMiB,StorageGB:InstanceStorageInfo.TotalSizeInGB,NetworkPerformance:NetworkInfo.NetworkPerformance,MaxNICs:NetworkInfo.MaximumNetworkInterfaces,GPUs:GpuInfo.Gpus[0].Count,IPUs:InferenceAcceleratorInfo.Accelerators[0].Count,EFA:NetworkInfo.EfaInfo.MaximumEfaInterfaces}\" $filters --output text | sort -k 4"

# Short format
#aws ec2 describe-instance-types  --filters Name=network-info.efa-supported,Values=true  --query "InstanceTypes[*].[InstanceType]"  --output text | sort

echo "$CMD"
echo "EFA     GPUs    IPUs    InstanceType    MaxNICs MemMiB  NetworkBW       DiskGB  vCPUs "
echo "======================================================================================"
eval "$CMD"

