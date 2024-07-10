resource "aws_instance" "example_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  user_data = "${file("user_data.sh")}"

  tags = {
    Name = var.instance_name
  }
}
  