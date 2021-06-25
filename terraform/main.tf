resource "ibm_is_vpc" "opa_vpc" {
  name = "opa"
}
resource "ibm_is_subnet" "opa_subnet" {
  name            = "opa-subnet"
  vpc             = ibm_is_vpc.opa_vpc.id
  zone            = "us-south-1"
  total_ipv4_address_count  = 256
}
resource "ibm_is_ssh_key" "opa_key" {
  name       = "opa-key"
  public_key = var.ssh_key
}

resource "ibm_is_instance" "instance1" {
  name     = "opa-instance"
  image    = var.image
  profile  = var.profile
  primary_network_interface {
    subnet = ibm_is_subnet.opa_subnet.id
  }
  vpc       = ibm_is_vpc.opa_vpc.id
  zone      = "us-south-1"
  keys      = [ibm_is_ssh_key.opa_key.id]
}
resource "ibm_is_security_group" "opa_sg" {
  name = "opa-sg"
  vpc  = ibm_is_vpc.opa_vpc.id
}
resource "ibm_is_security_group_rule" "outbound" {
  group     = ibm_is_security_group.opa_sg.id
  direction = "outbound"
#   remote    = "0.0.0.0/0"
  remote = "127.0.0.1"
}
resource "ibm_is_security_group_rule" "inbound" {
  group     = ibm_is_security_group.opa_sg.id
  direction = "inbound"
  remote = "127.0.0.1"
#   remote    = "0.0.0.0/0"
}
resource "ibm_is_security_group_rule" "icmp" {
  group     = ibm_is_security_group.opa_sg.id
  direction = "inbound"
  remote    = "127.0.0.1"
  icmp {
    code = 20
    type = 30
  }
}