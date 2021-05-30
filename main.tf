resource "tls_private_key" "bastion_private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = "${var.environment}-bastion"
  public_key = tls_private_key.bastion_private_ssh_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.bastion_ami.id
  instance_type               = var.instance_type
  ebs_optimized               = true
  monitoring                  = false
  key_name                    = aws_key_pair.generated_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = ["value"]
  associate_public_ip_address = false
  source_dest_check           = true
  user_data                   = var.user_data
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
    encrypted             = true
  }
}

