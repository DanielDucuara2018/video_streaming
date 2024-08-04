resource "outscale_public_ip" "ec2_public_ip" {
  tags {
    key   = "name"
    value = "ec2 instance public ip"
  }
}

resource "outscale_vm" "vm_public" {
  image_id           = var.omi_id
  vm_type            = var.instance_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group_public.id]
  subnet_id          = outscale_subnet.subnet_public.id
  depends_on         = [outscale_public_ip.ec2_public_ip]

  tags {
    key   = "name"
    value = "terraform-public-vm-wireguard"
  }

  tags {
    key   = "osc.fcu.eip.auto-attach"
    value = outscale_public_ip.ec2_public_ip.public_ip
  }
  user_data = base64encode(file("./resources/init_vm_public.sh"))
}



resource "outscale_vm" "vm_private" {
  image_id           = var.omi_id
  vm_type            = var.instance_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group_private.id]
  subnet_id          = outscale_subnet.subnet_private.subnet_id
  private_ips        = ["192.168.2.100"]
  placement_tenancy  = "default"

  block_device_mappings {
    device_name = "/dev/sda1" # /dev/sda1 corresponds to the root device of the VM
    bsu {
      volume_size           = 500 #GiB
      delete_on_vm_deletion = true
    }
  }

  tags {
    key   = "name"
    value = "terraform-private-vm-internal-network"
  }

  user_data = base64encode(file("./resources/init_vm_private.sh"))
}



