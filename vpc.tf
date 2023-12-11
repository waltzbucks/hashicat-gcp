
module "vpc" {
  source  = "app.terraform.io/ACME-TF-WORKSHOP/network/google"
  version = "3.4.0"

  project_id   = var.project
  network_name = "gaurav-network"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "gaurav-subnet"
      subnet_ip     = "10.100.10.0/24"
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]

    subnet-02 = []
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    {
      name                   = "app-proxy"
      description            = "route through proxy to reach app"
      destination_range      = "10.50.10.0/24"
      tags                   = "app-proxy"
      next_hop_instance      = "app-proxy-instance"
      next_hop_instance_zone = "us-west1-a"
    },
  ]
}
