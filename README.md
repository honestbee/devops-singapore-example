# DevOps Singapore Example

Example of deploying applications to across 2 Kubernetes clusters using

- Helm
- VaultController
- externalDNS
- Atlantis & Terraform

## Demo

1. Use Atlantis to create Vault secrets
1. Install Helm chart into apse1a and apse1b clusters
1. 

## Notes

- Atlantis 0.2 currently does not mask secrets, this is planned to land in 0.3
- externalDNS does not support weighted routes - hence the use of Terraform to create weighted routes
