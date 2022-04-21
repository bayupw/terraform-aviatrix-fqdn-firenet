output "fqdn_gw" {
  description = "The created Aviatrix FQDN aviatrix_gateway gateway as an object with all of it's attributes"
  value       = aviatrix_gateway.this
}

output "firenet_association" {
  description = "Firewall instance association aviatrix_firewall_instance_association object with all of it's attributes"
  value       = aviatrix_firewall_instance_association.this
}

output "firenet" {
  description = "aviatrix_firenet object with all of it's attributes"
  value       = aviatrix_firenet.this
}