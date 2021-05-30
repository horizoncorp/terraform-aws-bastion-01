resource "aws_instance" "web" {
  ami           = aws_ami.bastion_ami.id
  instance_type = var.instance_type
}