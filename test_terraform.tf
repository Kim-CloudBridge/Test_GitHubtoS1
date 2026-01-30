provider "aws" {
  region = "us-east-1"
}

# Public S3 bucket with no encryption
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "sentinelone-test-insecure-bucket-123456"

  acl    = "public-read"

  versioning {
    enabled = false
  }
}

# Security Group allowing SSH from anywhere
resource "aws_security_group" "open_ssh" {
  name        = "open-ssh-sg"
  description = "Insecure SG for testing"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance without IMDSv2
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "optional"
  }

  vpc_security_group_ids = [aws_security_group.open_ssh.id]
}
