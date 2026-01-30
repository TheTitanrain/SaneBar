# Session Handoff - Jan 29, 2026

## 🚀 Release v1.0.17 (Production)

### Status
- **Version:** v1.0.17
- **Build:** Verified, Signed (EdDSA), Notarized
- **Distribution:** Hosted on **Cloudflare R2** (`dist.sanebar.com`)
- **Website:** Live with updated "Provably Private" badges and Sustainability section

### 🛡️ Security Audit (Resolved)
- **Fixed:** AppleScript Auth Bypass (Added `MainActor.assumeIsolated` + checks)
- **Fixed:** Accessibility Service Force Casts (Audit finding resolved)
- **Fixed:** Auth Rate Limiting (30s lockout added)
- **Hardening:** Added `force_cast: error` to `.swiftlint.yml` to prevent future regressions.

### 📚 Documentation (Synced)
- **Resolved:** "Sticky Electron Icons" phantom limitation removed (Fix verified in v1.0.12).
- **Updated:** `CHANGELOG.md`, `BUG_TRACKING.md`, `ROADMAP.md` aligned with actual code capabilities.
- **Transparency:** Added `KNOWN_LIMITATIONS.md` entry for Keychain storage roadmap (v1.1).

### 🛠️ Tooling
- **Universal Script:** `scripts/release_fixed.sh` now uses `create-dmg` (like SaneClip/Hosts) for professional icon embedding.
- **GitHub Safety:** Neutralized accidental token leak (revoked from config, verified Keychain usage).
- **Environment:** Nuclear clean performed. Local state is pristine.

## ⏭️ Next Actions (v1.1)

1.  **Keychain Migration:** Move `requireAuthToShowHiddenIcons` from JSON to System Keychain (Defense in Depth).
    - *Note:* Documented in `KNOWN_LIMITATIONS.md`. Requires careful migration testing.
2.  **Ice Migration Tool:** Import settings from Ice (Roadmap item).
3.  **Permanently Hidden Zone:** Secondary "Void" spacer (Roadmap item).