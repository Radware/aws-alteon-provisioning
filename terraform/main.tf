provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_vpc" "adc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ADCVPC-${var.deployment_id}"
  }
}

# Management subnet
resource "aws_subnet" "adc_mgmt_net" {
  vpc_id            = aws_vpc.adc_vpc.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = "${var.region}${var.availability_zone}"

  tags = {
    Name = "ADCMGMTNet-${var.deployment_id}"
  }
}

# Data subnet
resource "aws_subnet" "adc_data_net" {
  vpc_id            = aws_vpc.adc_vpc.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = "${var.region}${var.availability_zone}"

  tags = {
    Name = "ADCDataNet-${var.deployment_id}"
  }
}

# Servers subnet
resource "aws_subnet" "adc_servers_net" {
  vpc_id            = aws_vpc.adc_vpc.id
  cidr_block        = var.subnet_cidrs[2]
  availability_zone = "${var.region}${var.availability_zone}"

  tags = {
    Name = "ADCServersNet-${var.deployment_id}"
  }
}

resource "aws_internet_gateway" "adc_igw" {
  vpc_id = aws_vpc.adc_vpc.id

  tags = {
    Name = "ADCIGW-${var.deployment_id}"
  }
}

resource "aws_route_table" "adc_public_route_table" {
  vpc_id = aws_vpc.adc_vpc.id

  tags = {
    Name = "ADCPublicRouteTable-${var.deployment_id}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.adc_igw.id
  }
}

resource "aws_route_table_association" "adc_mgmt" {
  subnet_id      = aws_subnet.adc_mgmt_net.id
  route_table_id = aws_route_table.adc_public_route_table.id
}

resource "aws_route_table_association" "adc_data" {
  subnet_id      = aws_subnet.adc_data_net.id
  route_table_id = aws_route_table.adc_public_route_table.id
}

/*
resource "aws_security_group" "adc_alteon_sg" {
  name        = "AlteonSG-${var.deployment_id}"
  description = "Security Group for Alteon VA"
  vpc_id      = aws_vpc.adc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3121
    to_port     = 3121
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/

# Management security group
resource "aws_security_group" "adc_mgmt_sg" {
  name        = "AlteonMgmtSG-${var.deployment_id}"
  description = "Management Security Group for Alteon VA"
  vpc_id      = aws_vpc.adc_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.mgmt_cidr_blocks
  }

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = var.mgmt_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.mgmt_cidr_blocks
  }

  tags = {
    Name = "AlteonMgmtSG-${var.deployment_id}"
  }
}

# Data security group
resource "aws_security_group" "adc_data_sg" {
  name        = "AlteonDataSG-${var.deployment_id}"
  description = "Data Security Group for Alteon VA"
  vpc_id      = aws_vpc.adc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = var.data_cidr_blocks
  }

  ingress {
    from_port   = 3121
    to_port     = 3121
    protocol    = "tcp"
    cidr_blocks = var.data_cidr_blocks
  }

  tags = {
    Name = "AlteonDataSG-${var.deployment_id}"
  }
}

resource "aws_network_interface" "adc_mgmt_eni" {
  subnet_id       = aws_subnet.adc_mgmt_net.id
  security_groups = [aws_security_group.adc_mgmt_sg.id]

  tags = {
    Name = "ADCMgmtENI-${var.deployment_id}"
  }
}

resource "aws_network_interface" "adc_data_eni" {
  subnet_id       = aws_subnet.adc_data_net.id
  security_groups = [aws_security_group.adc_data_sg.id]

  tags = {
    Name = "ADCDataENI-${var.deployment_id}"
  }
}

resource "aws_network_interface" "adc_servers_eni" {
  subnet_id       = aws_subnet.adc_servers_net.id
  security_groups = [aws_security_group.adc_data_sg.id]

  private_ips = ["${cidrhost(var.subnet_cidrs[2], 10)}", "${cidrhost(var.subnet_cidrs[2], 11)}"]

  tags = {
    Name = "ADCServersENI-${var.deployment_id}"
  }
}


resource "aws_eip" "adc_eip" {
  domain = "vpc"
}

locals {
  mgmt_subnet_gateway    = cidrsubnet(var.subnet_cidrs[0], 8, 1)
  data_subnet_gateway    = cidrsubnet(var.subnet_cidrs[1], 8, 1)
  servers_subnet_gateway = cidrsubnet(var.subnet_cidrs[2], 8, 1)
}

resource "aws_eip_association" "adc_eip_assoc" {
  network_interface_id = aws_network_interface.adc_mgmt_eni.id
  allocation_id = aws_eip.adc_eip.id
}

resource "aws_instance" "adc_instance" {
  ami                   = var.ami_id
  instance_type         = var.instance_type
  availability_zone     = "${var.region}${var.availability_zone}"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.adc_mgmt_eni.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.adc_data_eni.id
  }

  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.adc_servers_eni.id
  }

  user_data = templatefile("${path.module}/userdata.tpl", {
    admin_user             = var.admin_user,
    admin_password         = var.admin_password,
    gel_url_primary        = var.gel_url_primary,
    gel_url_secondary      = var.gel_url_secondary,
    vm_name                = var.vm_name,
    gel_ent_id             = var.gel_ent_id,
    gel_throughput_mb      = var.gel_throughput_mb,
    gel_dns_pri            = var.gel_dns_pri,
    ntp_primary_server     = var.ntp_primary_server,
    ntp_tzone              = var.ntp_tzone,
    cc_local_ip            = var.cc_local_ip,
    cc_remote_ip           = var.cc_remote_ip,
    adc_data_eni_private_ip = aws_network_interface.adc_data_eni.private_ip,
    //adc_servers_eni_private_ip = aws_network_interface.adc_servers_eni.private_ip,
    adc_servers_private_ip1 = tolist(aws_network_interface.adc_servers_eni.private_ips)[0],
    adc_servers_private_ip2 = tolist(aws_network_interface.adc_servers_eni.private_ips)[1],
    data_subnet_gateway    = local.data_subnet_gateway,
    servers_subnet_gateway = local.servers_subnet_gateway
    hst1_ip                = var.hst1_ip,
    hst1_severity          = var.hst1_severity,
    hst1_facility          = var.hst1_facility,
    hst1_module            = var.hst1_module,
    hst1_port              = var.hst1_port,
    hst2_ip                = var.hst2_ip,
    hst2_severity          = var.hst2_severity,
    hst2_facility          = var.hst2_facility,
    hst2_module            = var.hst2_module,
    hst2_port              = var.hst2_port
    gel_enabled            = var.gel_enabled
  })

  tags = {
    Name = "ADCInstance-${var.deployment_id}"
  }
}

output "deployment_message" {
  description = "Deployment message for the EC2 instance"
  value = var.operation == "create" ? format("Alteon ADC has been deployed to EC2 AWS %s in account %s with instance ID %s. Access it at https://%s. You can SSH into the instance using port 2222. It might take 15-20 minutes for Alteon ADC to load up the config. If the userdata that was passed to the TF template was not valid, the admin password that you defined will not work, and instead the admin password will be the Instance ID: %s", var.region, data.aws_caller_identity.current.account_id, aws_instance.adc_instance.id, aws_eip.adc_eip.public_ip, aws_instance.adc_instance.id) : format("Alteon ADC in EC2 AWS %s with instance ID %s is being destroyed.", var.region, aws_instance.adc_instance.id)
}
