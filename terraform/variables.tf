variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI for us-east-1"
  default     = "ami-0b72821e2f351e396"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}
