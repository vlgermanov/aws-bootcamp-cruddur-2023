#!/usr/bin/env bash

# AMIs (eu-central-1)
# Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type - ami-0c0d3776ef525d5dd (64-bit (x86)) / ami-0df024c06dbca46b7 (64-bit (Arm))
# Amazon Linux 2 AMI (HVM) - Kernel 4.14, SSD Volume Type - ami-01aa7cea8549a00f9 (64-bit (x86)) / ami-0f5461dfb7c55e7b5 (64-bit (Arm))
# Ubuntu Server 22.04 LTS (HVM), SSD Volume Type - ami-0d1ddd83282187d18 (64-bit (x86)) / ami-005c370b8f5d3a5f5 (64-bit (Arm))
# Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0e067cc8a2b58de59 (64-bit (x86)) / ami-076dd059a0851b3a8 (64-bit (Arm))
# Debian 11 (HVM), SSD Volume Type - ami-08f13e5792295e1b2 (64-bit (x86)) / ami-0216ffa50f321442e (64-bit (Arm))

AMI_ID=ami-0d1ddd83282187d18
INSTANCE_TYPE=t2.micro

SECURITY_GROUP=$(aws ec2 create-security-group \
    --group-name "aws-bootcamp-cruddur-sg" \
    --description "AWS Bootcamp 2023 CRUDDUR SG" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=course_name,Value=aws-bootcamp-2023}]' \
    --query 'GroupId' \
    --output text) && \
echo "Security group created with id $SECURITY_GROUP"

aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP" \
    --tag-specifications 'ResourceType=security-group-rule,Tags=[{Key=course_name,Value=aws-bootcamp-2023}]' \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP" \
    --tag-specifications 'ResourceType=security-group-rule,Tags=[{Key=course_name,Value=aws-bootcamp-2023}]' \
    --protocol tcp \
    --port 4567 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP" \
    --tag-specifications 'ResourceType=security-group-rule,Tags=[{Key=course_name,Value=aws-bootcamp-2023}]' \
    --protocol tcp \
    --port 3000 \
    --cidr 0.0.0.0/0

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name aws-bootcamp-2023-key-pair \
    --security-group-ids "$SECURITY_GROUP" \
    --associate-public-ip-address \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":10,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --user-data file://user-data.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=course_name,Value=aws-bootcamp-2023}]' \
    --query 'Instances[0].InstanceId' \
    --output text) && \
echo "Instance launched with id $INSTANCE_ID"

INSTANCE_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" --output text) && \
    echo "EC2 instance IP: $INSTANCE_IP"

INSTANCE_DNS_NAME=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicDnsName" --output text) && \
    echo "EC2 instance DNS NAME: $INSTANCE_DNS_NAME"
