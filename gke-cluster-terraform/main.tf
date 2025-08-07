# The terraform Block
# - It configures Terraform's behavior itself, not your infrastructure
# - Settings here affect how Terraform runs, what providers it uses, where it stores state, etc.
terraform {
  # this block specifies which provider plugins are required
  /*
  When you run terraform init, Terraform will download and install the Google Cloud provider plugin that matches these requirements,
  allowing you to manage Google Cloud resources like Compute Engine instances, Cloud Storage buckets, etc.
  */
  required_providers {
    # the local name used to reference the GCP throughout your Terraform configuration.
    google = {
      source  = "hashicorp/google" # This specifies where to download the provider from
      version = "~> 5.34.0"
    }
  }
}

# provider configuration block that defines the arguments passed to an already-installed provider plugin at runtime.
# it configures how Terraform should connect to and interact with Google Cloud Platform.
# The plugin uses these arguments to configure its API client.
provider "google" { # This declares that you're configuring the Google Cloud provider
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

/*
To summarize the distinction:
required_providers is used by init to download and install the necessary executable code,
while the provider block is used by plan and apply to configure and direct the behavior of that executable code at runtime.
*/