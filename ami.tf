data "aws_ami" "bastion_ami" {
  most_recent = "true"
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}
