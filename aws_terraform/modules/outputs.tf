output "jenkinsendpint" {
  value = module.ec2.jenkinsendpoint
}

output "jenkinspubip" {
  value = module.ec2.ec2pubip
}