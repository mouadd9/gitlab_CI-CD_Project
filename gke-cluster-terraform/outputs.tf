#outputs.tf

output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "The name of the GKE cluster."
}

output "cluster_endpoint" {
  value       = "https://{google_container_cluster.primary.endpoint}"
  description = "The IP address of the GKE cluster's master."
  sensitive   = true
}