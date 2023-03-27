#!/bin/bash

# install httpd
sudo su
yum update -y
yum install -y httpd.x86_64
yum install -y jq
systemctl start httpd.service
systemctl enable httpd.service

# export the aws credentials as env var
echo "export AWS_ACCESS_KEY_ID=${aws_access_key}" >> /home/ec2-user/.bashrc
echo "export AWS_SECRET_ACCESS_KEY=${aws_secret_key}" >> /home/ec2-user/.bashrc
source /home/ec2-user/.bashrc

# use aws cli to fetch html file from s3
aws s3 cp s3://belong-coding-challenge/belong-test.html /var/www/html

# copy it as index.html
cp /var/www/html/belong-test.html /var/www/html/index.html
