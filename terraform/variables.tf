variable "region" {
  description = "AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets, should be /24"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "availability_zone" {
  description = "availability zone for the subnets"
  default     = "a"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "c4.large"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-09fd2b8b128dc0f2d"
}

variable "deployment_id" {
  description = "Unique identifier for each deployment"
  type        = string
  default     = "default"
}

variable "admin_password" {
  description = "Admin password"
  default     = "admin123"
}

variable "admin_user" {
  description = "Admin username"
  default="admin"
}

variable "gel_url_primary" {
  description = "GEL primary URL"
  default     = "http://primary.gel.example.com"
}

variable "gel_url_secondary" {
  description = "GEL secondary URL"
  default     = "http://secondary.gel.example.com"
}

variable "gel_ent_id" {
  description = "GEL enterprise ID"
  default     = "12345"
}

variable "gel_throughput_mb" {
  description = "GEL throughput in MB"
  default     = "100"
}

variable "gel_dns_pri" {
  description = "GEL primary DNS"
  default     = "8.8.8.8"
}

variable "ntp_primary_server" {
  description = "NTP primary server IP Address only"
  default     = "132.163.97.8"
}

variable "ntp_tzone" {
  description = "NTP time zone"
  default     = "UTC"
}

variable "cc_local_ip" {
  description = "Local IP address"
  default     = "10.0.1.2"
}

variable "cc_remote_ip" {
  description = "Remote IP address"
  default     = "0.0.0.0"
}

variable "vm_name" {
  description = "VM name"
  default     = "default-vm"
}

variable "hst1_ip" {
  description = "Syslog Server IP for syslog host 1"
  default     = "1.2.3.4"
}

variable "hst1_severity" {
  description = "Severity[0-7] for syslog host 1"
  default     = "7"
}

variable "hst1_facility" {
  description = "facility[0-7] for syslog host 1"
  default     = "0"
}

variable "hst1_module" {
  description = "Module for syslog host 1"
  default     = "all"
}

variable "hst1_port" {
  description = "Port for syslog host 1"
  default     = "514"
}

variable "hst2_ip" {
  description = "Syslog Server IP for syslog host 2"
  default     = "0.0.0.0"
}

variable "hst2_severity" {
  description = "Severity for syslog host 2"
  default     = "7"
}

variable "hst2_facility" {
  description = "Facility for syslog host 2"
  default     = "0"
}

variable "hst2_module" {
  description = "Module for syslog host 2"
  default     = "all"
}

variable "hst2_port" {
  description = "Port for syslog host 2"
  default     = "514"
}


// helpers

variable "operation" {
  description = "Operation type: create or destroy"
  type        = string
  default     = "create"
}

variable "gel_enabled" {
  description = "Enable or disable GEL"
  type        = bool
  default     = false
}