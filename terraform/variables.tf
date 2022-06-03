variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "private_key_path" {}

variable "ingress_ip_ssh" { default = "0.0.0.0/0" }

variable "ingress_ip_app" { default = "0.0.0.0/0" }

variable "compartment_ocid" {}

variable "region" {}

variable "instance_shape" { default = "VM.Standard.E2.1.Micro" }

variable "instance_ocpus" { default = 1 }

variable "instance_shape_config_memory_in_gbs" { default = 0.5 }

### Wireguard related variables

variable "wg_private_key" {}

variable "wg_ip_address" {}

variable "wg_listen_port" {}

variable "wg_peer0_publickey" {}

variable "wg_peer0_endpoint" { default="" }

variable "wg_peer0_ips" {}