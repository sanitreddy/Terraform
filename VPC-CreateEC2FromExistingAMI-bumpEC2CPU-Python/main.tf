resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.id]

  tags = {
    Name = var.instance_name
  }

  provisioner "local-exec" {
    command = "echo ${self.id} > instance_id.txt"
  }
}
  
data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ExampleInstanceImage"]
  }

  filter {
    name   = "owner-id"
    values = ["654654530894"] # Amazon's official AMI owner ID
  }
}