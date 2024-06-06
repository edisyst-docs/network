output "instance_id" {
  description = "ID della istanza EC2"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Pub IP of AWS EC2 instance "
  value       = aws_instance.app_server.public_ip
}