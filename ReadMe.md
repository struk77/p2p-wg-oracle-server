# Oracle Cloud Wireguard Server

This repositorium contains a code for deploying Wireguard server with predefined peers to Oracle Cloud

Requirements
------------

- [Terraform](https://www.terraform.io/downloads.html) v1.0.1 or greater
- [Python](https://www.python.org/downloads/) v3.6 or greater
- [Ansible](https://docs.ansible.com/ansible/2.3/intro_installation.html#getting-ansible) core version 2.1 or greater
- [wireguard-tools](https://www.wireguard.com/install/)

Prerequisites
------------

1. Create account in Oracle Cloud if you have not yet

2. Generate keys and get required OCIDs [Manual](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)

After second step you have to collect RSA key in PEM format (default path - ~/.oci/oci_api_key.pem) and have several variables:
- Fingerprint
- User OCID
- Tenancy OCID (the same as Compartment OCID)

3. Create oci_provider_variables.auto.tfvars file in terraform folder from example and put your data there. It is recommended to limit ingress rule ip address range like <your_ip>/32

4. Generate Wireguard server key pair if you have not yet with command
```sh
wg genkey | tee privatekey | wg pubkey > publickey
```

5. Generate each Wireguard peer key pair if you have not yet with command
```sh
wg genkey | tee <peer>_privatekey | wg pubkey > <peer>_publickey
```

6. Rename ansible/roles/wireguard/vars/server.yaml.example to ansible/roles/wireguard/vars/server.yaml and fullfill with your data.


Deploy
------------
```sh
cd terraform
terraform init
terraform apply
```