# App CI Promotion

The application repository can promote a built image by dispatching this ops repo workflow.

## Required Token

Create a GitHub token with permission to dispatch workflows in this repo, then store it in the app repository as:

```text
OPS_REPO_DISPATCH_TOKEN
```

## Example App Workflow Step

```yaml
- name: Promote image to dev
  if: github.event_name == 'push'
  env:
    GH_TOKEN: ${{ secrets.OPS_REPO_DISPATCH_TOKEN }}
    IMAGE_TAG: sha-${{ github.sha }}
  run: |
    gh api repos/sruthishtechnologies/ssvd-ops-repo/dispatches \
      --method POST \
      --field event_type=promote-image \
      --raw-field client_payload="{\"environment\":\"dev\",\"image_tag\":\"${IMAGE_TAG}\"}"
```

The ops repo opens a pull request that updates:

```text
envs/<environment>/values.yaml
```

Argo CD deploys after the pull request is merged into `main`.
