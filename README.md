# AWS Alteon Provisioning

This project provides infrastructure as code (IaC) templates to deploy an Alteon Application Delivery Controller (ADC) along with the necessary AWS infrastructure. The repository is structured to support both CloudFormation and Terraform for provisioning.

## Overview

The `aws-alteon-provisioning` repository includes the following components:

- **Alteon ADC**: A high-performance, application delivery controller.
- **Management, Data, and Server Subnets**: Separate subnets for managing the ADC, handling data traffic, and hosting servers.
- **Security Groups**: Configurations to control inbound and outbound traffic.
- **Network Interfaces**: Network setup for proper communication between the subnets and the ADC.
- **EC2 Instance**: Configured with specific user data to run necessary services or applications.

## Configuration

The project supports a variety of configuration options for deploying the Alteon ADC. Below are the key parameters:

- **General**: AWS region, VPC CIDR block, Subnets CIDR blocks, Availability zone, EC2 instance type, AMI ID, Deployment ID.
- **Admin**: Username, Password.
- **GEL**: Primary URL, Secondary URL, Enterprise ID, Throughput, Primary DNS.
- **NTP**: Primary server IP, Time zone.
- **IP**: Local IP, Remote IP.
- **VM**: Name.
- **Syslog**: 
  - Host 1: Server IP, Severity, Facility, Module, Port.
  - Host 2: Server IP, Severity, Facility, Module, Port.

## Directory Structure

- `cloudformation/` - Contains CloudFormation templates for provisioning the infrastructure. **(Coming soon)**
- `terraform/` - Contains Terraform configurations for provisioning the infrastructure.

## Getting Started

To get started with deploying the Alteon ADC using Terraform, refer to the detailed instructions in the Terraform README:

[Terraform README](terraform/README.md)

For CloudFormation instructions, stay tuned as we will be updating the repository with the CloudFormation README and templates soon.