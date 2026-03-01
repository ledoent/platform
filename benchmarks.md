# Huly Monorepo Performance Benchmarks

This file tracks the performance improvements from migrating to Rspack and Turborepo.

## 1. Rspack Migration (Build & Dev)

Benchmarked on `@hcengineering/prod` (main application bundle).

| Metric | Webpack (Rush) | Rspack (Rush) | Speedup |
|--------|----------------|---------------|---------|
| cold build | ~45s | ~12.5s | **3.6x** |
| dev-server start | ~23s | ~16s | **1.4x** |
| HMR (svelte change) | ~16.2s | **~0.8s** | **20x** |

## 2. Turborepo Migration (Orchestration)

Benchmarked on `@hcengineering/prod` dependency tree (279 tasks).

| Mode | Rush | Turborepo | Speedup |
|------|------|-----------|---------|
| Cold Build | ~1m 20s* | ~1m 30s | ~0.9x |
| **Warm Build** | **~20.3s** | **~1.8s** | **~11x** |

*\*Note: Rush cold build time is unstable and can spike 8x higher after `rush update --recheck` due to inode invalidation. Turborepo provides a stable baseline by using a standard pnpm workspace.*

## 3. Full Monorepo Build (480+ projects)

This measures the time to check the entire dependency tree when no changes are made.

| Mode | Rush | Turborepo | Speedup |
|------|------|-----------|---------|
| Warm Build | **~5.7s** | **~2.2s** | **2.6x** |
| **Warm Validate** | **~6.1s** | **~2.0s** | **3.0x** |

> [!NOTE]
> All test packages (`qms-tests`, `tests-sanity`, etc.) have been fixed and now build correctly within the Turborepo pipeline.

---
---
## Monorepo Command Guide

| Task | Rush Command | **New Command** |
|------|--------------|-----------------|
| **Install** | `rush update` | `npm run install-all` |
| **Build (All)** | `rush build` | `npm run build` |
| **Validate** | `rush validate` | `npm run validate` |
| **Test** | `rush test` | `npm run test` |
| **Format** | `rush format` | `npm run format` |
| **Lint** | `rush lint` | `npm run lint` |
| **Docker Build** | `rush docker` | `npm run docker:build` |
| **Docker Up** | `rush docker:up` | `npm run docker:up` |
| **Specific Build** | `rush build --to <pkg>` | `npx turbo build --filter=<pkg>` |
| **Clean Cache** | `rush build --clean` | `npx turbo clean` |

> [!TIP]
> Use `npm run dev` to start the local development server for the main application.

---
*Last Updated: 2026-03-01*
