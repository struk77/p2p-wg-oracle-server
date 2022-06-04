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

variable "wg_listen_port" { default = 51820 }