resource "oci_core_virtual_network" "wg_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "wgVCN"
  dns_label      = "wgvcn"
}

resource "oci_core_subnet" "wg_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "wgSubnet"
  dns_label         = "wgsubnet"
  security_list_ids = [oci_core_security_list.wg_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.wg_vcn.id
  route_table_id    = oci_core_route_table.wg_route_table.id
  dhcp_options_id   = oci_core_virtual_network.wg_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "wg_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "wgIG"
  vcn_id         = oci_core_virtual_network.wg_vcn.id
}

resource "oci_core_route_table" "wg_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.wg_vcn.id
  display_name   = "wgRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.wg_internet_gateway.id
  }
}

resource "oci_core_security_list" "wg_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.wg_vcn.id
  display_name   = "wgSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  egress_security_rules {
    protocol    = "17"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.ingress_ip_ssh

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "17"
    source   = var.ingress_ip_app

    udp_options {
      max = var.wg_listen_port
      min = var.wg_listen_port
    }
  }
}