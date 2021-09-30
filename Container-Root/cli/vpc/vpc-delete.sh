#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./vpc.conf

if [ "$1" == "" ]; then
	echo ""
	echo "Please specify VPC ID as agument."
	echo ""
	echo "Usage: $0 <vpc_id>"
	echo ""
else
	VPC_ID=$1

	# Delete NAT Gateway
	NGW_IDS=$(aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=$VPC_ID --query "NatGateways[*].{NatGatewayId:NatGatewayId}" --output text)
	for NGW_ID in $NGW_IDS; do
		STATUS=$(aws ec2 describe-nat-gateways --nat-gateway-ids $NGW_ID --query "NatGateways[*].{State:State}" --region $vpc_region --output text)
		if [ ! "$STATUS" == "deleted" ]; then
			echo "   Deleting NAT Gateway $NGW_ID ..."
			RESULT=$(aws ec2 delete-nat-gateway --nat-gateway-id $NGW_ID)
			while [ ! "$STATUS" == "deleted" ]; do
				sleep 10
				STATUS=$(aws ec2 describe-nat-gateways --nat-gateway-ids $NGW_ID --query "NatGateways[*].{State:State}" --region $vpc_region --output text)
				echo "      Waiting for NAT Gateway ($STATUS) to be deleted ..."
			done
		fi
	done

	# Delete unassigned Elastic IPs
	EIPS=$(aws ec2 describe-addresses --query "Addresses[?AssociationId==null].{AllocationId:AllocationId}" --output text)
	for EIP in $EIPS; do
		echo "   Releasing Elastic IP $EIP ..."
		RESULT=$(aws ec2 release-address --allocation-id $EIP)
 	done		


	# Delete subnets
	SUBNET_IDS=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID --query "Subnets[*].{SubnetId:SubnetId}" --output text)
	for SUBNET_ID in $SUBNET_IDS; do
		echo "   Deleting Subnet $SUBNET_ID ..."
		RESULT=$(aws ec2 delete-subnet --subnet-id $SUBNET_ID)
	done

	# Delete attached internet gateway
	IGW_IDS=$(aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=$VPC_ID --query "InternetGateways[*].{InternetGatewayId:InternetGatewayId}" --output text)
	for IGW_ID in $IGW_IDS; do
		echo "   Deleting Internet Gateway $IGW_ID ..."
		RESULT=$(aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID)
		RESULT=$(aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID)
	done

	# Delete attached non-main route tables
	RT_IDS=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID --query "RouteTables[*].{RouteTableId:RouteTableId}" --output text)
	MAIN_RT_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=association.main,Values=true --query "RouteTables[*].{RouteTableId:RouteTableId}" --output text)
	for RT_ID in $RT_IDS; do
		if [ ! "$RT_ID" == "$MAIN_RT_ID" ]; then
			echo "   Deleting Route Table $RT_ID ..."
			RESULT=$(aws ec2 delete-route-table --route-table-id $RT_ID)
		fi
	done

	# Delete VPC
	echo ""
	echo "Deleting VPC $VPC_ID ..."
	aws ec2 delete-vpc --vpc-id $VPC_ID
	if [ "$?" == "0" ]; then
		echo "... VPC $VPC_ID Deleted Successfully"
	else
		echo "... VPC $VPC_ID could not be deleted"
	fi
	echo ""
fi
