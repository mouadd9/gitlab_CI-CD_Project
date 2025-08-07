#gke.tf


resource "google_container_cluster" "primary" {
  name = var.cluster_name
  location = var.region
  networking_mode = "VPC_NATIVE"
  # Connect the cluster to our custom network
  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id
  remove_default_node_pool = true # We will create a custom node pool
  initial_node_count       = 1
  # Tell the cluster which secondary ranges to use
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.vpc_subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.vpc_subnetwork.secondary_ip_range[1].range_name
  }
  # In your gke.tf file, inside the google_container_cluster resource

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  # network_policy
  # private_cluster_config
  # workload_identity_config
}

# 4. Define a custom node pool for the cluster's worker machines
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1 # Set the number of nodes (VMs) in the pool

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # service_account = google_service_account.gke_nodes_sa.email

  }

  # management
}

### NOTE
/*
GKE is a managed service, which means Google runs the control plane for you on separate, Google-managed infrastructure.
This includes critical components like the API server, scheduler, and etcd database.
You don't see this infrastructure, and you don't configure it.
*/

/*
A node pool is a group of nodes within a cluster that all share the same configuration (machine_type, disk size, etc.).
*/

/*
Modern GKE clusters take this a step further.
They are VPC-native, which means that not only do the nodes get an IP from the subnet,
but the Pods running on those nodes also get their own unique IP addresses directly from a secondary range within that same subnet.
This simplifies networking by eliminating the need for complex network address translation (NAT) between pods.
*/