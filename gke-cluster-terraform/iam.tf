# #iam.tf
 resource "google_service_account" "gke_nodes_sa" {
   account_id   = "gke-node-service-account"
   display_name = "Service Account for GKE Nodes"
 }
