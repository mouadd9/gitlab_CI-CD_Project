# network.tf

# our architecture requires a network so that our cluster's nodes can communicate with each other and with the outside world.
# without a VPC, our GKE cluster's VMs would be isolated and not reachable.
# In GKE, we use Google Cloud's Virtual Private Cloud (VPC) to create a network for our cluster.
# A VPC is a virtualized network that provides a private, isolated environment for your resources.
# In this file, we define the VPC and its subnetwork.


# VPC a private network that provides isolation and control over our resources (VMs).
# Global by default → one VPC can span multiple regions
resource "google_compute_network" "vpc" {
  name                    = "gke-vpc-network"
  description             = "VPC network for GKE cluster"
  auto_create_subnetworks = false # we want to create our own subnets manually
}

# we create a subnet which is a smaller network segments inside our VPC for better organization, control, and security

# In GCP, subnets are tied to a specific region. So your VPC spans regions, but each subnet is regional.
# This helps with latency, fault tolerance, and compliance.
# Subnets define the IP address ranges for resources inside the VPC
# The subnet is where our GKE cluster's nodes will actually live.
# Subnets let you apply different firewall rules or routing policies per subnet, for tighter security and control.
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "gke-vpc-subnetwork"
  network       = google_compute_network.vpc.id # links the subnet to the VPC you created.
  region        = var.region # subnetworks are regional
  ip_cidr_range = "10.10.0.0/24" # The cluster nodes (VMs) get IPs from this subnet range because they are launched inside this subnet — Google Cloud assigns node IPs from this block.

  # private_ip_google_access = true

  # Add secondary ranges for Pods and Services

  # Each node in the cluster is allocated a subset of this pod IP range, When a pod is created on a Node, it gets an IP from that node’s pod CIDR block.
  # Routing between Nodes happens at the VPC level
  # Since pod IP ranges are part of the VPC’s secondary IP ranges, Google Cloud’s virtual router knows how to route pod IP traffic between nodes.
  # When a node sends a packet to a pod on another node, it sends it via the VPC network to the destination node’s primary IP (the node VM’s IP in the main subnet).
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
