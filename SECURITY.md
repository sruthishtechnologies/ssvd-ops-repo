# Security Policy

Report sensitive findings privately to the repository maintainers.

## Controls

- GitHub Actions validate Helm rendering, OPA policies, Checkov, Gitleaks, and YAML quality.
- Production changes should require pull request review from CODEOWNERS.
- Production Argo CD pruning is disabled by default.
- Runtime workloads run as non-root, drop Linux capabilities, use probes, and define resource requests and limits.

## Secrets

Do not commit secrets, kubeconfigs, cloud credentials, or generated Terraform state.
