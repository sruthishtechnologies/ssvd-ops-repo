package kubernetes.network

deny[msg] {
  input.kind == "Service"
  input.spec.type == "LoadBalancer"
  msg := sprintf("Service %s must not be type LoadBalancer; use Ingress instead", [input.metadata.name])
}

deny[msg] {
  input.kind == "Ingress"
  input.metadata.namespace == "ssvd-prod"
  input.metadata.annotations["alb.ingress.kubernetes.io/scheme"] == "internet-facing"
  not input.metadata.annotations["alb.ingress.kubernetes.io/wafv2-acl-arn"]
  msg := sprintf("Production Ingress %s must attach an AWS WAFv2 ACL", [input.metadata.name])
}
