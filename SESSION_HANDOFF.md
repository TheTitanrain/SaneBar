# Session Handoff - Jan 30, 2026

## Icon & Website Overhaul (Jan 30, evening)

### Icon Update
- Changed bar color from `#40CCED` to `#5CE8FF` (brighter teal) across ALL locations
- SVG source of truth: `/Users/sj/SaneApps/web/saneapps.com/icons/sanebar-icon.svg`
- Regenerated: all 10 AppIcon.appiconset PNGs, DMGIcon.icns, branding.png, sanebar-icon.png (saneapps.com)
- Rendering approach: SVG + sips (NOT Swift scripts — sips handles coordinates correctly, Swift NSBitmapImageRep has y=0 at bottom causing inversions)

### Website Fixes (ALL 4 SITES DEPLOYED)

**Round 1 — SEO/Social audit found 20+ issues, fixed all:**

| Site | Key Fixes |
|------|-----------|
| sanebar.com | OG/Twitter tags on all 5 guide pages, apple-touch-icon, theme-color, favicon cache bust |
| saneapps.com | Accent color `#5CE8FF`, fixed SaneClip/SaneHosts onclick URLs, SaneSync/SaneVideo button text |
| saneclip.com | Canonical/OG/Twitter on all 9 pages, expanded titles/descriptions, theme-color |
| saneclick.com | JSON-LD downloadUrl fix, twitter:site, expanded meta descriptions |

**Round 2 — Deep review found more issues, fixed all:**

| Site | Key Fixes |
|------|-----------|
| sanebar.com | Removed `border-radius: 8px` from `.logo img` (was creating visible squircle border), added `og:site_name`, fixed JSON-LD downloadUrl (was GitHub releases, now Lemon Squeezy), fixed sanebar-background.html color to `#5CE8FF` |
| saneapps.com | Fixed 6 hardcoded `rgba(95, 168, 211,...)` → `rgba(92, 232, 255,...)`, SaneSync/SaneVideo Coming Soon links → `#`, removed stray `</span>` |
| saneclip.com | Fixed broken `screenshot-pinned.png` → `screenshot-snippets.png`, macOS version mismatch (support said 15, now 14), canonical/og:url mismatches, apple-touch-icon on 8 pages |
| saneclick.com | Fixed JSON-LD downloadUrl to match actual checkout links, shortened how-to title (70→43 chars) |

### Known Remaining Issues (from audits, not fixed)

| Issue | Site | Priority |
|-------|------|----------|
| 4 guide pages have no footer | sanebar.com | Low |
| OG image may have baked squircle | sanebar.com | Medium |
| No hero app icon in hero section | sanebar.com | Low (design choice) |
| macOS naming inconsistency (Sequoia vs Tahoe) | sanebar.com | Low (both correct — minimum is Sequoia, optimized for Tahoe) |
| Social proof links are `href="#"` placeholders | saneapps.com | Low |
| Checkout URLs use sanebar.lemonsqueezy.com | saneclip.com, saneclick.com | N/A (all products under one Lemon Squeezy store) |
| Missing robots.txt, sitemap.xml | saneclick.com | Low |
| Unused screenshot images | saneclip.com | Low |

### Lessons Learned
- `sips` renders SVG to PNG correctly but ignores SVG filters (feGaussianBlur, etc.)
- NSBitmapImageRep y=0 is at BOTTOM (opposite of SVG where y=0 is top) — never use Swift scripts for icon rendering
- Browser favicon caching: use `?v=2` query parameter to bust cache
- `border-radius` on `.logo img` creates visible squircle — use `border-radius: 0` for full-square icons
- All SaneApps products are under one Lemon Squeezy store (`sanebar.lemonsqueezy.com`) — don't "fix" checkout URLs to per-app subdomains

---

## SaneClick FinderSync Extension Debugging (Jan 30, afternoon)

### Critical Finding: macOS 26 Tahoe ARM Bug (FB20947446)

FinderSync extension context menus **do not work on macOS 26 Tahoe + Apple Silicon (M2)**. This is a confirmed Apple bug. The extension loads, init() runs, directoryURLs are set, pluginkit shows `+` (enabled), but **Finder never calls `menu(for:)`**. No context menu items appear at all.

- **Apple Feedback:** FB20947446
- **Affects:** All Apple Silicon Macs on macOS 26.0-26.2 (confirmed through 26.3 Beta 3)
- **References:** Apple Developer Forums thread/806607, eclecticlight.co, iboysoft.com
- **Workaround:** NONE confirmed by Apple. Extension simply doesn't work on ARM + Tahoe.

### Next Steps for SaneClick

1. **File Apple Feedback** referencing FB20947446 with sysdiagnose from M2 Air
2. **Wait for macOS 26.3+ fix** or consider FileProviderUI as alternative
3. **Test on Intel Mac** if available to confirm ARM-specific nature
4. **Ship update anyway** - the code fixes are correct and will work once Apple fixes the OS bug
5. **Consider Services menu** as workaround (works independently of FinderSync)

---

## Cross-Project Release Script Audit (Jan 30)

### Summary
Audited ALL release scripts across all SaneApps for Sparkle signing bugs. Fixed critical issues in 5 scripts across 4 projects. All 4 DMGs verified with live EdDSA signing.

### The Rule (NEVER BREAK AGAIN)
- `sparkle:version` = BUILD_NUMBER (numeric CFBundleVersion, e.g., "1017")
- `sparkle:shortVersionString` = VERSION (semantic, e.g., "1.0.17")
- Use heredoc (`cat <<EOF`) not echo for appcast templates
- URL: `https://dist.{app}.com/updates/{App}-{version}.dmg`
- Always generate `.meta` file alongside DMG

---

## Release v1.0.17 (Production)

- **Version:** v1.0.17
- **Build:** Verified, Signed (EdDSA), Notarized
- **Distribution:** Hosted on **Cloudflare R2** (`dist.sanebar.com`)
- **Website:** Live with all SEO/icon fixes deployed

## Next Actions (v1.1)

1. **Keychain Migration:** Move `requireAuthToShowHiddenIcons` from JSON to System Keychain
2. **Ice Migration Tool:** Import settings from Ice
3. **Permanently Hidden Zone:** Secondary "Void" spacer
