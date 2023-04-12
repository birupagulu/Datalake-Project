terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
required_version = "~> 1.4.4"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_db_instance" "datalake" {
  allocated_storage    = 100
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.m5d.xlarge"
  username             = "admin"
  password             = "biru2023"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "riyanshi"

  tags = {
    Name        = "riyanshi"
    Environment = "Dev"
  }
}

resource "aws_dms_replication_instance" "test" {
  allocated_storage            = 50
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = "eu-west-3c"
  engine_version               = "3.4.7"
  kms_key_arn                  = "arn:aws:kms:eu-west-3:613112451235:key/70059c4e-7a41-404a-aa6a-1b4e2a6efad9"
  multi_az                     = false
  preferred_maintenance_window = "sun:10:30-sun:14:30"
  publicly_accessible          = true
  replication_instance_class   = "dms.t3.medium"
  replication_instance_id      = "test-dms-replication-instance-tf"
  replication_subnet_group_id  = default-vpc-08ab7ee72dc6b34e5

  tags = {
    Name = "test"
  }

  vpc_security_group_ids = [
    "sg-08f85dbc6d552b83a",
  ]

  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRDSS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}