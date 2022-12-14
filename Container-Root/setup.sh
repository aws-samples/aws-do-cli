#!/bin/sh

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                #
###################################################################### 

echo ""
echo "Running setup script ..."

if [ -d /etc/apt ]; then
        [ -n "$http_proxy" ] && echo "Acquire::http::proxy \"${http_proxy}\";" > /etc/apt/apt.conf; \
        [ -n "$https_proxy" ] && echo "Acquire::https::proxy \"${https_proxy}\";" >> /etc/apt/apt.conf; \
        [ -f /etc/apt/apt.conf ] && cat /etc/apt/apt.conf
fi

# Install basic tools
echo "Installing basic tools ..."
apt-get update
apt-get install -y vim htop software-properties-common groff jq

# Customize bash
echo "Customizing bash ..."
echo "alias ll='ls -alh --color=auto'" >> /root/.bashrc

# Install aws cli
echo "Installing aws cli v2 ..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -f awscliv2.zip
rm -rf aws
aws --version
# Set aws2 as the launcher for the v2 version of the aws cli
ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws2

# Install aws-shell
echo "Installing aws-shell ..."
pip install aws-shell
aws --version

# Install session-manager-plugin
echo "Installing session manager plugin ..."
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
rm -f ./session-manager-plugin.deb

# Install Debian license manager
cd /opt
wget https://github.com/daald/dpkg-licenses/archive/master.zip -O master.zip; unzip master.zip; rm master.zip

echo "Done."

