#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

source .env

# Build Docker image
docker image build ${BUILD_OPTS} -t ${REGISTRY}${IMAGE}${TAG} .

