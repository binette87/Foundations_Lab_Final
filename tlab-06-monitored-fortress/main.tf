provider "aws" {
  region = "us-east-1"
}

# ====================================================================
# TITAN FINTECH: THE MONITORED FORTRESS
# Build your VPC, Subnets, Flow Logs, Security Group, and EC2 instance below.
# 
# Hint: When your EC2 instance needs an IAM profile, use:
# iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
# 
# Hint: When your Flow Log needs an IAM role, use:
# iam_role_arn = aws_iam_role.flow_log_role.arn
# ====================================================================
# --- THE PERIMETER ---

resource "aws_vpc" "titan_prod_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "Titan-Prod-VPC" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.titan_prod_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "Titan-Public-Subnet" }
}

resource "aws_internet_gateway" "titan_igw" {
  vpc_id = aws_vpc.titan_prod_vpc.id
  tags = { Name = "Titan-IGW" }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.titan_prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.titan_igw.id
  }
  tags = { Name = "Titan-Public-RT" }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# --- THE WIRETAP ---

resource "aws_cloudwatch_log_group" "titan_flow_logs" {
  name              = "/tkh/titan-prod-vpc-logs"
  retention_in_days = 1
}

resource "aws_flow_log" "titan_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.titan_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.titan_prod_vpc.id
}

# --- THE ZERO TRUST COMPUTE ---

resource "aws_security_group" "zero_trust_sg" {
  name        = "Titan-Zero-Trust-SG"
  description = "Zero inbound. All outbound. SSM only."
  vpc_id      = aws_vpc.titan_prod_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Titan-Zero-Trust-SG" }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "titan_prod_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.zero_trust_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = true

  tags = { Name = "Titan-Prod-Server" }
}
