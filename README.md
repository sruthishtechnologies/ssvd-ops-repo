# SSVD Ops Repo

Central GitOps repository for deploying SSVD applications with Helm and Argo CD.

## Layout

```text
apps/<team>/<app>/chart/          Helm chart owned by the application team
envs/<env>/apps/                  Argo CD Application manifests for one environment
envs/<env>/values/<team>/<app>.yaml
                                  Environment-specific Helm values
bootstrap/<env>/root.yaml         App-of-apps root for that environment's Argo CD
platform/                         Shared platform add-ons and cluster services
policies/conftest/                OPA policies used by CI
.github/workflows/                Validation, security, cost, and release automation
```

Current application:

```text
apps/srisatvam/bhoomi-report/chart/
envs/dev/values/srisatvam/bhoomi-report.yaml
envs/staging/values/srisatvam/bhoomi-report.yaml
envs/prod/values/srisatvam/bhoomi-report.yaml
```

## Image Promotion

Application CI promotes an immutable image tag by opening a pull request against
one environment values file. For example:

```bash
yq -i '.image.tag = "sha-<commit-sha>"' envs/dev/values/srisatvam/bhoomi-report.yaml
```

Argo CD then reconciles the desired state from this repo.

## Required GitHub Settings

Repository variables:

- `INFRACOST_CURRENCY`: optional, for example `USD`

Repository secrets:

- `INFRACOST_API_KEY`: required for the Infracost workflow

## Bootstrap Argo CD

Each environment has its own Kubernetes cluster and Argo CD instance. Apply only
the matching bootstrap file in that cluster:

```bash
kubectl apply -f bootstrap/dev/root.yaml
kubectl apply -f bootstrap/staging/root.yaml
kubectl apply -f bootstrap/prod/root.yaml
```

The dev Argo CD watches `envs/dev/apps`, staging watches `envs/staging/apps`,
and prod watches `envs/prod/apps`.

## Render Locally

```bash
helm dependency update apps/srisatvam/bhoomi-report/chart
helm lint apps/srisatvam/bhoomi-report/chart -f envs/dev/values/srisatvam/bhoomi-report.yaml
helm template bhoomi-report-dev apps/srisatvam/bhoomi-report/chart -f envs/dev/values/srisatvam/bhoomi-report.yaml --namespace ssvd-dev
```
