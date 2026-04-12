output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "route53_zone_id" {
  value = module.dns.zone_id
}

output "route53_name_servers" {
  value = module.dns.name_servers
}
