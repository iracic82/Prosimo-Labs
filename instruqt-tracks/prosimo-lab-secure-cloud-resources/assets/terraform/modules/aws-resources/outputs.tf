# Print AWS Instance Public
output "aws_ec2_public_ip" {
  value = aws_instance.ec2_linux.public_ip
}

output "aws_eip_public_ip" {
  value = aws_eip.eip.public_ip
}

output "aws_vpc_id" {
  value = aws_vpc.vpc1.id
}

output "ssh_access" {
  value = "${var.aws_ec2_name} - ${aws_instance.ec2_linux.private_ip} => ssh -i '~/prosimo-lab/assets/terraform/${var.aws_ec2_key_pair_name}.pem' ec2-user@${aws_eip.eip.public_ip}"
}