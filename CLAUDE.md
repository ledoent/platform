# huly-platform — Claude Code Instructions

## Remotes
- `origin` = `https://github.com/hcengineering/platform.git` (upstream hcengineering)
- `fork` = `git@github.com:ledoent/platform.git` (ledoent fork, where we push features)

## Feature branch workflow

All feature work goes on branches named `feat/<feature-name>` and pushed to `fork`. The gitaggregate workflow on `ledoent/platform` merges them weekly into `fork/build/deploy`.

**When you add or update a feature branch:**
1. Push the branch to `fork`: `git push fork feat/<name>`
2. Add it to the merge list in `.github/workflows/gitaggregate.yml` on the `ledoent` branch (the `BRANCH in feat/...` loop in the "Build build/deploy" step).
3. (Optional) `gh workflow run gitaggregate.yml --repo ledoent/platform` to trigger an immediate aggregate + build instead of waiting for the Monday 6 AM UTC schedule.

## Custom build pipeline (fully automated)

Production at `huly.hz.ledoweb.com` runs a **custom build** that merges the upstream tag + ledoent feature branches into `build/deploy`, then builds + pushes 11 service images to the Hetzner Zot registry.

```
                  weekly (Mon 6 AM UTC) or `gh workflow run`
                                  │
                                  ▼
ledoent/platform: gitaggregate.yml          ◄── upstream tag read from
   • merges tag + feat/* + ledoent              ledoent/upstream-tag.txt
   • pushes build/deploy with PAT
                                  │
                                  ▼ (push event)
ledoent/platform: ledoent-build.yml
   • rush install / build / bundle / package
   • 11 docker buildx jobs → registry.hz.ledoweb.com/huly/*
   • image tag: v<upstream>-r<sha7>
                                  │
                                  ▼ (manual)
helm upgrade huly … (see below)
```

**Current feature branches on `build/deploy`:**
- `feat/api-token-management` — PR #10624: API token management
- `feat/multi-search-backend` — PR #10705: Typesense fulltext backend
- `ledoent` — workflows + build config

## Bumping the upstream tag

Edit `ledoent/upstream-tag.txt` on the `ledoent` branch, push, and trigger gitaggregate. The build workflow tags images with the version from `common/scripts/version.txt` (which upstream bumps with each release tag).

## Deploying a new build

After a green build run on `ledoent/platform`:

```bash
# Get the new image tag (any service)
TAG=$(gh run view <run-id> --log --repo ledoent/platform | grep -oE 'huly/account:v0\.7\.[0-9]+-r[a-f0-9]+' | head -1 | cut -d: -f2)

# Bump in values
sed -i '' "s/^hulyVersion: .*/hulyVersion: $TAG/" \
  ~/projects/ledoent/huly-selfhost/helm/huly/values-ledoweb.yaml \
  ~/projects/ledoent/infra/deployments/huly/values.secret.yaml

# Apply
cd ~/projects/ledoent/huly-selfhost
helm upgrade huly helm/huly/ -n huly --kube-context hetzner-ledo \
  -f helm/huly/values-ledoweb.yaml \
  -f ~/projects/ledoent/infra/deployments/huly/values.secret.yaml
```

## Required secrets

- `ZOT_CI_PASSWORD` (`ledoent/platform`): htpasswd entry for `github-ci` on registry.hz.ledoweb.com
- `BUILD_TRIGGER_PAT` (`ledoent/platform`): fine-grained PAT scoped to ledoent/platform with contents+actions read/write. Required so the gitaggregate push to `build/deploy` chain-triggers `ledoent-build.yml` (GITHUB_TOKEN pushes don't fire downstream workflows).

## Commit rules
- All commits must be signed off (DCO): `git commit -s`
- Always run `rushx fmt` in changed packages before pushing

## Infra repo
Deployment config lives at `~/projects/ledoent/infra/deployments/huly/`.
