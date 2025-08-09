#router.tf

# The goal is to give our private GKE nodes a secure way to make outbound connections to the internet,
# primarily to download container images.
# We accomplish this using two resources that work together:
# a Cloud Router and a Cloud NAT gateway.



# 1. Create the Cloud Router
# In GCP Router operates at the VPC level
# All subnets in that region can use the same router
# One router can serve multiple subnets
/*
VPC Network
├── Subnet A (10.0.1.0/24) ─┐
├── Subnet B (10.0.2.0/24) ─┼─ Router ─ Internet
└── Subnet C (10.0.3.0/24) ─┘
 */

# its main job is to provide the underlying control plane required for the Cloud NAT service to function.
resource "google_compute_router" "router" {
  name    = "gke-nat-router"
  region  = var.region
  network = google_compute_network.vpc.id
}


# 2. Create the Cloud NAT Gateway and attach it to the router
/*
This is the NAT service itself. It attaches to the router and does the actual work.
The line source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" tells it to provide outbound internet access for all IPs in our subnet (nodes, pods, and services).
When a pod on a private node tries to reach the internet, this NAT gateway will temporarily replace the pod's private source IP with a public one, allowing the connection to go through.
*/
resource "google_compute_router_nat" "nat" {
  name                               = "gke-nat-gateway"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  # Only specific subnets
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}