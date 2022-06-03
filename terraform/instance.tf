data "tls_public_key" "oci_api_key" {
  private_key_pem = file(var.private_key_path)
}

resource "oci_core_instance" "wg_server" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "wgServer"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.wg_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "wgServer"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.wg_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = data.tls_public_key.oci_api_key.public_key_openssh
  }
}