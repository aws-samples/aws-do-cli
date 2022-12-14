#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source .env

if [ -z "$1" ]; then
	if [ -z "$MODE" ]; then
		MODE=-d
	fi
else
	if [ -z "$MODE" ]; then
		MODE=-it
	fi
fi 

docker container run ${RUN_OPTS} ${CONTAINER_NAME} ${MODE} ${NETWORK} ${PORT_MAP} ${VOL_MAP} ${REGISTRY}${IMAGE}${TAG} $@

