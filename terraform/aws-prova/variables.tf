variable "instance_name" {
  description = "Valore del tagname della istanza EC2"
  type        = string
  default     = "MyNewInstance"
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}



variable "ec2_ami" {
  description = "AWS EC2 instance AMI ID"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "ec2_name" {
  description = "AWS EC2 instance name"
  type        = string
  default     = "MyTestEC2"
}