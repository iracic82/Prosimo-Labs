
output "FGT1PublicIP" {
  value = aws_eip.FGTPublicIP.public_ip
}


output "FGT2PublicIP" {
  value = aws_eip.FGTPublicIP2.public_ip
}


output "Username" {
  value = "admin"
}

output "Password_for_FGT1" {
  value = aws_instance.fgtvm.id
}

output "Password_for_FGT2" {
  value = aws_instance.fgtvm2.id
}

output "LoadBalancerPrivateIP" {
  value = data.aws_network_interface.gwlbip.private_ip
}
output "LoadBalancerPrivateIP2" {
  value = data.aws_network_interface.gwlbipaz2.private_ip
}
output "LoadBalancerEPservice" {
  value = aws_vpc_endpoint_service.fgtgwlbservice.id
}
#output "CustomerVPC" {
#  value = aws_vpc.customer-vpc.id
#}

output "FGTVPC" {
  value = aws_vpc.fgtvm-vpc.id
}
