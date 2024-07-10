resource "aws_instance" "main" {
  ami           = "ami-01376101673c89611"
  instance_type = "t2.micro"
  tags = {
    Name = "project"
  }
}

# terraform import aws_instance.main "instance ID"