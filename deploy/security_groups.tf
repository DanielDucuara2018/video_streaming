# sg_public
resource "outscale_security_group" "security_group_public" {
  description         = "sgpublic"
  security_group_name = "sgpublic"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "Allow SSH and Wireguard access in port 51820"
  }
}

# sg_private
resource "outscale_security_group" "security_group_private" {
  description         = "sgprivate"
  security_group_name = "sgprivate"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "Allow all traffic from public subnet"
  }
}

# sg_public_rules
resource "outscale_security_group_rule" "sg_public_ssh_rule" { # optional
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_public.security_group_id
  from_port_range   = "22"
  to_port_range     = "22"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0" # "${var.osc_ip}"
}

resource "outscale_security_group_rule" "sg_public_wg_rule" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_public.security_group_id
  from_port_range   = "51820"
  to_port_range     = "51820"
  ip_protocol       = "udp"
  ip_range          = "0.0.0.0/0" # "${var.osc_ip}"
}

resource "outscale_security_group_rule" "sg_public_all_traffic_rule_from_sg_private" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_public.security_group_id
  rules {
    security_groups_members {
      security_group_id = outscale_security_group.security_group_private.security_group_id
    }
  }
}

# sg_private_rules
resource "outscale_security_group_rule" "sg_private_ssh_rule" { # optional
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_private.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    security_groups_members {
      security_group_id = outscale_security_group.security_group_public.security_group_id
    }
  }
}

resource "outscale_security_group_rule" "sg_private_all_traffic_rule_from_sg_public" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_private.security_group_id
  rules {
    security_groups_members {
      security_group_id = outscale_security_group.security_group_public.security_group_id
    }
  }
}
