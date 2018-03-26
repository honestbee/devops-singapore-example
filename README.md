# DevOps Singapore Example

Example of deploying applications to across 2 Kubernetes clusters using

- Helm
- VaultController
- externalDNS
- Atlantis & Terraform

## Demo

List existing demo records

```
aws route53 list-resource-record-sets --hosted-zone-id ZNCSEA5FAW4K2 --query "ResourceRecordSets[?contains(Name,'devops-sg-demo')]" | jq -r ".[] | [ .Name, .Type] | @tsv"
```

Apply pull request

Confirm existing records.


## Notes

- Atlantis 0.2 currently does not mask secrets, this is planned to land in 0.3
- externalDNS does not support weighted routes - hence the use of Terraform to create weighted routes
