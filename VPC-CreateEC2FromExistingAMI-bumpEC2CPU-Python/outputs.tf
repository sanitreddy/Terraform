output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example_instance.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.example_instance.private_ip
}

output "ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.example_vpc.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.example_subnet.id
}
