# DevOps Singapore Example

Example of deploying applications across 2 Kubernetes clusters using

- [Helm](https://github.com/kubernetes/helm)
- [VaultController](https://github.com/roboll/kube-vault-controller)
- [externalDNS](https://github.com/kubernetes-incubator/external-dns)
- [Atlantis](https://www.runatlantis.io/) & [Terraform](terraform.io)

Slides: [speakerdeck.com/so0k](https://speakerdeck.com/so0k/terraform-at-honestbee)

## Demo

List existing demo records

```
aws route53 list-resource-record-sets --hosted-zone-id ZNC... --query "ResourceRecordSets[?contains(Name,'devops-sg-demo')]" | jq -r ".[] | [ .Name, .Type] | @tsv"
```

Atlantis apply pull request [#4](https://github.com/honestbee/devops-singapore-example/pull/4) to create weighted routes

Confirm existing records.

## Notes

- Atlantis 0.2 currently does not mask secrets, this landed in 0.3
- externalDNS [does not support weighted routes](https://github.com/kubernetes-incubator/external-dns/issues/196) - hence the use of Terraform to create weighted routes
