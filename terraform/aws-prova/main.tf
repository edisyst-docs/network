# Provider Block
# profile=default si prende le mie crdenziali dal plugin di AWS che devo installare e configurare su Linux
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Resource Block
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.ec2_instance_type

  tags = {
    Name = var.instance_name
  }
}
