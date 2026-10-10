variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "ami_id" {
  description = "Ubuntu Server 24.04 LTS AMI for ap-southeast-1"
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}
