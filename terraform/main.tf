# resource "tls_private_key" "compute_ssh_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_vnic_attachments" "app_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.wg_server.id
}

data "oci_core_vnic" "app_vnic" {
  vnic_id = data.oci_core_vnic_attachments.app_vnics.vnic_attachments[0]["vnic_id"]
}

# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "wg_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "null_resource" "provisioner" {
  provisioner "remote-exec" {
    connection {
      host = oci_core_instance.wg_server.public_ip
      user = "opc"
      private_key = file(var.private_key_path)
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u opc -i '${oci_core_instance.wg_server.public_ip},' --private-key=${var.private_key_path} ../ansible/playbook.yaml -e 'PRIVATEKEY=${var.wg_private_key} WG_IP_ADRESS=${var.wg_ip_address} WG_LISTEN_PORT=${var.wg_listen_port} WG_PEER0_PUBLICKEY=${var.wg_peer0_publickey} WG_PEER0_ENDPOINT=${var.wg_peer0_endpoint} WG_PEER0_IPS=${var.wg_peer0_ips}'"
  }
}
