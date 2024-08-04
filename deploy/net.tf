resource "outscale_net" "main_vpc" {
  ip_range = var.vpc_ip_range
  tenancy  = "default"

  tags {
    key   = "Name"
    value = "terraform-vpc"
  }
}

resource "outscale_subnet" "subnet_public" {
  net_id         = outscale_net.main_vpc.net_id
  ip_range       = var.subnet_ip_range_public
  subregion_name = "${var.region}a"
}

resource "outscale_subnet" "subnet_private" {
  net_id         = outscale_net.main_vpc.net_id
  ip_range       = var.subnet_ip_range_private
  subregion_name = "${var.region}a"
}

resource "outscale_internet_service" "internet_service" {
  tags {
    key   = "Name"
    value = "terraform-internet-gateway"
  }
}

resource "outscale_internet_service_link" "internet_service_link" {
  internet_service_id = outscale_internet_service.internet_service.internet_service_id
  net_id              = outscale_net.main_vpc.net_id
}


resource "outscale_route_table" "route_table_public" {
  net_id     = outscale_net.main_vpc.net_id
  depends_on = [outscale_subnet.subnet_private, outscale_subnet.subnet_public]

  tags {
    key   = "Name"
    value = "terraform-route-table-public"
  }

}

resource "outscale_route_table_link" "route_table_link_public" {
  subnet_id      = outscale_subnet.subnet_public.subnet_id
  route_table_id = outscale_route_table.route_table_public.route_table_id
}

resource "outscale_route" "route_public" {
  route_table_id       = outscale_route_table.route_table_public.route_table_id
  destination_ip_range = "0.0.0.0/0"
  gateway_id           = outscale_internet_service.internet_service.internet_service_id
  depends_on           = [outscale_internet_service.internet_service]
}


resource "outscale_public_ip" "nat_public_ip" {
  tags {
    key   = "name"
    value = "NAT public ip"
  }
}

resource "outscale_nat_service" "nat_service" {
  subnet_id    = outscale_subnet.subnet_public.subnet_id
  public_ip_id = outscale_public_ip.nat_public_ip.public_ip_id
  depends_on   = [outscale_route.route_public]
}

resource "outscale_route_table" "route_table_private" {
  net_id     = outscale_net.main_vpc.net_id
  depends_on = [outscale_subnet.subnet_private, outscale_subnet.subnet_public]

  tags {
    key   = "Name"
    value = "terraform-route-table-private"
  }
}

resource "outscale_route_table_link" "route_table_link_private" {
  subnet_id      = outscale_subnet.subnet_private.subnet_id
  route_table_id = outscale_route_table.route_table_private.route_table_id
}

resource "outscale_route" "route_private" {
  route_table_id       = outscale_route_table.route_table_private.route_table_id
  destination_ip_range = "0.0.0.0/0"
  nat_service_id       = outscale_nat_service.nat_service.nat_service_id
  depends_on           = [outscale_nat_service.nat_service]
}

