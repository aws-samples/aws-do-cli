# AWS Command Line Interface (CLI) container implemented as a Do framework project (aws-do-cli)
This project follows the principles of the Do framework to build and run a container for the [AWS CLI](https://aws.amazon.com/cli/). This container can be used for generic AWS CLI commands including management of your AWS VPCs and other infrastructure in the Amazon cloud.

## Why use this project
If you would prefer to run the AWS CLI in a container rather than installing it on your current machine, then this project is one of the available options.

## How to use this project
To use this project, build and run the aws-do-cli container, then open a shell into the container and use aws commands or start aws-shell as shown in the screencast below.

<div align="center">
<img src="./aws-do-cli-screencast.gif" width="90%"/>
</br>

Fig. 1 - aws-do-cli screencast
</div>

### Configure
All configuration items in this project are centralized in the [`.env`](.env) file. Use a regular text editor (e.g. vi or nano) to edit it. When settings in this file are edited they take effect with the execution of the next management script. If a container is already running, configuration changes will take effect inside the container when it is restarted.

By default, the project is configured to mount the local `~/.aws` directory inside the container so any AWS CLI settings that you have configured locally will be available in the container shell as well. If you have not configured your AWS credentials locally yet, you can execute `aws configure` inside the continer and complete the configuration wizard. You only need to do this once, as your credentials will be persisted in your home folder outside of the container.

### Build
In order to build this project, you will only need to have [Docker](https://docs.docker.com/get-docker/) installed.
Execute [`./build.sh`](./build.sh) to build the Docker container locally or configure your registry in the [`.env`](.env) file and execute [`./pull.sh`](./pull.sh) to pull an existing aws-do-cli image. Note: this container uses the public [python:3.9](https://hub.docker.com/layers/python/library/python/3.9/images/sha256-acf2d18cc2400dd0a0ca1a62e66ab9a64f4c8faf57a2593c96485962ade4e926?context=explore) image as base. It is intended to run locally, and should be hardened, including changing the base image if needed, before using it in production.

### Run
Starting the aws-do-cli container is done by executing the [`./run.sh`](./run.sh) script. The container needs to be started before a shell can be open into it.

### Exec
To open a shell into a running aws-do-cli container, run the [`./exec.sh`](./exec.sh) script. A container must already be running. You can find out if there is a running container by executing [`./status.sh`](./status.sh).

Once a shell into the container is opened, you can either execute `aws` commands, or enter the aws shell by executing `aws-shell`. The advantage of using aws-shell is that it provides interactive type-ahead functionality and contextual documentation. Commands in the bash shell and aws-shell would be identical except within the aws-shell the command should omit `aws` from the beginning of the line. Both AWS v1 and v2 are installed in the container. The default CLI version is set to v1 to match the version used by aws-shell. If you would like to invoke AWS CLI v2, just use `aws2` instead of `aws` in your commands. 

Some sample commands include:
```
aws s3 ls
aws ec2 describe-instance-types
aws ec2 describe-vpcs
```

To exit from `aws-shell` press `F10` or `Fn + F10`. To exit from the container shell, just execute `exit`. 

### Stop
To stop the aws-do-cli container execute [`./stop.sh`](./stop.sh).

## Mange VPCs
The [`/cli/vpc`](Container-Root/cli/vpc) folder inside the container has scripts which use the aws cli to enable you to manage your VPCs and subnets. To use the VPC scripts inside the container set the current directory as shown below.
```
cd /cli/vpc
```

### List VPCs
To show the current VPCs in your account, execute [`./vpc-list.sh`](Container-Root/cli/vpc/vpc-list.sh).

### Set current VPC
To display subnet information a current VPC must be set. To set the current VPC, execute [`./vpc-filter.sh <vpc-id>`](Container-Root/cli/vpc/vpc-filter.sh).

### List VPC subnets
After setting the current VPC, execute [`./vpc-list-subnets.sh`](Container-Root/cli/vpc/vpc-list-subnets.sh).

### Create a new VPC
To create a new VPC, first execute [`./vpc-configure.sh`](Container-Root/cli/vpc/vpc-configure.sh) and set the desired VPC name, CIDR and Subnets. Then execute [`./vpc-create.sh`](Container-Root/cli/vpc/vpc-create.sh).

### Delete an existing VPC
To delete an existing VPC, first execute [`./vpc-configure.sh`](Container-Root/cli/vpc/vpc-configure.sh) and set the VPC name to the one you'd like to delete. Then execute [`./vpc-delete.sh`](Container-Root/cli/vpc/vpc-delete.sh).

## Manage EC2 Instances
The [`/cli/ec2`](Container-Root/cli/ec2/) folder inside the container has scripts which use the aws cli to enable you to manage your EC2 instances and some related resources. To use the EC2 scripts inside the container set the current directory as shown below.
```
cd /cli/ec2
```

### Configure EC2 Instance
Executing script [`./ec2-config.sh`](Container-Root/cli/ec2/ec2-config.sh) or directly editing the [`./ec2.conf`](Container-Root/cli/ec2/ec2.conf) file lets you specify the minimal set of properties needed for creation of your EC2 instance. 
```bash
# EC2 Instance Configuration
EC2_SUBNET_ID=
EC2_IMAGE_ID=
EC2_VOLUME_SIZE_GB=
EC2_INSTANCE_TYPE=
EC2_INSTANCE_PROFILE_NAME=
EC2_INSTANCE_NAME=
EC2_KEY_NAME=
EC2_ASSIGN_PUBLIC_IP=false
EC2_SG_ID=
```
Each of these properties is required and the folder contains scripts that help determine the values that should be configured for them.

#### EC2_SUBNET_ID
A subnet should already exist. You can view a list of all available subnets in your VPCs by executing the [`./ec2-subnet-list.sh`](Container-Root/cli/ec2/ec2-subnet-list.sh) script. If a subnet does not already exist, please refer to the [Manage VPCs](#manage-vpcs) section of this document.

#### EC2_IMAGE_ID
An [Amazon Machine Image (AMI)](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Images:sort=desc:creationDate) ID needs to be specified, in order to create an EC2 instance. You can obtain a list of available AMI IDs by executing the [`./ec2-image-list.sh`](Container-Root/cli/ec2/ec2-image-list.sh) script.

#### EC2_VOLUME_SIZE_GB
Specify the size in GB of the [EBS volume](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Volumes:sort=desc:createTime) to be attached to the EC2 instance. Please note that dependent on the AMI ID you selected, there would be a minimum volume size. When launching the instance, a validation error will occur if the volume size you specified is insufficient for the selected AMI ID.

#### EC2_INSTANCE_TYPE
This setting specifies the machine configuration of your instance. You may refer to the [AWS documentation](https://aws.amazon.com/ec2/instance-types/) regarding currently available instance types. Or you may run script [`./ec2-instance-type-list.sh`](Container-Root/cli/ec2/ec2-instance-type-list.sh) to display a list of available instance types in the region currently configured for your AWS cli.

#### EC2_INSTANCE_PROFILE_NAME
This setting specifies the IAM instance profile for your EC2 instance. You may execute script [`./ec2-instance-profile-list.sh`](Container-Root/cli/ec2/ec2-instance-profile-list.sh) to display a list of existing instance profiles. Alternatively you may view or create instance profiles using [Identity and Access Management (IAM) role management UI](https://console.aws.amazon.com/iamv2/home?#/roles) in the AWS Console.

#### EC2_INSTANCE_NAME
The name that you would like to label your instance with. The value provided for this parameter is used to create a "Name" tag for the instance. To view a current list of EC2 instances, use the [`./ec2-instance-list.sh`](Container-Root/cli/ec2/ec2-instance-list.sh) script.

#### EC2_KEY_NAME
In order to enable SSH access to the EC2 instance, an SSH key is needed. Use [`./ec2-keypair-list.sh`](Container-Root/cli/ec2/ec2-keypair-list.sh) to show the list of existing SSH keys. You need to be in posession of the private key file of an SSH key in order to use it for logging in to an SSH instance. Running script [`./ec2-keypair-create.sh`](Container-Root/cli/ec2/ec2-keypair-create.sh) creates an SSH keypair and provides you with the private key. It is a good practice to delete SSH keys that are no longer in use. To delete a specific SSH key if needed, use the [`./ec2-keypair-delete.sh`](Container-Root/cli/ec2/ec2-keypair-delete.sh) script.

#### EC2_ASSIGN_PUBLIC_IP
The value of this parameter can be `false` or `true`. If the EC2 instance is being created in a private subnet, then the value must be `false`. If the EC2 instances is being created in a public subnet, then you may specify `true` or `false`. A public IP address will be assigned to the instance only if it is created in a public subnet and the value of EC2_ASSIGN_PUBLIC_IP is `true`.

#### EC2_SG_ID
A security group ID to be associated with the instance must be provided. To display a list of existing security groups, use the [`./ec2-sg-list.sh`](Container-Root/cli/ec2/ec2-sg-list.sh) script. To create a new security group if needed, execute script [`./ec2-sg-create.sh`](Container-Root/cli/ec2/ec2-sg-create.sh). This script creates a security group and adds a rule allowing SSH access from your current IP address. If you wish to configure different rules, you may modify the security group using the AWS console after it is created by the script. To delete a security group if needed, you may run [`./ec2-sg-delete.sh`](Container-Root/cli/ec2/ec2-sg-delete.sh). 

### Launch EC2 Instance
An EC2 instance can be launched either from the configured EC2 Instance Settings or through a launch template as described further below. Launching an instance from the configured settings is preferred when the minimal settings are sufficient for your needs and the instance does not need to be customized further. To launch the instance in this case, just execute [`./ec2-instance-launch.sh`](Container-Root/cli/ec2/ec2-instance-launch.sh).

### Use EC2 Launch Templates
When it is necessary to customize an instance beyond the minimal settings provided in [`./ec2.conf`](Container-Root/cli/ec2/ec2.conf), and if it is preferred to save instance configurations so more instances of the same kind can be launched, it is recommended to create a launch template and then use this template to launch the instance. 

#### Create Launch Template 
To create a launch template, do the following:
1. Configure [`./ec2.conf`](Container-Root/cli/ec2/ec2.conf) as describe above.
2. Run script [`./ec2-template-config.sh`](Container-Root/cli/ec2/ec2-template-config.sh). This uses 
file [`./ec2-template/ec2-template-config.json`](Container-Root/cli/ec2/ec2-template/ec2-template-config.json) and the settings from [`./ec2.conf`](Container-Root/cli/ec2/ec2.conf) to create a template configuration and save it in `./ec2-template/launch-template-<EC2_INSTANCE_NAME>.json`.
3. Review and customize the launch template configuration as needed.
4. Execute script [`./ec2-template-create.sh`](Container-Root/cli/ec2/ec2-templae-create) to create the launch template. 

#### List Launch Templates
To show a list of existing launch templates just execute [`./ec2-template-list.sh`](Container-Root/cli/ec2/ec2-template-list.sh)

#### Delete Launch Template
To delete an existing launch template, use script [`./ec2-template-delete.sh`](Container-Root/cli/ec2/ec2-template-delete.sh) and specify the template id as argument.

### Launch EC2 Instance from a Launch Template
To launch an instance from an existing launch template, execute [`./ec2-template-launch.sh`](Container-Root/cli/ec2/ec2-template-launch.sh) and specify the template id as argument.

### List EC2 Instances
To show a list of existing EC2 instances, execute [`./ec2-instance-list.sh`](Container-Root/cli/ec2/ec2-instance-list.sh)

### Stop EC2 Instances
Execute script [`./ec2-instance-stop.sh`](Container-Root/cli/ec2/ec2-instance-stop.sh) and specify the instance id as argument to stop a running instance.

### Start EC2 Instances
Execute script [`./ec2-instance-start.sh`](Container-Root/cli/ec2/ec2-instance-start.sh) and specify the instance id as argument to start a stopped instance.

### Terminate EC2 Instances
Execute script [`./ec2-instance-terminate.sh`](Container-Root/cli/ec2/ec2-instance-terminate.sh) and specify the instance id as argument to terminate an instance.

## Conclusion
The aws-do-cli project enables running AWS CLI, AWS CLI v2, and aws-shell in a container. In addition it provides helper scripts for management of VPCs and EC2 instances. This project could facilitate your use of the AWS CLI without requiring installation of tools other than Docker on your machine.

## Security
See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License
This library is licensed under the Apache 2.0 License. See the [LICENSE.txt](LICENSE.txt) file.

## References
* [Do framework / depend-on-docker project](https://github.com/iankoulski/depend-on-docker)
* [Docker](https://www.docker.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [AWS Shell](https://github.com/awslabs/aws-shell)
* [AWS VPC](https://aws.amazon.com/vpc/)
* [AWS EC2](https://aws.amazon.com/ec2/)
