resource "tls_private_key" "bastion_private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = "${var.environment}-bastion"
  public_key = tls_private_key.bastion_private_ssh_key.public_key_openssh
}

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}

module "sg" {
  source = "github.com/horizoncorp/terraform-aws-securitygroup-01"
  name   = "sg"
  vpc_id = var.vpc_id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.bastion_ami.id
  instance_type               = var.instance_type
  ebs_optimized               = true
  monitoring                  = false
  key_name                    = aws_key_pair.generated_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.sg.sg_id]
  associate_public_ip_address = false
  source_dest_check           = true
  user_data                   = join("\n", [data.template_file.init.rendered, var.user_data])
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
    encrypted             = true
  }
}

module "sg-ssh" {
  source = "github.com/horizoncorp/terraform-aws-securitygroup-01/modules/allow-ssh-22"
  name   = "sg-ssh"
  security_group_id = module.sg.sg_id
  cidr_blocks = ["10.0.0.0/24"]
}