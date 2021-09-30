#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./ec2.conf

echo ""
echo "Configuring EC2 Instance Template ..."

EC2_TEMPLATE_CONFIG=./ec2-template/ec2-template-config.json
EC2_TEMPLATE=./ec2-template/launch-template-${EC2_INSTANCE_NAME}.json
EC2_TEMPLATE_TMP=./ec2-template/launch-template-${EC2_INSTANCE_NAME}.json.tmp
cp -f $EC2_TEMPLATE_CONFIG $EC2_TEMPLATE

echo ""
echo "Updating template ${EC2_TEMPLATE} based on ec2.conf ..."
sed -i.tmp "s/\"LaunchTemplateName\": \"\"/\"LaunchTemplateName\": \"$EC2_INSTANCE_NAME\"/g" $EC2_TEMPLATE
sed -i.tmp "s/\"SubnetId\": \"\"/\"SubnetId\": \"$EC2_SUBNET_ID\"/g" $EC2_TEMPLATE
sed -i.tmp "s/\"ImageId\": \"\"/\"ImageId\": \"$EC2_IMAGE_ID\"/g" $EC2_TEMPLATE
sed -i.tmp "s/\"VolumeSize\": 0/\"VolumeSize\": $EC2_VOLUME_SIZE_GB/g" $EC2_TEMPLATE

cat $EC2_TEMPLATE | jq --arg EC2_INSTANCE_TYPE "$EC2_INSTANCE_TYPE" '.LaunchTemplateData.InstanceType = $EC2_INSTANCE_TYPE' > $EC2_TEMPLATE_TMP
cp -f $EC2_TEMPLATE_TMP $EC2_TEMPLATE

cat $EC2_TEMPLATE | jq --arg EC2_INSTANCE_PROFILE_NAME "$EC2_INSTANCE_PROFILE_NAME" '.LaunchTemplateData.IamInstanceProfile.Name = $EC2_INSTANCE_PROFILE_NAME' > $EC2_TEMPLATE_TMP
cp -f $EC2_TEMPLATE_TMP $EC2_TEMPLATE

sed  -i.tmp "s/\"Key\": \"\"/\"Key\": \"Name\"/g" $EC2_TEMPLATE
sed  -i.tmp "s/\"Value\": \"\"/\"Value\": \"$EC2_INSTANCE_NAME\"/g" $EC2_TEMPLATE
sed  -i.tmp "s/\"KeyName\": \"\"/\"KeyName\": \"$EC2_KEY_NAME\"/g" $EC2_TEMPLATE
sed  -i.tmp "s/\"AssociatePublicIpAddress\": true/\"AssociatePublicIpAddress\": $EC2_ASSIGN_PUBLIC_IP/g" $EC2_TEMPLATE

cat $EC2_TEMPLATE | jq --arg EC2_SG_ID "$EC2_SG_ID" '.LaunchTemplateData.NetworkInterfaces[].Groups[0] = $EC2_SG_ID' > $EC2_TEMPLATE_TMP
cp -f $EC2_TEMPLATE_TMP $EC2_TEMPLATE

rm -f $EC2_TEMPLATE_TMP

# Display config
echo ""
echo "Generated instance template:"
echo ""
cat $EC2_TEMPLATE | jq

echo ""
echo "Please review the template above, and if needed modify it in file $EC2_TEMPLATE"
echo "Once satisfied, you can run ./ec2-template-create.sh to create the template"
echo " and ./ec2-template-launch.sh <template_id> to launch an instance from this template."
echo ""
