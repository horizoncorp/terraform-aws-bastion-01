output "bastion_private_key" {
  description = "Private key generated for bastion"
  value       = tls_private_key.bastion_private_ssh_key.private_key_pem
}

output "bastion_public_ip" {
  description = "Public IP of bastion"
  value       = aws_instance.bastion.public_ip
}
