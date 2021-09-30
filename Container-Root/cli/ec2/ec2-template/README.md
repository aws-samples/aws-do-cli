# EC2 Template
Generated EC2 Launch Templates get stored in this folder.
These files are created from ec2-template-config.json as source by script ./ec2-template-config.sh. They are named as launch-template-<$EC2_INSTANCE_NAME>.json. The ./ec2-template-create.sh script uses these files to create launch templates. The files can be customized manually before the ./ec2-template-create.sh script is executed. Upon successful creation, a templateID is returned and can be seen when script ./ec2-template-list.sh is executed. The ./ec2-template-launch.sh then can be used to launch EC2 instances by passing the templateId as argument.

