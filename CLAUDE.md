# huly-platform — Claude Code Instructions

## Remotes
- `origin` = `https://github.com/hcengineering/platform.git` (upstream hcengineering)
- `fork` = `git@github.com:ledoent/platform.git` (ledoent fork, where we push features)

## Feature branch workflow

All feature work goes on branches named `feat/<feature-name>` and pushed to `fork`. These branches are tracked in the infra repo for deployment.

**When you add or update a feature branch:**
1. Push the branch to `fork`: `git push fork feat/<name>`
2. Update `~/projects/ledoent/infra/deployments/huly/repos.yaml` — add the branch to the `merges` list
3. Run `gitaggregate -c repos.yaml -p` from that directory to regenerate `fork/build/deploy`
4. Trigger a rebuild (see Build section below)

## Custom build pipeline

Production at `huly.hz.ledoweb.com` runs a **custom build** merging upstream + feature branches. Config: `infra/deployments/huly/repos.yaml`.

Current branches in the build:
- `fork feat/api-token-management` — PR #10624: API token management
- `fork feat/multi-search-backend` — PR #10705: Typesense fulltext backend

## Build commands (local → AMD64 images for k8s)

```bash
# 1. Checkout merged result
cd ~/projects/ledoent/huly-platform
git fetch fork && git checkout fork/build/deploy

# 2. CRITICAL: pin model version to match upstream tag
echo '"0.7.413"' > common/scripts/version.txt

# 3. Build
rush install && rush update && rush build && rush bundle

# 4. Build + push Docker images
TAG=v0.7.413-token-rN  # increment revision on each build
REGISTRY=europe-west3-docker.pkg.dev/kendall-ledo/docker/huly
# build each changed service pod, then push

# 5. Update hulyVersion in huly-selfhost/helm/huly/values-ledoweb.yaml
# then: helm upgrade huly helm/huly/ -n huly -f ...
```

Full documentation: Engineering teamspace in Huly → "Custom Build Management — repos.yaml & git-aggregator"

## Commit rules
- All commits must be signed off (DCO): `git commit -s`
- Always run `rushx fmt` in changed packages before pushing

## Infra repo
Deployment config lives at `~/projects/ledoent/infra/deployments/huly/`.
