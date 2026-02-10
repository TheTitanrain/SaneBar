# Session Handoff - Feb 9, 2026

## Release v1.0.18 (Production — LIVE)

**Version:** v1.0.18 (build 1018)
**Released:** Feb 5, 2026 7:32pm EST
**Git Tag:** `v1.0.18` on commit `c96ff59`

---

## v1.0.19 — In Progress (Not Released)

**Version:** 1.0.19 (build 1019) — set in `project.yml`

### What's in v1.0.19 so far

Everything from previous sessions (Reduce Transparency, script triggers, always-hidden fixes, shield pattern, icon moving fixes) PLUS:

### Always-Hidden Graduation (Feb 9, committed + pushed)

Always-hidden promoted from experimental to permanent first-class feature:
- Default changed to `true` in PersistenceService (backward-compat `decodeIfPresent` kept)
- All guards/conditionals removed across 9 files
- Settings toggle removed from ExperimentalSettingsView
- Dead code cleaned: `showResetConfirmation`, unused `menuBarManager` in AboutSettingsView, `hasExperimentalFeatures` dead block in ExperimentalSettingsView

### Documentation Updates (Feb 9, committed + pushed)

- **README.md**: Graduated always-hidden, added Second Menu Bar + Onboarding Wizard + Always-Hidden Zone sections, updated How It Works (three-zone architecture), updated comparison table, updated AppleScript docs, updated project structure
- **docs/index.html (website)**: Added 3 rows to comparison table (Always-Hidden Zone, Second Menu Bar, Onboarding Wizard), added 2 feature cards (non-clickable `<div>` pending screenshots)
- **DOCS_AUDIT_FINDINGS.md**: Full 14-perspective audit results

### Icon Moving — Current State (Feb 9, committed `8d12b46`)

**All move directions work.** Tested on Mac Mini. Committed and pushed to main.

**Architecture reference:** See `ARCHITECTURE.md` § "Icon Moving Pipeline" for the full technical reference.

### Icon Moving — Known Issues

1. **AH-to-Hidden verification too strict** — When AH and main separators are flush, verification reports failure but icon moves correctly.
2. **First drag sometimes fails** — Timing between showAll() and icons becoming draggable.
3. **Speed** — Moves take ~2-3 seconds with shield pattern.
4. **Wide icons (>100px like CoinTick)** — May need special grab points.
5. **MenuBarSearchView.swift is 1046 lines** — Over lint limit. Needs extraction.

---

## Cross-Repo Dox Fix & Name Cleanup (Feb 9, committed + pushed)

### Problem
Real name "Stephan Joseph" and username "stephanjoseph" appeared in public repos, websites, and private infra. Brand name is "Mr. Sane" (person) / "SaneApps" (org). GitHub/X handle is `MrSaneApps`.

### Changes Made (9 repos, all pushed)

| Repo | Commit | What Changed |
|------|--------|-------------|
| **SaneBar** | `2cf19fe`, `03cf217` | README (icon styles 6→5, removed Hide Main Icon, added Script Trigger), marketing dox fixes, `.saneprocess` signing identity genericized |
| **SaneClip** | `bc78cb3` | `docs/privacy.html`: "Stephan Joseph" → "Mr. Sane" |
| **SaneHosts** | `caa1c60` | `SECURITY.md`: "Stephan Joseph" → "Mr. Sane" |
| **SaneVideo** | `3d616de` | `SaneVideoApp.swift`: author comment → "Mr. Sane" |
| **SaneAI** | `7e84fa1` | `SECURITY.md`: email → `hi@saneapps.com`; `CONTRIBUTING.md`: GitHub URL → `sane-apps/SaneAI` |
| **SaneSync** | `6ea0561` | `project.pbxproj`: signing identity genericized |
| **SaneProcess** | `e633b24` | `LICENSE`: copyright → "Mr. Sane / SaneApps"; `DEVELOPER_SETUP.md`: signing identity genericized |
| **SaneUI** | `6e602f3` | `LICENSE`: copyright → "Mr. Sane / SaneApps" |
| **saneapps.com** | `b49278a` | `index.html` + `guides.html`: 6x `stephanjoseph` → `MrSaneApps` in sponsor/footer links |

### Local-Only Fixes (not git repos)

- `SaneProcess-templates/`: LICENSE, release.yml, setup_new_app.sh, DEVELOPMENT_ENVIRONMENT.md, SANEAPPS_RELEASE_PROCESS.md — all genericized
- `cloudflare-workers/README.md`: account email genericized
- `DISASTER_RECOVERY.md`: team name updated (gitignored, has credentials)

### Intentionally Left As-Is

- **fastlane/Appfile** — `stephanjoseph2007@gmail.com` is the actual Apple ID login (changing breaks auth)
- **sane-email-automation/wrangler.toml** — functional `OWNER_EMAIL` for Cloudflare email routing
- **`.claude/research_findings.jsonl`** — auto-generated logs with old GitHub API queries
- **`.wrangler/state/` binary blobs** — local R2 cache of old DMGs
- **spiritnword.com** — user's personal site, will deal with later

### Signing Identity

Apple cert is literally named `"Developer ID Application: Stephan Joseph (M78L6FXD48)"` — can't change the cert. All config files now use generic `"Developer ID Application"` which `codesign` resolves automatically to the only matching cert in keychain. Verified this works.

### Sponsor Links

All websites verified: `github.com/sponsors/MrSaneApps` — correct across saneapps.com, sanebar.com, saneclip.com, saneclick.com, sanehosts.com.

---

## README Accuracy Fixes (Feb 9, committed in `2cf19fe`)

- **Icon styles**: 6 → 5 built-in (removed "plus" — doesn't exist in `MenuBarIconStyle` enum)
- **Hide Main Icon**: Removed from README (deprecated — forced to `false` in `MenuBarManager.swift:617-621`)
- **Script Trigger**: Added to Automatic Triggers section (exists in `ScriptTriggerService.swift`, UI in `RulesSettingsView.swift`)
- **SaneClick GPL/MIT**: Already fixed (line 191 says GPL v3)

---

## Documentation State

- **README.md** — Updated Feb 9: Graduated always-hidden, documented second menu bar, onboarding, zone management, comparison table, icon styles corrected
- **docs/index.html** — Updated Feb 9: Comparison table + feature cards (screenshots needed)
- **ARCHITECTURE.md** — Updated Feb 9: "Icon Moving Pipeline" section
- **DOCS_AUDIT_FINDINGS.md** — Created Feb 9: Full 14-perspective audit (7.7/10 overall)
- **research.md** — Trimmed to ~105 lines. Icon moving graduated to ARCHITECTURE.md.

---

## GitHub Issues

| Issue | Status | Notes |
|-------|--------|-------|
| **#44** | RESOLVED | External contributor signing fix — all 5 repos patched, reply posted |
| **#42** | Open | Script triggers request — needs acknowledgment (SHOW DRAFT FIRST) |
| **#41** | Open | Secondary panel request — plan in research.md, no code yet |

---

## FOLLOW-UPS

### Screenshots Needed (User will do later)
- **Second Menu Bar** — New feature card on website needs screenshot for lightbox
- **Always-Hidden Zone** — New feature card on website needs screenshot for lightbox
- **Onboarding Wizard** — Consider adding feature card + screenshot
- Feature cards are currently `<div>` (non-clickable). Convert to `<a>` with lightbox once screenshots exist.

### From Docs Audit (DOCS_AUDIT_FINDINGS.md)
- **Security items**: AppleScript input sanitization (#11), auth for HideCommand (#12), plaintext sensitive settings (#13)
- **UX discoverability**: Dropdown panel has no visual cue for new users (#9), no feedback on failed icon moves (#10)
- **Design**: Dropdown panel spacing, keyboard nav, light mode contrast (#15-#18)
- **MenuBarSearchView extraction**: 1046 lines → split zone helpers + actions (#6)
- **Website**: Update sanebar.com to fully match current feature set (#5)

### Feature Documentation Gaps (from audit)
- **SaneVideo**: 17 undocumented features in README
- **SaneClip**: ~12 missing features (user working on this themselves)
- **SaneClick**: Custom categories undocumented

---

## CRITICAL RULES (Learned the Hard Way)

1. **MacBook Air = production only.** Never launch dev builds, never nuke defaults.
2. **Always show drafts** before posting GitHub comments or sending emails.
3. **Email via Worker only** — `email-api.saneapps.com/api/send-reply`, never Resend directly.
4. **Launch via `open`** — never `./SaneBar.app/Contents/MacOS/SaneBar`. Breaks TCC.
5. **300ms expand delay** — 500ms hits auto-rehide, separator reads off-screen.
6. **Read SKILL.md first** — don't fumble with headers/endpoints from memory.
7. **NEVER implement "fixes" from audits without verifying the bug exists in current code.**
8. **Read ARCHITECTURE.md § Icon Moving before touching move code.**
9. **showAll() is required for ALL moves, not just move-to-visible.**
10. **Brand: "Mr. Sane" (person), "SaneApps" (org), `MrSaneApps` (GitHub/X handle).** Never "Mr. SaneApps".
11. **Signing identity: use generic `"Developer ID Application"`** — codesign resolves automatically.
12. **Don't ask questions you can answer yourself** — use `gh api`, `grep`, etc.

---

## Mac Mini Test Environment

- **SSH:** `ssh mini` → `Stephans-Mac-mini.local` as `stephansmac`
- **Deploy pipeline:** `tar czf` on Air → `scp mini:/tmp/` → extract → `mv ~/Applications/` → `open`
- **Bundle ID:** `com.sanebar.dev` for dev builds
- **Logging:** `nohup log stream --predicate 'subsystem BEGINSWITH "com.sanebar"' --info --debug > /tmp/sanebar_stream.log 2>&1 &`
- **ALWAYS launch via `open`** — direct binary execution breaks TCC grants
- **NEVER run dev builds on MacBook Air** — production only on Air

---

## NEXT SESSION — Priorities

1. **Fix AH-to-Hidden verification** — false negative when separators are flush
2. **Speed optimization** — explore shorter delays, parallel operations
3. **MenuBarSearchView.swift extraction** — 1046 lines, over lint limit
4. **Security hardening** — AppleScript sanitization, auth for HideCommand
5. **CoinTick (wide icon) testing** — re-test on Mac Mini
6. **Screenshots** — needed for website feature cards
7. **GitHub Issue #42** — acknowledge script triggers request (SHOW DRAFT FIRST)
8. **SaneVideo README** — 17 undocumented features

---

## Ongoing Items

1. **SaneBar v1.0.19**: Always-hidden graduated, icon moving working, docs updated, README refreshed, dox cleaned
2. **Secondary Panel**: Plan complete in research.md, no code yet, user demand growing (#41, #42)
3. **GitHub Issue #42**: Script triggers request — needs acknowledgment (SHOW DRAFT FIRST)
4. **GitHub Issue #44**: RESOLVED — signing fix committed and pushed, reply posted
5. **HealsCodes video**: `~/Desktop/Screenshots/HealsCodes-always-hidden-move-bug.mp4` — unreviewed
6. **Cross-app signing fix**: All 5 repos fixed and pushed
7. **Cross-repo dox fix**: All 9 repos cleaned, pushed, verified
