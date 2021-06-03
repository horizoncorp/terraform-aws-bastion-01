#!/bin/bash
#set -x
exec &> >(tee -a "/var/log/first-boot.log")
amazon-linux-extras install epel
yum update -y
yum install ansible -y