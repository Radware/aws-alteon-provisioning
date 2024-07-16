# AWS Alteon Provisioning

This project provides infrastructure as code (IaC) templates to deploy an Alteon Application Delivery Controller (ADC) along with the necessary AWS infrastructure. The repository is structured to support both CloudFormation and Terraform for provisioning.

## Overview

The `aws-alteon-provisioning` repository includes the following components:

- **Alteon ADC**: A high-performance, application delivery controller.
- **Management, Data, and Server Subnets**: Separate subnets for managing the ADC, handling data traffic, and hosting servers.
- **Security Groups**: Configurations to control inbound and outbound traffic.
- **Network Interfaces**: Network setup for proper communication between the subnets and the ADC.
- **EC2 Instance**: Configured with specific user data to run necessary services or applications.

## Resources Created

- **VPC**: A virtual private cloud with a specified CIDR block.
- **Subnets**: Management, data, and server subnets.
- **Internet Gateway**: Enables internet access for the VPC.
- **Route Table**: Configured with routes to the internet gateway.
- **Security Group**: Allows traffic for specific ports and protocols.
- **Network Interfaces**: Attached to the subnets.
- **Elastic IP**: Allocated and associated with the management network interface.
- **EC2 Instance**: Configured with user data from a template file.

## Configuration

The project supports a variety of configuration options for deploying the Alteon ADC. Below are the key parameters:

- **General**: AWS region, VPC CIDR block, Subnets CIDR blocks, Availability zone, EC2 instance type, AMI ID (must exist in the availability zone), Deployment ID.
- **Admin**: Username, Password.
- **GEL**: Primary URL, Secondary URL, Enterprise ID, Throughput, Primary DNS.
- **NTP**: Primary server IP, Time zone.
- **IP**: Local IP, Remote IP.
- **VM**: Name.
- **Syslog**: 
  - Host 1: Server IP, Severity, Facility, Module, Port.
  - Host 2: Server IP, Severity, Facility, Module, Port.

## AMI IDs by Region

Below is the map of the AMIs to be used for specific AWS regions:

- **us-east-2**: ami-0649bea3443ede307
- **us-west-1**: ami-022ae17824f212e7c
- **us-west-2**: ami-093952b211f7e07f0
- **ap-south-1**: ami-06e50e5c4e11edc15
- **ap-northeast-3**: ami-05e766606d632cf34
- **ap-northeast-2**: ami-0f34b174db9614160
- **ap-southeast-1**: ami-0a3f8a7e9963052a4
- **ap-southeast-2**: ami-0e81d97a801218e3e
- **ap-northeast-1**: ami-0e318b7c616ee0de3
- **ca-central-1**: ami-0de799349d4df5292
- **eu-central-1**: ami-00a5e777afd3dff13
- **eu-west-1**: ami-07984ea0968d91298
- **eu-west-2**: ami-0997b32479b25c9c8
- **eu-west-3**: ami-03ddd706621ad6060
- **eu-north-1**: ami-00af5a9575ac0b8c6
- **sa-east-1**: ami-024ad084c285f6dac

## Directory Structure

- `cloudformation/` - Contains CloudFormation templates for provisioning the infrastructure. **(Coming soon)**
- `terraform/` - Contains Terraform configurations for provisioning the infrastructure.

## Getting Started

To get started with deploying the Alteon ADC using Terraform, refer to the detailed instructions in the Terraform README:

[Terraform README](terraform/README.md)

For CloudFormation instructions, stay tuned as we will be updating the repository with the CloudFormation README and templates soon.
