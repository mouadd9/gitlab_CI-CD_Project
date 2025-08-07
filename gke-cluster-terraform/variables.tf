variable "project_id" {
  type        = string
  description = "The GCP project ID to deploy resources into."
  default     = "organic-storm-468202-p2"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy resources into."
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-east1-b"
}

variable "cluster_name" {
  type        = string
  description = "The name for the GKE cluster."
  default     = "my-gke-cluster"
}
