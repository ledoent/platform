# Huly Mobile App (Flutter) — Status & Continuation Plan

**Branch:** `feat/flutter-mobile-app`
**Fork PR:** https://github.com/ledoent/platform/pull/2
**Repo location:** `mobile/` directory in huly-platform monorepo
**Target:** Self-hosted Huly deployment (ledoweb.com)

---

## What's Done (11 commits on branch)

### Phase 1 — Auth + Issue Tracking
- [x] OTP, password, OAuth (Google/GitHub/OIDC) via `huly://` custom scheme
- [x] 2FA/TOTP verification (verify2fa RPC, TfaScreen, tfaPending state)
- [x] Issue list/detail/create/edit (TxUpdateDoc)
- [x] Status management (fetch, display, edit via dropdown)
- [x] Client-side search/filter on issue list
- [x] Auto-refresh (45s timer, lifecycle-aware)
- [x] Server-side `mobileRedirect` in authProviders

### Phase 2 — Polish + Navigation
- [x] Member/assignee name resolution (contact:class:Person)
- [x] Activity feed + comment posting on issue detail
- [x] File attachments (image_picker → blob upload → attachment doc)
- [x] Bottom nav bar (Issues / Chat / Settings)
- [x] Settings screen (server info, workspace, biometric toggle, sign out)

### Phase 3 — Chunter Chat
- [x] Channel + DirectMessage list with DM name resolution
- [x] Message thread with send, shared MessageBubble widget
- [x] 10s polling (lifecycle-aware)

### Phase 4 — Real-Time
- [x] WebSocket client (Huly protocol: hello handshake, ping/pong, Tx streaming)
- [x] dataVersionProvider — auto-refreshes providers on Tx events
- [x] Polling kept as fallback
- [x] FCM push notifications (register token as PushSubscription, foreground display)

### Phase 5 — Advanced
- [x] Biometric auth (Face ID / fingerprint, lock screen, settings toggle)

### Infrastructure
- [x] GitHub Actions CI (`.github/workflows/mobile.yml`)
  - Test on push/PR, build iOS+Android on tags/manual
  - Uses same secrets as `dnplkndll/immich` repo
- [x] App Store Connect: bundle ID `com.ledoweb.hulyMobile` registered
- [x] Capabilities enabled: Push Notifications, App Groups, Associated Domains

### Code Quality
- [x] Shared widgets extracted (MessageBubble, PriorityChip)
- [x] Shared utilities (escapeHtml, stripHtml, formatTimestamp)
- [x] No duplication across screens
- [x] `flutter build ios --no-codesign` passes
- [x] `flutter test` — 16/16 tests pass

---

## Blocked / In Progress

### TestFlight Upload (blocked)
- IPA built locally (21.8MB) at `mobile/build/ios/ipa/`
- Upload failed: app `com.ledoweb.hulyMobile` needs to be **created in App Store Connect**
- Bundle ID is registered, capabilities enabled
- **TODO:** Go to https://appstoreconnect.apple.com/apps → New App → iOS
  - Name: `Huly Mobile`
  - Bundle ID: `com.ledoweb.hulyMobile` (select from dropdown)
  - SKU: `com.ledoweb.hulyMobile`
  - Primary Language: English (U.S.)
- Then upload: `xcrun altool --upload-app --type ios --file mobile/build/ios/ipa/huly_mobile.ipa --apiKey H37UAAFAVA --apiIssuer 7f122bfe-f415-4590-9229-35a8e80a1826`

### CI Secrets (done)
All 5 secrets set on `ledoent/platform`:
- `APP_STORE_CONNECT_API_KEY_ID` — H37UAAFAVA
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID` — 7f122bfe-f415-4590-9229-35a8e80a1826
- `APP_STORE_CONNECT_API_KEY_P8` — from ~/.appstoreconnect/private_keys/
- `IOS_DISTRIBUTION_CERT_P12` — from ~/.apple-certs/immich_distribution.p12
- `IOS_DISTRIBUTION_CERT_PASSWORD` — empty string

---

## TODO — Remaining Work

### Immediate (unblock TestFlight)
- [ ] Create app in App Store Connect (manual — API key lacks CREATE permission)
- [ ] Upload IPA to TestFlight (command above, or `git tag mobile-v0.3.0` to trigger CI)
- [ ] Add custom Huly app icon (currently Flutter default placeholder)
- [ ] Add custom launch screen / splash (currently default)

### Android (untested)
- [ ] Test Android build on device or emulator
- [ ] Chrome Custom Tabs for OAuth (vs ASWebAuthenticationSession)
- [ ] Verify Android share intent works
- [ ] Verify Android Keystore via flutter_secure_storage
- [ ] Add google-services.json for FCM on Android

### Firebase Setup (for push notifications)
- [ ] Create Firebase project for Huly Mobile
- [ ] Add GoogleService-Info.plist to `mobile/ios/Runner/`
- [ ] Add google-services.json to `mobile/android/app/`
- [ ] Test push notification delivery end-to-end
- [ ] Verify FCM token registration as PushSubscription in workspace

### WebSocket Hardening
- [ ] Test WebSocket against live Huly instance
- [ ] Verify Tx events are received and providers refresh
- [ ] Test reconnection after network loss
- [ ] Add connection status indicator in UI (connected/disconnected)
- [ ] Consider adding snappy compression for bandwidth (optional)

### Chat Improvements
- [ ] Thread replies (tap message → reply in thread)
- [ ] Unread indicators on channel list (DocNotifyContext queries)
- [ ] Message reactions
- [ ] Rich markup rendering (`flutter_widget_from_html` for TipTap HTML)
- [ ] Typing indicators

### Issue Improvements
- [ ] Issue deletion
- [ ] Assignee picker (select from workspace members)
- [ ] Sub-tasks / related issues
- [ ] Due dates
- [ ] Labels/tags

### UX Polish
- [ ] Workspace switcher (currently requires logout/re-login)
- [ ] Notification badge on bottom nav for unread chat
- [ ] Dark/light theme toggle (currently dark only)
- [ ] Error states and empty states with illustrations
- [ ] Loading skeletons instead of spinners

### Future Modules
- [ ] Documents (read-only markdown rendering)
- [ ] Time tracking (log entries against issues)
- [ ] HR module (leave requests, PTO)
- [ ] Kanban board view for issues

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `mobile/lib/app.dart` | Router, bottom nav shell, realtime init |
| `mobile/lib/core/api/rest_client.dart` | REST API client (find-all, tx, blob) |
| `mobile/lib/core/api/websocket_client.dart` | WebSocket protocol implementation |
| `mobile/lib/core/api/realtime_provider.dart` | WebSocket + push + dataVersion providers |
| `mobile/lib/features/auth/auth_provider.dart` | Auth state machine, all login methods |
| `mobile/lib/features/issues/issue_provider.dart` | Issue, status, member, attachment providers |
| `mobile/lib/features/chat/chat_provider.dart` | Channel + message providers |
| `mobile/lib/services/push_notification_service.dart` | FCM init, foreground display, subscription |
| `mobile/pubspec.yaml` | Dependencies |
| `.github/workflows/mobile.yml` | CI: test, build iOS/Android, upload TestFlight |
| `.ideas/mobile-app-plan.md` | This file |

## Apple Developer Details

| Item | Value |
|------|-------|
| Bundle ID | `com.ledoweb.hulyMobile` |
| Team ID | `6ZJTLNKLQR` |
| ASC Key ID | `H37UAAFAVA` |
| ASC Issuer ID | `7f122bfe-f415-4590-9229-35a8e80a1826` |
| API Key | `~/.appstoreconnect/private_keys/AuthKey_H37UAAFAVA.p8` |
| Dist Cert | `~/.apple-certs/immich_distribution.p12` |
| ASC Bundle Internal ID | `9F22F9BGXB` |
| Capabilities | Push Notifications, App Groups, Associated Domains, In-App Purchase |
