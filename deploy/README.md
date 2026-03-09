# Huly K8s Deployment

Kustomize manifests to deploy [Huly](https://huly.io) v0.7.x to K3s.

## Architecture

```
                    ┌─────────────────────────────────────────────┐
                    │              nginx ingress                   │
                    │  /            → front:8080                  │
                    │  /_accounts   → account:3000                │
                    │  /_transactor → transactor:3333 (WS)        │
                    │  /_collaborator → collaborator:3078 (WS)    │
                    │  /_rekoni     → rekoni:4004                 │
                    │  /_stats      → stats:4900                  │
                    └────────────────────┬────────────────────────┘
                                         │
          ┌──────────┬──────────┬────────┴───────┬──────────┬──────────┐
          │          │          │                │          │          │
       front    account   transactor      collaborator  rekoni     stats
          │          │          │                │
          │          └────┬─────┘                │
          │               │                     │
          │    ┌──────────┴──────────┐          │
          │    │                     │          │
          │  cockroach          redpanda        │
          │    │                     │          │
          │    ├── workspace         │          │
          │    ├── fulltext ─────────┤          │
          │    │       │             │          │
          │    │  elasticsearch      │          │
          │    │                     │          │
          └────┴─────── minio ──────┴──────────┘
```

> **Note:** Elasticsearch 7.14.2 is used instead of OpenSearch because Huly's
> fulltext service bundles `elasticsearch-js` which rejects non-Elasticsearch
> backends. The K8s resources are still named `opensearch` for historical reasons.

## Directory layout

```
deploy/
  base/
    config/         # ConfigMap with URLs and app settings
    infra/          # CockroachDB, Redpanda, Elasticsearch, MinIO
    app/            # 8 Huly services
    ingress/        # 6 nginx Ingress resources (path-based routing)
  overlays/
    eval/           # Namespace + image tag pinning
```

## Prerequisites

- K3s cluster with nginx-ingress and cert-manager
- `kubectl` context configured (e.g., `hetzner-ledo`)
- DNS A record pointing to the ingress LB IP
- Google OAuth credentials (for login)

## Deploy

```bash
# 1. Create namespace
kubectl create namespace huly

# 2. Create secret (generate passwords fresh)
CR_PASS=$(openssl rand -hex 16)
SERVER_SECRET=$(openssl rand -hex 32)
RP_PASS=$(openssl rand -hex 16)

kubectl -n huly create secret generic huly-secret \
  --from-literal=SERVER_SECRET="$SERVER_SECRET" \
  --from-literal=STORAGE_CONFIG='minio|minio?accessKey=minioadmin&secretKey=minioadmin' \
  --from-literal=COCKROACH_PASSWORD="$CR_PASS" \
  --from-literal=REDPANDA_SUPERUSER_PASSWORD="$RP_PASS" \
  --from-literal=CR_DB_URL="postgres://root@cockroach:26257/defaultdb?sslmode=disable" \
  --from-literal=GOOGLE_CLIENT_ID="<your-google-client-id>" \
  --from-literal=GOOGLE_CLIENT_SECRET="<your-google-client-secret>"

# 3. Apply manifests
kubectl apply -k deploy/overlays/eval/

# 4. Watch pods
kubectl -n huly get pods -w
```

## Authentication

### Google OAuth setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create OAuth 2.0 Client ID (Web application)
3. Add authorized redirect URI: `https://huly.hz.ledoweb.com/_accounts/auth/google/callback`
4. Set `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in the `huly-secret`

### Admin bootstrap

The first user to sign up creates their workspace and becomes the workspace Owner.
To grant system-wide admin privileges, set the `ADMIN_EMAILS` env var on the
account deployment (comma-separated list). Emails matching this list get an
`admin: true` flag in their JWT.

### Restricting sign-ups

After creating admin accounts, set `DISABLE_SIGNUP=true` on the account and
front deployments. New users can then only join via workspace invites.

## Upgrade version

Edit `deploy/overlays/eval/kustomization.yaml` — change all `newTag` values, then:

```bash
kubectl apply -k deploy/overlays/eval/
```

## Verify

```bash
# All 12 pods Running
kubectl -n huly get pods

# Front responds
curl -I https://huly.hz.ledoweb.com/

# Account responds (405 = healthy, POST-only API)
curl -I https://huly.hz.ledoweb.com/_accounts

# CockroachDB admin UI
kubectl -n huly port-forward svc/cockroach 8080:8080
# → http://localhost:8080
```

## Troubleshooting

| Symptom | Check |
|---------|-------|
| Pod stuck in `Init` | Infra not ready — check `kubectl -n huly logs <pod> -c wait-cockroach` |
| Account CrashLoop | DB auth — check `kubectl -n huly logs deploy/account` for connection errors |
| Front CrashLoop | Missing env vars — check logs for `please provide <var>` |
| Redpanda won't start | Memory — needs ≥1Gi limit. Check `kubectl -n huly logs deploy/redpanda` |
| Elasticsearch permission denied | fsGroup — pod spec needs `securityContext.fsGroup: 1000` |
| Fulltext `ProductNotSupportedError` | Must use ES 7.14.2, not OpenSearch — Huly's `elasticsearch-js` rejects it |
| WebSocket 502 | Ingress timeout — verify `proxy-read-timeout: "3600"` annotation |

## Services

| Service | Port | Protocol | Needs DB | Needs Redpanda |
|---------|------|----------|----------|----------------|
| front | 8080 | HTTP | - | - |
| account | 3000 | HTTP | yes | yes |
| transactor | 3333 | WebSocket | yes | yes |
| collaborator | 3078 | WebSocket | - | - |
| workspace | - | background | yes | yes |
| fulltext | 4700 | HTTP | yes | yes |
| rekoni | 4004 | HTTP | - | - |
| stats | 4900 | HTTP | - | - |

## Teardown

```bash
kubectl delete -k deploy/overlays/eval/
kubectl -n huly delete secret huly-secret
kubectl delete namespace huly
# PVCs are retained — delete manually if needed:
kubectl -n huly delete pvc --all
```
