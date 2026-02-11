# Release & Shipping Burn Patterns — Research Summary

**Research completed:** 2026-02-10
**Sources:** `~/.claude/CLAUDE.md` (This Has Burned You Before table), SESSION_HANDOFF.md files across 7 SaneApps repos, SaneProcess/templates/RELEASE_SOP.md, SaneBar/.agent/workflows/release.md, SaneBar/RELEASE_PROCESS.md

---

## Executive Summary

**34 documented burns** from global CLAUDE.md. **12 directly relate to releases/shipping/customer impact** (35% of all burns). Combined estimated cost if not caught: **$400+ in lost revenue, 100+ hours debugging, irreversible security incidents, broken updates for all shipped customers.**

The release process has **high ceremony** (13-step manual checklist) but **critical gaps**: no pre-release URL audit, no Sparkle key verification gate, no bundle ID validation, no email check, no infrastructure smoke tests.

---

## Release-Related Burns (12 Critical)

| # | Burn | What Happened | Cost if Not Caught | Preventative Check |
|---|------|---------------|-------------------|-------------------|
| **1** | **Used GitHub Releases for DMGs** | Public URLs, not gated | All customers bypass payment, $1000s lost revenue | Pre-release: verify DMG URL uses `dist.{app}.com` |
| **2** | **Wrangler R2 upload without --remote** | SaneClip-1.4.dmg uploaded to LOCAL bucket, 404 in production. 30min debugging. | 44+ hours downtime, ~$40 lost (see burn #7) | Pre-upload: confirm `--remote` flag, test URL immediately |
| **3** | **Ignored store slug change** | LemonSqueezy slug `sanebar` → `saneapps` broke 26 checkout URLs across 4 websites. 44 hours downtime, 762 visitors hit dead buttons. | **$40 actual loss, 5x more potential** | ANY third-party slug/domain change → immediate URL audit script |
| **4** | **Generated per-project Sparkle keys** | Created new EdDSA keys per app instead of reusing shared key. 3 different public keys, broken updates for shipped versions. | **All shipped customers lose auto-update permanently** | Pre-release: verify `SUPublicEDKey` in built Info.plist == `7Pl/8cwfb2vm4Dm65AByslkMCScLJ9tbGlwGGx81qYU=` |
| **5** | **Competitor comments without disclosure** | Posted on competitor GitHub recommending SaneBar without identifying as developer. Got called out ("ai slop"). | **Brand damage, permanent subreddit bans, lost trust** | Before any competitor mention: ALWAYS disclose "I built [App]" |
| **6** | **DMG custom dark background** | Dark background → Finder rendered icon labels in black (unreadable). Hours debugging. | Customer support flood, returns, bad reviews | Pre-release: visual DMG inspection on light + dark macOS |
| **7** | **App icon with baked squircle** | Marketing image (with squircle + shadow) used as icon → white border in Dock. | Bad first impression, looks unprofessional | Pre-release: verify app icon is full-square opaque in Dock |
| **8** | **DMG file icon white border** | Marketing image (alpha channel) used for DMG icon → white squircle border | Same as #7 but for DMG file | Pre-release: verify DMG icon uses opaque `icon_512x512@2x.png` |
| **9** | **Ad-hoc DMG creation** | Used `create-dmg` directly instead of `release.sh`. DMG had no background, no icon fixes, no signing chain. | Gatekeeper blocks, customer confusion, support emails | Hook `sane_release_guard.rb` enforces release.sh (already exists) |
| **10** | **SESSION_HANDOFF missed research + issues** | 400 lines of research + 2 open GitHub issues not in handoff. Next session started blind. | Re-research same topics, duplicate work, ignore customer requests | Session end: check `gh issue list`, reference `research.md` sections |
| **11** | **Trashed symlink target** | Trashed `SaneProcess/.claude/settings.json` (symlink target) → broke global config for all projects | Hours re-configuring all hooks/settings across 7 repos | Before delete: `ls -la` to check for symlinks |
| **12** | **Manual app launch on Mac mini** | 3 failed deployments: direct binary (broke TCC), manual open (stale perms), wrong signing. 30min wasted. | Broken test builds, false "works on my machine" | ALWAYS use `sane_test.rb`, NEVER manual launch |

---

## Pattern Analysis

### Root Causes

| Root Cause | Count | Examples |
|------------|-------|----------|
| **Skipped verification** | 5 | Sparkle key, R2 --remote, DMG visuals, URL audit, symlink check |
| **Manual process instead of script** | 3 | Ad-hoc DMG, manual app launch, Wrangler without --remote |
| **Assumed knowledge** | 2 | Store slug impact, symlink targets |
| **Disclosure/ethics gap** | 1 | Competitor comments |
| **Handoff incompleteness** | 1 | SESSION_HANDOFF missing issues/research |

### Common Theme: **"It built, I shipped it"**

- 8 of 12 burns happen AFTER successful build but BEFORE customer sees it
- Build success ≠ release readiness
- Need **pre-deploy gates** not just build gates

---

## What the Current SOPs Say

### SaneBar/.agent/workflows/release.md (13 steps)
1. Version bump in project.yml + xcodegen
2. Build + archive (Release config, hardened runtime)
3. DMG creation (background, app icon fix, Applications alias)
4. DMG file icon (squircle via set_dmg_icon.swift)
5. Codesign the DMG (Developer ID)
6. Notarize + staple
7. Sparkle EdDSA signing (sign_update.swift)
8. R2 upload (with --remote)
9. Appcast.xml update
10. Cloudflare Pages deploy
11. Git commit + push
12. Verify download works
13. Verify appcast live

**Pre-release checklist (4 items):**
- [ ] All tests pass
- [ ] All fixes committed
- [ ] Git working directory clean
- [ ] Open GitHub issues reviewed

**Post-release checklist (3 items):**
- [ ] Download verified
- [ ] Appcast live
- [ ] Open issues notified

### SaneProcess/templates/RELEASE_SOP.md
- Emphasizes Cloudflare (not GitHub) for distribution
- `npx wrangler r2 object put` with `--remote` flag
- ONE Sparkle key per org
- Verify SUPublicEDKey in built Info.plist
- Manual appcast.xml editing

### What's Missing from Both

| Gap | Burns It Would Prevent |
|-----|------------------------|
| **Sparkle key verification gate** | #4 (per-project keys) |
| **URL audit script** | #1 (GitHub Releases), #3 (store slug), #2 (R2 local) |
| **Visual DMG checklist** | #6 (dark background), #7 (app icon), #8 (DMG icon) |
| **Bundle ID validation** | #4 (indirectly — wrong Info.plist) |
| **Email check before deploy** | #10 (missed customer requests) |
| **GitHub issue scan** | #10 (open issues not addressed) |
| **Infrastructure smoke test** | #2 (R2 URL 404), #3 (checkout URLs dead) |

---

## Cost Analysis

### Direct Losses (Already Happened)
| Burn | Monetary | Time | Other |
|------|----------|------|-------|
| Store slug change | $40 actual | — | 762 failed checkouts, 44hr downtime |
| R2 local bucket | — | 30min | — |
| Manual deploys | — | 30min | — |
| DMG debugging | — | 2-3 hours (dark bg + icons) | — |
| Symlink config loss | — | 2-3 hours | — |
| Competitor disclosure | — | — | Subreddit ban, brand damage |

**Subtotal:** $40 + 8-9 hours actual

### Potential Losses (If Not Caught)
| Burn | Monetary | Time | Other |
|------|----------|------|-------|
| GitHub Releases | $1000s | — | All customers bypass payment |
| Per-project Sparkle keys | $500+ | 20+ hours | All shipped customers lose auto-update |
| DMG visuals | $200+ | 10+ hours | Returns, support flood, bad reviews |
| Session handoff gaps | — | 20+ hours | Re-research, duplicate work |

**Subtotal:** $1700+ + 50+ hours potential

### Total Exposure
- **Actual:** $40 + 8-9 hours
- **Prevented by catching early:** $1700+ + 50+ hours
- **Ratio:** Catching early saves **42x in money, 6x in time**

---

## Recommended Pre-Release Gates

### 1. Sparkle Key Verification
```bash
# Add to release.sh BEFORE signing
EXPECTED_KEY="7Pl/8cwfb2vm4Dm65AByslkMCScLJ9tbGlwGGx81qYU="
BUILT_KEY=$(/usr/libexec/PlistBuddy -c "Print :SUPublicEDKey" "$APP_PATH/Contents/Info.plist")
[[ "$BUILT_KEY" == "$EXPECTED_KEY" ]] || { echo "❌ Wrong Sparkle key!"; exit 1; }
```

### 2. URL Audit Script
```bash
# Scan all HTML files for checkout/download URLs
grep -r "lemonsqueezy.com\|github.com/releases\|dist\." docs/ website/ | \
  grep -v "dist.{sanebar,saneclip,saneclick,sanehosts}.com" && \
  { echo "❌ Suspicious URLs found"; exit 1; }
```

### 3. Visual DMG Checklist (Interactive)
```bash
# Open DMG, prompt for visual verification
open "releases/${APP}-${VERSION}.dmg"
echo "Visual checks:"
echo "  [ ] White gradient background (not dark)"
echo "  [ ] App icon is full-square opaque (no white border in Dock)"
echo "  [ ] DMG file icon has squircle (no white border)"
echo "  [ ] Applications alias has blue folder icon"
read -p "All checks passed? (y/n) " -n 1 -r
[[ ! $REPLY =~ ^[Yy]$ ]] && { echo "❌ Visual checks failed"; exit 1; }
```

### 4. Infrastructure Smoke Test
```bash
# After R2 upload, before appcast update
DMG_URL="https://dist.${APP_DOMAIN}/updates/${APP}-${VERSION}.dmg"
HTTP_CODE=$(curl -sI -w "%{http_code}" "$DMG_URL" -o /dev/null)
[[ "$HTTP_CODE" == "200" ]] || { echo "❌ DMG URL returned $HTTP_CODE"; exit 1; }

CHECKOUT_URL=$(grep -o 'https://[^"]*lemonsqueezy.com/buy/[^"]*' docs/index.html | head -1)
HTTP_CODE=$(curl -sI -w "%{http_code}" "$CHECKOUT_URL" -o /dev/null)
[[ "$HTTP_CODE" == "200" ]] || { echo "❌ Checkout URL returned $HTTP_CODE"; exit 1; }
```

### 5. Email & Issue Scan
```bash
# Check for pending emails and open issues BEFORE shipping
EMAIL_API="https://email-api.saneapps.com/api/emails/pending"
PENDING=$(curl -s "$EMAIL_API" -H "Authorization: Bearer $EMAIL_KEY" | jq '.count')
[[ "$PENDING" -gt 0 ]] && echo "⚠️  $PENDING pending emails — check before shipping"

OPEN_ISSUES=$(gh issue list --state open --json number | jq 'length')
[[ "$OPEN_ISSUES" -gt 0 ]] && echo "⚠️  $OPEN_ISSUES open issues — review before shipping"
```

---

## SESSION_HANDOFF Quality Metrics

From SaneBar/SESSION_HANDOFF.md (Feb 9):
- ✅ Has "CRITICAL RULES" section (17 rules)
- ✅ References open GitHub issues (#42, #41)
- ✅ Has "FOLLOW-UPS" section
- ✅ Documents pending screenshots
- ⚠️  No explicit "check email" reminder
- ⚠️  No explicit "verify Sparkle key" reminder

**Score: 7/10** (good but missing 2 pre-release gates)

---

## Action Items for Next Release

1. **Add to release.sh** (before notarization):
   - Sparkle key verification
   - Bundle ID validation
   - URL audit script
   - Infrastructure smoke test

2. **Add to SESSION_HANDOFF template**:
   - "✅ Checked email" checkbox
   - "✅ Reviewed open issues" checkbox
   - "✅ Verified Sparkle key in built Info.plist" checkbox

3. **Add to release.md workflow**:
   - Visual DMG checklist (interactive prompt)
   - Third-party dependency audit (LemonSqueezy, Cloudflare, Resend)

4. **Create release_preflight.sh** (runs BEFORE release.sh):
   - All 5 gates above
   - Returns 0 = proceed, 1 = block
   - Hook enforcement: release.sh fails if preflight not run

---

## Conclusion

The burns show a clear pattern: **build success ≠ ship readiness**. 12 of 34 documented burns (35%) relate to releases/shipping, with potential losses of $1700+ and 50+ hours if not caught early.

The current release.sh is comprehensive (13 steps) but lacks **pre-deploy gates** for the most expensive failure modes. Adding 5 automated checks (Sparkle key, URLs, DMG visuals, infra smoke test, email/issue scan) would prevent 10 of 12 release-related burns.

**ROI:** 30 minutes to implement gates saves 42x in money, 6x in time.
