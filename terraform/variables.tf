variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu Server 22.04 LTS AMI for us-east-1"
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}
