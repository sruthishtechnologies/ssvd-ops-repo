# SSVD Ops Repo

Central GitOps repository for deploying `ssvd-bhoomi-report` with Helm and Argo CD.

## Layout

```text
charts/myapp/       Helm chart for the application
envs/dev/           Dev environment values
envs/staging/       Staging environment values
envs/prod/          Production environment values
argocd-apps/        Argo CD Application manifests
policies/conftest/  OPA policies used by CI
.github/workflows/  Validation, security, cost, and release automation
```

## Image Promotion

Application CI should update the environment value file that is being promoted. For example:

```bash
yq -i '.image.tag = "sha-<commit-sha>"' envs/dev/values.yaml
```

Argo CD then reconciles the desired state from this repo.

## Required GitHub Settings

Repository variables:

- `INFRACOST_CURRENCY`: optional, for example `USD`

Repository secrets:

- `INFRACOST_API_KEY`: required for the Infracost workflow

## Render Locally

```bash
helm dependency update charts/myapp
helm lint charts/myapp -f envs/dev/values.yaml
helm template myapp charts/myapp -f envs/dev/values.yaml --namespace ssvd-dev
```
