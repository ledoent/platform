# Huly Mobile App (Flutter) — Implementation Plan

**Branch:** `feat/flutter-mobile-app` (commit `d7506949f`, rebased on develop)
**Target:** Self-hosted Huly deployment (ledoweb.com)
**Repo location:** `mobile/` directory in huly-platform monorepo

---

## Existing MVP (what's already built)

The Flutter app at `mobile/` is a working MVP with:

- **Auth:** OTP, password, OAuth (Google/GitHub/OIDC) via `flutter_web_auth_2`
  - Custom `huly://` URI scheme for OAuth redirect
  - Server-side `mobileRedirect` param in `pods/authProviders/src/utils.ts`
- **Issue tracking:** List by project, view details, create with priority
- **REST client:** `find-all` and `tx` endpoints on transactor API
- **Design system:** Dark theme from Huly SCSS, HulyButton, HulyChip, PriorityIcon
- **iOS share extension:** Capture text/URL → pre-populate issue creation
- **Architecture:** Riverpod state, go_router, freezed models, flutter_secure_storage

### What doesn't work yet
- 2FA (backend supports it, app shows error)
- No issue editing/deletion/filtering/search
- No Chunter (chat)
- No real-time (REST only, no WebSocket, no polling)
- No push notifications or offline support
- Android untested

---

## Strategic Decisions

| Question | Decision | Rationale |
|----------|----------|-----------|
| WebSocket vs REST? | Stay REST, add polling | Platform WebSocket needs snappy compression + custom handshake. Multi-week Dart effort for marginal gain on self-hosted. Add WebSocket in Phase 4 if chat demands it. |
| Offline support? | No | Conflict resolution complexity is disproportionate for a small self-hosted team. Simple Riverpod caching + offline banner is sufficient. |
| Push notifications? | Phase 4+ | Platform uses Web Push (VAPID), not FCM/APNs. Needs a bridge service or server-side changes. In-app polling is fine for now. |
| Monorepo or separate repo? | Stay in monorepo | Flutter build is independent (pubspec.yaml). Benefits: grep platform types, keep OAuth redirect logic in sync. |
| Chat priority? | Phase 3 (after issues are solid) | Complex data model (Channel, DM, ChatMessage, ThreadMessage, DocNotifyContext). Get issues right first. |

---

## Phase 1: Issue Lifecycle + 2FA (4-6 weeks)

Makes the app genuinely useful for daily work.

### 1a. 2FA / TOTP Support
- Add `verify2fa(token, code)` to `AccountClient` (RPC call)
- Add `AuthStatus.tfaPending` state
- New `TfaScreen` with 6-digit code input
- Route: `/tfa` in go_router

**Server reference:** `server/account/src/operations.ts` — `verify2fa` accepts partial token + `{ code }` object

### 1b. Issue Editing
- Add `buildUpdateIssueTx()` to `core/models/tx.dart` (TxUpdateDoc shape)
- Dual-mode `CreateIssueScreen` or new `EditIssueScreen`
- Edit button on `IssueDetailScreen`
- Fields: title, description, priority, status, assignee

### 1c. Issue Status Management
- Fetch `tracker:class:IssueStatus` docs per project
- Selectable status chip on create/edit screens
- Color-code by category (Backlog, Unstarted, Started, Done, Cancelled)

### 1d. Filtering and Search
- Search bar using `GET /api/v1/search-fulltext/:workspaceId?query=...&classes=tracker:class:Issue`
- Filter chips for priority and status
- Sort options (modified date, priority, created date)

### 1e. Pull-to-Refresh + Auto-Refresh
- `RefreshIndicator` on `IssueListScreen`
- 30-60s foreground polling via `Timer` + `AppLifecycleListener`

---

## Phase 2: Polish + Android (3-4 weeks)

### 2a. Android Support
- Test/fix Android build
- Chrome Custom Tabs for OAuth (vs ASWebAuthenticationSession)
- Verify share intent + Keystore

### 2b. Member/Assignee Resolution
- Fetch `contact:class:Person` docs, cache name + avatar
- Display in issue list and detail screens

### 2c. File Attachments
- Image/file picker on create/edit
- Upload via `PUT /api/v1/blob/:workspaceId`
- Create `attachment:class:Attachment` doc via tx
- Display thumbnails/links in detail view

### 2d. Activity Feed / Comments
- Query `activity:class:ActivityMessage` for `{ attachedTo: issueId }`
- Chronological feed below issue details
- Text input to post `chunter:class:ChatMessage` on the issue
- Strip HTML or use `flutter_widget_from_html`

### 2e. Navigation
- Bottom nav bar: Issues, (Chat placeholder), Settings
- Settings: server URL, logout, workspace switcher, app version

---

## Phase 3: Chunter (Chat) (6-8 weeks)

### 3a. Data Models
- `Channel`, `DirectMessage`, `ChatMessage`, `ThreadMessage`
- Reference: `plugins/chunter/src/index.ts`

### 3b. Channel/DM List
- Fetch channels + DMs where user is member
- Unread indicators via `DocNotifyContext`
- Sort by last activity

### 3c. Message Thread
- Render messages with sender, timestamp, content
- Markup: `flutter_widget_from_html` for TipTap HTML
- Send new messages via `TxCreateDoc`
- Thread replies

### 3d. Polling for Chat
- Poll current channel every 5-10s
- New message badges on channel list

---

## Phase 4: Real-Time + Notifications (optional, 4-6 weeks)

### 4a. WebSocket
- Dart snappy compression (find/write library)
- Handshake: `HelloRequest`/`HelloResponse`
- Ping/pong keep-alive (10s interval)
- Parse incoming Tx events → update Riverpod state

### 4b. Push Notifications
- **Recommended:** ntfy.sh bridge (subscribe Web Push → forward to ntfy → Flutter client)
- **Alternative:** Add FCM support to `pod-notification` (server-side changes)

---

## Phase 5: Advanced (pick and choose)

- Markdown editor (`fleather` or `super_editor`)
- Kanban board view
- Time tracking
- Documents (read-only markdown)
- Biometric auth (Face ID / fingerprint via `local_auth`)

---

## Key Server-Side References

| File | Purpose |
|------|---------|
| `pods/server/src/rpc.ts:221+` | All REST API endpoints (find-all, tx, search-fulltext, blob, ping) |
| `pods/authProviders/src/utils.ts` | OAuth redirect with `mobileRedirect` support |
| `server/account/src/operations.ts` | Account RPC methods (login, verify2fa, selectWorkspace) |
| `foundations/core/packages/account-client/src/client.ts` | AccountClient interface |
| `plugins/chunter/src/index.ts` | Chunter type definitions |
| `plugins/tracker/src/index.ts` | Tracker type definitions |
| `plugins/client-resources/src/connection.ts` | WebSocket protocol (for Phase 4) |

## Priority Matrix

| Feature | Effort | Impact | Phase |
|---------|--------|--------|-------|
| 2FA support | Low | High | 1 |
| Issue editing | Low | High | 1 |
| Status management | Medium | High | 1 |
| Search/filter | Medium | High | 1 |
| Auto-refresh | Low | Medium | 1 |
| Android support | Medium | Medium | 2 |
| Comments/activity | Medium | High | 2 |
| Member resolution | Low | Medium | 2 |
| File attachments | Medium | Medium | 2 |
| Chunter basics | High | High | 3 |
| WebSocket | High | Medium | 4 |
| Push notifications | High | Medium | 4 |
| Offline support | Very High | Low | Skip |
