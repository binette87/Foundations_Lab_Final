provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# The Guardrail
resource "aws_budgets_budget" "tlab_budget" {
  name         = "TLAB-Strict-Budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type              = "PERCENTAGE"
    subscriber_email_addresses = ["binetazak@gmail.com"]
  }
}

# The Vault
resource "random_id" "id" {
  byte_length = 4
}

resource "aws_s3_bucket" "vault" {
  bucket = "titan-fintech-vault-bf-${random_id.id.hex}"
}

resource "aws_s3_bucket_public_access_block" "vault_block" {
  bucket                  = aws_s3_bucket.vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# The Surgical Identity (replaces the sabotaged user/policy above)
resource "aws_iam_role" "vault_role" {
  name = "Titan-EC2-Vault-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "vault_put_policy" {
  name = "Titan-Vault-PutObject-Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.vault.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.vault_role.name
  policy_arn = aws_iam_policy.vault_put_policy.arn
}

resource "aws_iam_instance_profile" "vault_profile" {
  name = "Titan-EC2-Vault-Profile"
  role = aws_iam_role.vault_role.name
}

# The Compute
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
}

resource "aws_instance" "vault_instance" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.vault_profile.name

  tags = {
    Name = "Titan-Vault-Instance"
  }
}