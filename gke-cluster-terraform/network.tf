#network.tf

# we create a logically isolated VPC named gke-network
# we create a subnet named gke-subnetwork inside the VPC we just defined.
# This is where our GKE cluster's nodes will actually live.

# a VPC is Global not regional (it can span across multiple Regions)
resource "google_compute_network" "vpc" {
  name                    = "gke-vpc-network"
  auto_create_subnetworks = false
}

# a subnet belongs to only one region
# We create an implicit dependency by referencing the network within the subnetwork Terraform now understands that it must create the network before it can create the subnetwork.
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "gke-vpc-subnetwork"
  region        = var.region
  ip_cidr_range = "10.10.0.0/24" # The purpose of this range is to assign IP addresses to the primary network interfaces (vNICs) of Compute Engine virtual machines. In our GKE context, this means the worker nodes themselves get their IP addresses from this pool.
  network       = google_compute_network.vpc.id

  # private_ip_google_access = true

  # Add secondary ranges for Pods and Services
  # These are additional, non-overlapping CIDR blocks that are logically associated with the same subnet. They are not used for assigning IPs to VM network interfaces directly. Instead, they provide IP pools for Alias IP ranges.

  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services-ip-range"
    ip_cidr_range = "10.30.0.0/24"
  }
}


#### NOTE 1
# resource "resource_type" "local_name" {}
# the Resource Type tells Terraform what to build, and the Local Name gives you a way to refer to it inside your code.
#### NOTE 2
# network = google_compute_network.vpc_network.id
# this tells the subnetwork resource to get the unique ID from the vpc_network resource after it has been created.
### NOTE 3
# in gke we assign pods and services ip addresses from the subnet because
# we are using a multi node cluster and pod to pod communication must be managed at the VPC level
# thus pod ips must be routable by the VPC.
