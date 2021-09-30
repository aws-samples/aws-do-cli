#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source ./vpc.conf

# Create VPC object
echo ""
echo "Creating VPC $vpc_name ..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $vpc_cidr_block --query "Vpc.{VpcId:VpcId}" --region=$vpc_region --output text)
aws ec2 create-tags --resources $VPC_ID --tags "Key=Name,Value=$vpc_name" --region=$vpc_region
echo VPC $vpc_name created. VpcId=${VPC_ID}

# Set default VPC to new VPC object
./vpc-filter.sh ${VPC_ID}

# Create Internet Gatewoy for Public Subnets (if any)
if [[ " ${vpc_subnet_public[@]} " =~ " True " ]]; then
	echo "   Creating Internet Gateway for Public Subnets ..."
	IGW_ID=$(aws ec2 create-internet-gateway --query "InternetGateway.{InternetGatewayId:InternetGatewayId}" --region $vpc_region --output text)
	echo "   Attaching Internet Gateway $IGW_ID to VPC $VPC_ID ..."
	aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $vpc_region
	echo "   Creating Internet Gateway Route Table ..."
	IGW_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query "RouteTable.{RouteTableId:RouteTableId}" --region $vpc_region --output text)
	echo "   Creating Route to Internet Gateway ..."
	RESULT=$(aws ec2 create-route --route-table-id $IGW_RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $vpc_region)
fi

if [[ " ${vpc_subnet_public[@]} " =~ " False " ]]; then
	echo "   Getting Main Route Table ID for Private Subnets ..."
	MAIN_RT_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=association.main,Values=true --query "RouteTables[*].{RouteTableId:RouteTableId}" --region $vpc_region --output text)
fi

# Create subnets
subnet_ids=()
CREATE_NGW="True"
CREATE_NGW_ROUTE="True"
for subnet_num in ${!vpc_subnet_cidr_blocks[@]}; do
	SUBNET_NAME=${vpc_subnet_names[$subnet_num]}
	echo "   Creating subnet $SUBNET_NAME ..." 
	SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block=${vpc_subnet_cidr_blocks[$subnet_num]} --availability-zone ${vpc_subnet_azs[$subnet_num]} --query "Subnet.{SubnetId:SubnetId}" --region=$vpc_region --output text)
	RESULT=$(aws ec2 create-tags --resources $SUBNET_ID --tags "Key=Name,Value=$SUBNET_NAME" --region=$vpc_region)
	subnet_ids[$subnet_num]=$SUBNET_ID
	if [ "${vpc_subnet_public[$subnet_num]}" == "True" ]; then
		echo "      Configuring subnet $SUBNET_NAME ($SUBNET_ID) as public ..." 
		RESULT=$(aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $IGW_RT_ID --region $vpc_region)
		RESULT=$(aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch --region $vpc_region)
		# Create NAT Gateway in the first public subnet for private subnets (if any are configured and if NAT has not been created yet)
		if [ "$CREATE_NGW" == "True" ]; then
			if [[ " ${vpc_subnet_public[@]} " =~ " False " ]]; then
        			echo "      Creating NAT Gateway for Private Subnets ..."
        			EIP_ID=$(aws ec2 allocate-address --domain vpc --query "{AllocationId:AllocationId}" --region $vpc_region --output text)
        			NGW_ID=$(aws ec2 create-nat-gateway --subnet-id $SUBNET_ID --allocation-id $EIP_ID --query "NatGateway.{NatGatewayId:NatGatewayId}" --region ${vpc_region} --output text)
				STATUS="pending"
				while [ ! "$STATUS" == "available" ]; do
					echo "      Waiting for NAT GW $NGW_ID ($STATUS) to become available ..."
					sleep 10
					STATUS=$(aws ec2 describe-nat-gateways --nat-gateway-ids $NGW_ID --query "NatGateways[*].{State:State}" --region $vpc_region --output text)
				done
			fi
			CREATE_NGW="False"
		fi 

	else
		echo "      Configuring subnet $SUBNET_NAME ($SUBNET_ID) as private ..."
		if [ "$CREATE_NGW_ROUTE" == "True" ]; then
			RESULT=$(aws ec2 create-route --route-table-id $MAIN_RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $NGW_ID --region $vpc_region)
			CREATE_NGW_ROUTE="False"
		fi
	fi
done

echo ""
echo "Done creating VPC $vpc_name"
echo ""
