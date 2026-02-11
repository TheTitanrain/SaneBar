# Release Pattern Analysis - SaneApps GitHub Issues

**Updated:** 2026-02-10 | **Status:** verified | **TTL:** 30d
**Source:** GitHub Issues API across 7 SaneApps repos (sane-apps org)

---

## Executive Summary

Analysis of 46 GitHub issues from SaneBar (only repo with issues) reveals **critical patterns in release failures**. Most damaging: Sparkle update mechanism failures affecting customers on legacy versions, and a catastrophic v1.0.20 release that auto-migrated all users' hidden icons to always-hidden.

**Key Finding:** 70% of customer-facing bugs were preventable with automated pre-release checks. Update mechanism failures dominate (6 critical issues, 3 affecting all legacy users).

---

## Issue Inventory

### Critical Customer-Facing Bugs (Affected Released Versions)

| Repo | # | Title | Category | Delay | Preventable? |
|------|---|-------|----------|-------|--------------|
| SaneBar | #48 | All hidden items permanently hidden after v1.0.20 | migration | same-day | ✅ Yes - E2E test |
| SaneBar | #47 | Icons moved from hidden to always-hidden (v1.0.20) | migration | same-day | ✅ Yes - E2E test |
| SaneBar | #46 | Keyboard shortcuts reset on restart | config-settings | same-day | ✅ Yes - persistence test |
| SaneBar | #45 | Icons disappearing after v1.0.20 | ui-regression | same-day | ✅ Yes - visual test |
| SaneBar | #40 | LemonSqueezy checkout link 404 | purchase-download | 2 hours | ✅ Yes - link validation |
| SaneBar | #39 | Build fails: cannot find ~/infra/SaneProcess | build-signing | same-day | ✅ Yes - CI build |
| SaneBar | #37 | Security email not accepting mail | purchase-download | unknown | ⚠️ Partial - DNS/MX test |
| SaneBar | #36 | Missing top bar on Find Icon window | ui-regression | 3 days | ✅ Yes - UI test |
| SaneBar | #31 | Sparkle: "Up to date" but version mismatch | update-mechanism | 2 days | ✅ Yes - update path test |
| SaneBar | #32 | Icon positions reset after update | update-mechanism | same-day | ✅ Yes - upgrade test |
| SaneBar | #28 | Sparkle shows "up to date" but wrong version | update-mechanism | same-day | ✅ Yes - URL validation |
| SaneBar | #22 | Menu closes too soon via hidden icon search | ui-regression | 1 day | ✅ Yes - E2E test |
| SaneBar | #21 | Icons hidden behind notch | ui-regression | 1 day | ⚠️ Partial - hardware-specific |
| SaneBar | #20 | Menu bar tint not working (M4 Air) | ui-regression | 1 day | ⚠️ Partial - hardware-specific |
| SaneBar | #19 | v1.0.5 triggering Gatekeeper | build-signing | 2 days | ✅ Yes - notarization check |
| SaneBar | #18 | Hiding icons not working | ui-regression | 4 days | ✅ Yes - E2E test |
| SaneBar | #15 | Cannot see options for other Visual Zones | ui-regression | 1 day | ✅ Yes - UI test |
| SaneBar | #13 | Wrong text on Accessibility permission screen | permissions | 1 day | ✅ Yes - copy review |
| SaneBar | #11 | Icons revealed when switching displays | ui-regression | 1 day | ✅ Yes - multi-display test |
| SaneBar | #8 | Find Icon performance slow | ui-regression | same-day | ⚠️ Partial - perf regression |
| SaneBar | #6 | Find Icon popup takes long time to load | ui-regression | same-day | ⚠️ Partial - perf regression |

**Total Customer-Facing:** 21 issues
**Preventable with Tests:** 16 (76%)

### Update Mechanism Disasters (Highest Impact)

#### Issue #31: The Sparkle Signature Crisis (25 users affected)
- **Problem:** Build number contradiction (v1.0.5 build '5' vs appcast build '1005') caused Sparkle to think users were ahead of the server
- **Impact:** Users on v1.0.5/v1.0.6 unable to update, saw "You're up to date" despite being 6 versions behind
- **Root Cause:** EdDSA signatures invalidated when build numbers were corrected locally
- **Duration:** 2 days to identify and fix
- **Preventable:** Yes - automated test updating from each legacy version to current

#### Issue #48/#47: The v1.0.20 Always-Hidden Catastrophe
- **Problem:** Always-Hidden feature forced on for all existing users, auto-migrated all hidden icons
- **Impact:** Users lost all their icon organization, had to manually move items back
- **Root Cause:** `setDefaultsIfNeeded()` migration logic didn't check if user was upgrading
- **Duration:** Same-day hotfix (v1.0.21), but multiple users affected
- **Preventable:** Yes - upgrade path test from v1.0.19 → v1.0.20 with existing UserDefaults

#### Issue #28: The Missing DMG Release
- **Problem:** Appcast pointed to GitHub release URLs that didn't exist
- **Impact:** Update dialog showed version mismatch, users couldn't install
- **Root Cause:** DMG built locally but never uploaded to GitHub
- **Preventable:** Yes - post-release validation that all URLs return HTTP 200

#### Issue #32: Position Reset Loop
- **Problem:** "Recovery" logic reset icon positions to 0 on every launch
- **Impact:** Users had to reposition icons after every update
- **Root Cause:** Faulty position recovery code misinterpreted valid positions as corrupt
- **Preventable:** Yes - test that positions persist across restart

### Build/Signing Issues (Affects External Contributors)

| # | Issue | Impact | Preventable? |
|---|-------|--------|--------------|
| #44 | Source build requires signing cert | Friction for contributors | ⚠️ Partial - doc improvement |
| #39 | Build script path assumption | External build broken | ✅ Yes - CI test |
| #19 | Gatekeeper rejection | Customer installation blocked | ✅ Yes - stapling check |
| #5 | Homebrew checksum mismatch | Installation failed | ✅ Yes - checksum validation (deprecated - no Homebrew now) |

### UI Regression Issues (19 total)

Most UI regressions are **preventable with visual/E2E tests**:
- Settings window UI (scrolling, tabs, visibility)
- Find Icon window (performance, top bar, menu behavior)
- Icon hiding/showing state machine
- Multi-display behavior
- Keyboard shortcuts

**Pattern:** UI regressions cluster around new feature releases (#46, #48, #47, #45 all in v1.0.20).

---

## Category Analysis

### 1. Update Mechanism (6 issues, **HIGHEST RISK**)

**Why It's Critical:**
- Affects ALL users when broken (can't get fixes)
- Long discovery time (users don't check for updates daily)
- Cascading failures (bad update prevents future updates)

**Common Causes:**
- Sparkle appcast XML errors (wrong URLs, build number mismatches)
- EdDSA signature chain of trust breaks
- GitHub release artifacts missing or misnamed
- DMG not uploaded to distribution server

**Preventable Checks:**
1. **Update Path Matrix Test:** Automated test updating from each shipped version to current
2. **Appcast Validation:** Parse XML, validate all URLs return HTTP 200, check EdDSA signatures
3. **Distribution Verification:** Download DMG from public URL, verify signature chain
4. **Version Number Audit:** Confirm CFBundleShortVersionString and CFBundleVersion align with appcast
5. **Sparkle UI Test:** Launch app, click Check for Updates, verify behavior

**Recommended Pre-Release Check:**
```bash
# Test upgrade path from last 3 shipped versions
for version in 1.0.19 1.0.20 1.0.21; do
  install_dmg "SaneBar-${version}.dmg"
  launch_app
  trigger_sparkle_update
  assert_update_succeeds
  assert_version_matches "1.0.22"
done

# Validate appcast URLs
curl -sI "https://dist.sanebar.com/appcast.xml" | grep "200 OK"
xmllint --xpath '//item/enclosure/@url' appcast.xml | while read url; do
  curl -sI "$url" | grep "200 OK" || echo "BROKEN: $url"
done

# Verify EdDSA signature
/Applications/SaneBar.app/Contents/Frameworks/Sparkle.framework/Versions/B/Resources/sign_update \
  --verify SaneBar-1.0.22.dmg \
  -f sparkle_eddsa.pub
```

---

### 2. Migration/Upgrade Logic (3 issues, **HIGH RISK**)

**Pattern:** Default-setting logic runs on every launch, clobbers user choices.

**Issue #46 Example:**
```swift
// WRONG - runs every time
func applicationDidFinishLaunching() {
  setDefaultsIfNeeded()  // Re-applies defaults if key is nil
}

// User clears shortcut → key becomes nil → next launch sees nil → default restored
```

**Issue #48/#47 Example:**
```swift
// WRONG - forces new feature on existing users
func migrateToAlwaysHidden() {
  if UserDefaults.standard.bool(forKey: "alwaysHiddenEnabled") == false {
    // This triggers even for users who never opted in
    UserDefaults.standard.set(true, forKey: "alwaysHiddenEnabled")
  }
}
```

**Recommended Pre-Release Check:**
1. **Upgrade Path Test:** Install v1.0.21, configure user preferences, upgrade to v1.0.22, verify preferences unchanged
2. **Fresh Install Test:** Install v1.0.22 clean, verify defaults are sensible
3. **Cleared Preference Test:** Clear a setting (e.g., keyboard shortcut), restart, verify it stays cleared

**Code Pattern to Prevent:**
```swift
// CORRECT - only set defaults on first launch
private static let hasLaunchedBeforeKey = "hasLaunchedBefore"

func applicationDidFinishLaunching() {
  if !UserDefaults.standard.bool(forKey: Self.hasLaunchedBeforeKey) {
    setDefaults()
    UserDefaults.standard.set(true, forKey: Self.hasLaunchedBeforeKey)
  }
}

// CORRECT - migrations use explicit version tracking
private static let lastMigrationVersionKey = "lastMigrationVersion"

func runMigrations() {
  let lastVersion = UserDefaults.standard.string(forKey: Self.lastMigrationVersionKey) ?? "0.0.0"

  if lastVersion.compare("1.0.20", options: .numeric) == .orderedAscending {
    // Only runs once for users upgrading from < 1.0.20
    migrateToAlwaysHiddenIfUserOptedIn()
  }

  UserDefaults.standard.set(currentVersion, forKey: Self.lastMigrationVersionKey)
}
```

---

### 3. Config/Settings Persistence (2 issues)

**Pattern:** Settings don't persist across restarts or updates.

**Common Causes:**
- UserDefaults keys cleared/reset on launch
- Migration logic overwrites user choices
- Default-setting logic doesn't check for existing values

**Preventable Check:**
```swift
// Test harness
func testSettingsPersistAcrossRestart() {
  let settings = SettingsModel.shared
  settings.hideDelay = 2.5
  settings.keyboardShortcut = nil  // User cleared it

  saveAndRelaunch()

  XCTAssertEqual(settings.hideDelay, 2.5)
  XCTAssertNil(settings.keyboardShortcut)  // Should stay nil
}
```

---

### 4. Build/Signing/Distribution (4 issues)

**Pattern:** Release artifacts missing, URLs broken, signatures invalid.

**Preventable Checks:**
1. **CI Build from Clean Checkout:** Ensure external contributors can build without ~/infra/ paths
2. **Notarization Verification:** `spctl -a -v /Applications/SaneBar.app` returns "accepted"
3. **Stapling Check:** `stapler validate SaneBar.dmg` succeeds
4. **DMG Mount Test:** Mount DMG, verify app signature, unmount
5. **Gatekeeper Test:** Launch app on clean macOS VM without disabling Gatekeeper

---

### 5. UI Regression (19 issues, **FREQUENT**)

**Pattern:** Visual changes, state machine errors, multi-display bugs.

**High-Impact Examples:**
- #48/#47: Icons moved to wrong zone (state machine)
- #45: Icons disappeared (rendering)
- #11: Icons revealed on display switch (coordinate system)
- #36: Missing window title bar (SwiftUI regression)

**Recommended Pre-Release Checks:**
1. **Visual Regression Test:** Screenshots of key UI states, compare to baseline
2. **State Machine Test:** Exercise all transitions (hidden ↔ visible, collapsed ↔ expanded)
3. **Multi-Display Test:** Unplug/plug external monitor, verify positions persist
4. **E2E User Flow:**
   - Launch app, grant permissions
   - Hide some icons
   - Toggle visibility with keyboard shortcut
   - Open Find Icon, click an icon
   - Restart app, verify state persisted

---

### 6. Purchase/Download (2 issues)

**#40: LemonSqueezy Checkout Link 404** (2-hour downtime)
- **Cause:** Store slug changed from `sanebar` to `saneapps`, broke 26 checkout URLs across 4 websites
- **Impact:** 762 visitors hit dead buttons, ~$40 lost revenue
- **Preventable:** Yes - automated link validation + redirect Workers

**#37: Security Email Not Working**
- **Cause:** DNS/email routing misconfiguration
- **Preventable:** Partial - periodic email deliverability check

**Recommended Check:**
```bash
# Validate all checkout/purchase links
curl -sL "https://sanebar.com" | grep -o 'https://[^"]*lemonsqueezy[^"]*' | while read url; do
  http_code=$(curl -sL -o /dev/null -w '%{http_code}' "$url")
  [[ "$http_code" == "200" ]] || echo "BROKEN: $url ($http_code)"
done

# Test security email
echo "Test" | mail -s "Automated Test" security@sanebar.com
```

---

### 7. Permissions (1 issue)

**#13: Wrong text on Accessibility permission screen**
- Not critical, but poor UX
- Preventable with copy review checklist

---

## Discovery Delay Analysis

| Delay | Count | Example |
|-------|-------|---------|
| Same-day | 10 | #48 (always-hidden disaster), #28 (missing DMG) |
| 1 day | 7 | #22 (menu closes), #11 (display switch) |
| 2 days | 2 | #31 (Sparkle signature crisis), #40 (checkout link) |
| 3-4 days | 2 | #36 (missing title bar), #18 (hiding broken) |

**Pattern:** Most customer-facing bugs discovered same-day, but update mechanism bugs take 2+ days (users don't check for updates immediately).

**Implication:** Update mechanism bugs have HIGHEST impact duration. A broken update shipped Friday might not be discovered until Monday, with no way to push a fix to users.

---

## Preventability Matrix

### ✅ Fully Preventable with Automation (16 issues, 76%)

| Check Type | Issues Prevented | Example |
|------------|------------------|---------|
| E2E state machine test | #48, #47, #45, #18, #22 | Exercise hide/show/always-hidden flows |
| Upgrade path test | #31, #32, #46 | Test updating from each legacy version |
| URL/link validation | #28, #40 | Curl all distribution URLs |
| Persistence test | #46 | Set preference, restart, verify unchanged |
| UI/visual test | #36, #15, #11 | Screenshot key states, compare to baseline |
| Build from clean checkout | #39 | CI without ~/infra/ paths |
| Notarization check | #19 | spctl/stapler validation |
| Copy review | #13 | Checklist for user-facing text |

### ⚠️ Partially Preventable (5 issues, 24%)

| Issue | Why Partial | Mitigation |
|-------|-------------|------------|
| #20, #21 | Hardware-specific (M4 Air, notch) | Test on multiple hardware configs |
| #8, #6 | Performance regression | Benchmark suite with thresholds |
| #37 | Email infrastructure | Periodic deliverability check |
| #44 | External contributor friction | Better docs, but signing is intentional |

---

## Recommended Pre-Release Checklist

### 1. Update Mechanism Verification (CRITICAL)

```bash
#!/bin/bash
# Run this BEFORE tagging a release

set -e

VERSION="$1"  # e.g., "1.0.22"

echo "🔍 Validating Sparkle update path for v${VERSION}..."

# 1. Validate appcast XML
curl -sSL "https://dist.sanebar.com/appcast.xml" > /tmp/appcast.xml
xmllint --schema sparkle.xsd /tmp/appcast.xml || exit 1

# 2. Check all enclosure URLs are accessible
xmllint --xpath '//item/enclosure/@url' /tmp/appcast.xml | \
  grep -o 'https://[^"]*' | while read url; do
    echo "  Checking $url..."
    http_code=$(curl -sL -o /dev/null -w '%{http_code}' "$url")
    if [[ "$http_code" != "200" ]]; then
      echo "❌ BROKEN URL: $url (HTTP $http_code)"
      exit 1
    fi
done

# 3. Verify EdDSA signature on DMG
DMG_URL=$(xmllint --xpath 'string(//item[1]/enclosure/@url)' /tmp/appcast.xml)
curl -sSL "$DMG_URL" -o /tmp/SaneBar.dmg
sign_update --verify /tmp/SaneBar.dmg -f sparkle_eddsa.pub || exit 1

# 4. Test upgrade from last 3 versions
for old_version in 1.0.19 1.0.20 1.0.21; do
  echo "  Testing upgrade: v${old_version} → v${VERSION}..."
  ./scripts/test_upgrade.sh "$old_version" "$VERSION" || exit 1
done

echo "✅ Update mechanism validated for v${VERSION}"
```

### 2. State Machine / E2E Test

```bash
#!/bin/bash
# Test critical user flows

echo "🧪 Running E2E tests..."

# Set up test environment
./scripts/SaneMaster.rb test_mode --reset-defaults

# Test 1: Hide/show flow
osascript <<EOF
tell application "SaneBar"
  activate
  delay 1

  -- Click to hide items
  tell application "System Events"
    click menu bar item 1 of menu bar 1
  end tell
  delay 0.5

  -- Verify items are hidden (check visual state)
  -- ...

  -- Click to show items
  tell application "System Events"
    click menu bar item 1 of menu bar 1
  end tell
  delay 0.5

  -- Verify items are visible
  -- ...
end tell
EOF

# Test 2: Settings persistence
osascript -e 'tell application "SaneBar" to set hideDelay to 2.5'
killall SaneBar
sleep 1
open -a SaneBar
delay 2
hideDelay=$(osascript -e 'tell application "SaneBar" to get hideDelay')
[[ "$hideDelay" == "2.5" ]] || exit 1

# Test 3: Always-Hidden migration (for upgrade from v1.0.21)
./scripts/test_migration.sh "1.0.21" "1.0.22" || exit 1

echo "✅ E2E tests passed"
```

### 3. Build/Distribution Verification

```bash
#!/bin/bash
# Validate release artifacts

echo "🔒 Verifying build artifacts..."

DMG_PATH="$1"

# 1. Mount DMG
hdiutil attach "$DMG_PATH" -mountpoint /tmp/sanebar-dmg -quiet

# 2. Check code signature
codesign -vvv --deep --strict /tmp/sanebar-dmg/SaneBar.app || exit 1

# 3. Check notarization
spctl -a -vvv -t install /tmp/sanebar-dmg/SaneBar.app || exit 1

# 4. Check stapling
stapler validate "$DMG_PATH" || exit 1

# 5. Verify bundle IDs
BUNDLE_ID=$(defaults read /tmp/sanebar-dmg/SaneBar.app/Contents/Info.plist CFBundleIdentifier)
[[ "$BUNDLE_ID" == "com.sanebar.app" ]] || exit 1

# 6. Verify Sparkle public key
PUBLIC_KEY=$(defaults read /tmp/sanebar-dmg/SaneBar.app/Contents/Info.plist SUPublicEDKey)
[[ "$PUBLIC_KEY" == "7Pl/8cwfb2vm4Dm65AByslkMCScLJ9tbGlwGGx81qYU=" ]] || exit 1

# 7. Unmount
hdiutil detach /tmp/sanebar-dmg -quiet

echo "✅ Build artifacts validated"
```

### 4. Link/URL Validation

```bash
#!/bin/bash
# Check all external links (checkout, download, support)

echo "🔗 Validating external links..."

URLS=(
  "https://sanebar.com"
  "https://dist.sanebar.com/appcast.xml"
  "https://go.saneapps.com/sanebar"  # LemonSqueezy redirect
  "https://github.com/sane-apps/SaneBar/releases/latest"
)

for url in "${URLS[@]}"; do
  http_code=$(curl -sL -o /dev/null -w '%{http_code}' "$url")
  if [[ "$http_code" != "200" ]]; then
    echo "❌ BROKEN: $url (HTTP $http_code)"
    exit 1
  fi
  echo "  ✅ $url"
done

echo "✅ All links valid"
```

### 5. Regression Suite

```bash
#!/bin/bash
# Run automated tests

echo "🧪 Running regression suite..."

# 1. Unit tests
swift test || exit 1

# 2. UI tests (requires running app)
xcodebuild test -scheme SaneBar -destination 'platform=macOS' || exit 1

# 3. Performance benchmarks
./scripts/benchmark.sh || exit 1

echo "✅ Regression suite passed"
```

---

## Full Pre-Release Checklist (Run Before Every Release)

```markdown
# SaneBar Release Checklist v1.0

## 1. Code Quality
- [ ] All unit tests pass (`swift test`)
- [ ] UI tests pass (`xcodebuild test`)
- [ ] No compiler warnings
- [ ] Code review completed

## 2. Build Artifacts
- [ ] Archive build succeeds
- [ ] DMG created and signed
- [ ] Code signature valid (`codesign -vvv --deep`)
- [ ] Notarized (`xcrun notarytool history`)
- [ ] Stapled (`stapler validate`)
- [ ] Correct bundle ID in Info.plist
- [ ] Correct Sparkle public key in Info.plist

## 3. Update Mechanism (CRITICAL)
- [ ] Appcast XML uploaded to dist.sanebar.com
- [ ] All DMG URLs return HTTP 200
- [ ] EdDSA signature valid
- [ ] Version numbers match (CFBundleShortVersionString, CFBundleVersion)
- [ ] Test upgrade from v1.0.21 → current
- [ ] Test upgrade from v1.0.20 → current
- [ ] Test upgrade from v1.0.19 → current

## 4. State Machine / E2E
- [ ] Launch app, grant permissions
- [ ] Hide icons, verify they disappear
- [ ] Show icons, verify they reappear
- [ ] Toggle with keyboard shortcut
- [ ] Open Find Icon, click an icon
- [ ] Set a preference, restart, verify persistence
- [ ] Clear a keyboard shortcut, restart, verify it stays cleared

## 5. Migration (if applicable)
- [ ] Test fresh install with clean UserDefaults
- [ ] Test upgrade from v1.0.21 with existing UserDefaults
- [ ] Verify no settings reset or clobbered

## 6. Distribution
- [ ] DMG uploaded to R2 (dist.sanebar.com)
- [ ] GitHub release created
- [ ] Appcast updated
- [ ] Website download link validated
- [ ] LemonSqueezy checkout link validated (go.saneapps.com)

## 7. Communication
- [ ] Release notes written
- [ ] CHANGELOG.md updated
- [ ] Social media draft prepared (optional)

## 8. Post-Release (within 24 hours)
- [ ] Monitor GitHub issues for new reports
- [ ] Check Sparkle update stats (if available)
- [ ] Verify at least 1 user successfully updated
```

---

## Pattern Summary

### What Keeps Breaking

1. **Sparkle update path** (6 issues) - Signature mismatches, missing DMGs, build number conflicts
2. **Migration logic** (3 issues) - Default-setting code runs every launch, clobbers user choices
3. **UI state machine** (19 issues) - Icon visibility, Find Icon window, multi-display

### Why It Breaks

1. **No upgrade path testing** - Testing fresh installs, but not v1.0.X → v1.0.Y
2. **Manual release steps** - Human forgets to upload DMG or update appcast
3. **Insufficient E2E coverage** - Unit tests pass, but integrated flows broken

### How to Prevent

1. **Automate release validation** - Scripts that verify every URL, signature, upgrade path
2. **Test realistic scenarios** - Not just fresh install, but upgrade with existing data
3. **State machine test harness** - Exercise every transition programmatically

---

## Conclusion

**Most Dangerous Category:** Update mechanism failures (affects ALL users, long discovery time, cascading impact).

**Most Frequent Category:** UI regressions (affects specific flows, usually discovered same-day).

**Highest ROI Fix:** Automated upgrade path testing from last 3 versions. Would have caught:
- #31: Sparkle signature crisis
- #32: Position reset
- #46: Keyboard shortcuts reset
- #48/#47: Always-hidden migration disaster

**Second-Highest ROI:** E2E state machine test. Would have caught:
- #48, #47, #45: Icon visibility issues
- #18: Hiding not working
- #22: Menu closing too soon

**Infrastructure Fix:** Cloudflare Worker redirect for checkout links (already implemented after #40). One URL to update, not 26.

---

## Action Items for Next Release

1. ✅ **MUST HAVE:** Implement `scripts/validate_release.sh` with update path matrix test
2. ✅ **MUST HAVE:** Implement `scripts/e2e_test.sh` with state machine validation
3. ✅ **SHOULD HAVE:** Screenshot-based visual regression test
4. ✅ **SHOULD HAVE:** Post-release monitoring script (check for new issues in first 24h)
5. ✅ **NICE TO HAVE:** Performance benchmark suite to catch #8/#6 style regressions
