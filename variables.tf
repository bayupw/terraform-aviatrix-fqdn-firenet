variable "cloud_type" {
  description = "Type of cloud service provider: AWS or AWSGov"
  type        = string

  validation {
    condition     = contains(["aws", "awsgov"], lower(var.cloud_type))
    error_message = "Invalid cloud type. Choose AWS or AWSGovCloud."
  }
}

variable "account" {
  description = "Name of the cloud account in the Aviatrix controller"
  type        = string
}

variable "region" {
  description = "Region of FQDN gateway to be created in"
  type        = string
}

variable "fqdn_gw_name" {
  description = "Name of FQDN gateway"
  type        = string
  default     = "fqdn-gw"
}

variable "fqdn_gw_size" {
  description = "Instance type of FQDN gateway"
  type        = string
  default     = "t2.micro"
}

variable "fqdn_subnet" {
  description = "Subnet to launch the FQDN gateway"
  type        = string
}


variable "firenet_vpc_id" {
  description = "Firenet VPC ID"
  type        = string
}

variable "firenet_gw_name" {
  description = "Name of firenet gateway"
  type        = string
}

variable "tgw_segmentation_for_egress_enabled" {
  description = "Enable TGW Segmentation for egress"
  type        = bool
  default     = true
}

variable "single_az_ha" {
  description = "Enable single AZ HA"
  type        = bool
  default     = true
}

locals {
  cloud_type = lookup(local.cloud_type_map, lower(var.cloud_type), null)

  cloud_type_map = {
    aws    = 1,
    awsgov = 256,
  }
}