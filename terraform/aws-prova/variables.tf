variable "instance_name" {
  description = "Valore del tagname della istanza EC2"
  type        = string
  default     = "MyNewInstance"
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t2-micro"
}
