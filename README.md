# Aviatrix FQDN Gateway for Aviatrix FireNet

Terraform module to create an Aviatrix FQDN Gateway for FireNet
https://docs.aviatrix.com/HowTos/firewall_network_workflow.html#launching-associating-aviatrix-fqdn-gateway


## Sample usage

```hcl
module "fqdn_firenet" {
  source  = "bayupw/fqdn-firenet/aviatrix"
  version = "1.0.0"

  cloud_type      = "aws"
  account         = "aws-account"
  region          = "ap-southeast-2"
  fqdn_subnet     = "10.0.0.16/28"
  firenet_vpc_id  = "vpc-0a1b2c3d4e"
  firenet_gw_name = "egress-firenet-gw"
}
```

## Sample useage with Aviatrix TGW and mc-transit module for FireNet

```hcl
# Create Transit Firenet for Egress
#Create TGW
module "tgw" {
  source  = "bayupw/tgw-o/aviatrix"
  version = "1.0.0"

  aws_account = var.aws_account
  aws_region  = var.aws_region
  tgw_name    = "avx-tgw"
  tgw_asn     = 65000
}

module "egress_firenet" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.0.0"

  name              = "egress-firenet"
  cloud             = "aws"
  region            = var.aws_region
  cidr              = "10.99.0.0/23"
  account           = var.aws_account
  instance_size     = "c5n.xlarge"
  hybrid_connection = true # true for TGW 
  enable_firenet    = true # true for TGW FireNet
  ha_gw             = false
}

# Create firewall security domains
resource "aviatrix_aws_tgw_security_domain" "egress_domain" {
  name              = "Egress"
  tgw_name          = module.tgw.tgw.tgw_name
  aviatrix_firewall = true

  depends_on = [module.tgw]
}

# Attach Firenet VPC to TGW egress domain
resource "aviatrix_aws_tgw_vpc_attachment" "egress_tgw_attachment" {
  tgw_name             = module.tgw.tgw.tgw_name
  region               = var.aws_region
  security_domain_name = aviatrix_aws_tgw_security_domain.egress_domain.name
  vpc_account_name     = var.aws_account
  vpc_id               = module.egress_firenet.vpc.vpc_id

  depends_on = [module.tgw, module.egress_firenet]
}

# Create FQDN gateway for Aviatrix FireNet
module "fqdn_firenet" {
  source  = "bayupw/fqdn-firenet/aviatrix"
  version = "1.0.0"
  
  cloud_type      = "aws"
  account         = var.aws_account
  region          = var.aws_region
  fqdn_subnet     = module.egress_firenet.vpc.public_subnets[1].cidr
  firenet_vpc_id  = module.egress_firenet.vpc.vpc_id
  firenet_gw_name = module.egress_firenet.transit_gateway.gw_name

  depends_on = [module.tgw, module.egress_firenet]
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/bayupw/terraform-aviatrix-fqdn-firenet/issues/new) section.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bayupw/terraform-aviatrix-fqdn-firenet/tree/master/LICENSE) for full details.