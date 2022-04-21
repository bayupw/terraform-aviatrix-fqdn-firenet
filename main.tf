# Create Egress FQDN gateway
resource "aviatrix_gateway" "this" {
  cloud_type     = local.cloud_type
  account_name   = var.account
  gw_name        = var.fqdn_gw_name
  vpc_id         = var.firenet_vpc_id
  vpc_reg        = var.region
  gw_size        = var.fqdn_gw_size
  subnet         = var.fqdn_subnet
  single_ip_snat = false
  single_az_ha   = var.single_az_ha
}

# Create Aviatrix FQDN Gateway association to Aviatrix FireNet
resource "aviatrix_firewall_instance_association" "this" {
  vpc_id          = var.firenet_vpc_id
  firenet_gw_name = var.firenet_gw_name
  instance_id     = "fqdn-gw"
  vendor_type     = "fqdn_gateway"
  attached        = true

  depends_on = [aviatrix_gateway.this]
}

# Create Aviatrix Firenet
resource "aviatrix_firenet" "this" {
  vpc_id                               = var.firenet_vpc_id
  inspection_enabled                   = false
  egress_enabled                       = true
  tgw_segmentation_for_egress_enabled  = var.tgw_segmentation_for_egress_enabled
  keep_alive_via_lan_interface_enabled = false
  manage_firewall_instance_association = false

  depends_on = [aviatrix_firewall_instance_association.this]
}