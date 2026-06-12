package terraform.aws

deny[msg] {
  resource := input.resource.aws_s3_bucket_public_access_block[_]
  resource.block_public_acls == false
  msg := "S3 public access block must block public ACLs"
}

deny[msg] {
  resource := input.resource.aws_security_group[_]
  ingress := resource.ingress[_]
  ingress.cidr_blocks[_] == "0.0.0.0/0"
  ingress.from_port != 80
  ingress.from_port != 443
  msg := sprintf("Security group %s exposes non-web port %v to the internet", [resource.name, ingress.from_port])
}
