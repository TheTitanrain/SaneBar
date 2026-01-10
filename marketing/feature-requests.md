# SaneBar Feature Requests

> Tracking user-requested features from Reddit, GitHub, and support channels.
> Priority based on: frequency of requests, alignment with vision, implementation effort.

---

## High Demand Features

### 1. Menu Bar Spacing Control
**Priority: HIGH** | **Requests: 2+** | **Status: Not Started**

| Requester | Request | Notes |
|-----------|---------|-------|
| u/MaxGaav | "spacing possibilities?" | Top 1% commenter badge |
| u/Mstormer (MOD) | "compact spacing is the main reason I need a menubar manager" | r/macapps moderator |

**Analysis:**
- This is a core feature for power users
- Sindre Sorhus has a separate app "Menu Bar Spacing" for this
- Users want "all things in one app" (per MaxGaav)
- Could differentiate SaneBar from Ice/HiddenBar

**Implementation Notes:**
- Would require injecting spacing between AXUIElements
- May need to use different technique than current approach
- Reference: https://sindresorhus.com/menu-bar-spacing

---

### 2. Find Icon Speed Improvement
**Priority: HIGH** | **Requests: 1** | **Status: Needs Investigation**

| Requester | Request | Notes |
|-----------|---------|-------|
| u/Elegant_Mobile4311 | "Find Icon function is slow to respond... this feature needs to be polished" | Primary use case for them |

**Analysis:**
- User explicitly stated this is their "main purpose" for using the app
- Slow response time impacts core value proposition
- Need to profile and optimize the search/activation flow

**Investigation Needed:**
- [ ] Profile Find Icon activation latency
- [ ] Identify bottleneck (search? animation? click simulation?)
- [ ] Consider caching app list on launch

---

### 3. Find Icon in Right-Click Menu
**Priority: MEDIUM** | **Requests: 1** | **Status: Not Started**

| Requester | Request | Notes |
|-----------|---------|-------|
| u/a_tsygankov | "It would be great if it was available in the menu that appears when you right-click" | Also gave testimonial |

**Analysis:**
- Currently only available via Option-click or hotkey
- Right-click menu is discoverable without documentation
- Low effort, high usability improvement

**Implementation:**
- Add "Find Icon..." item to existing right-click context menu
- Should be straightforward

---

### 4. Custom Dividers
**Priority: MEDIUM** | **Requests: 1** | **Status: Not Started**

| Requester | Request | Notes |
|-----------|---------|-------|
| u/MaxGaav | "other dividers like vertical lines, dots and spaces?" | Top 1% commenter badge |

**Analysis:**
- Allows visual organization of menu bar
- Bartender has this feature
- Could be implemented as special "spacer" items

---

### 5. Secondary Menu Bar Row
**Priority: LOW** | **Requests: 1** | **Status: Not Planned**

| Requester | Request | Notes |
|-----------|---------|-------|
| u/MaxGaav | "a 2nd menubar below the menubar for hidden icons" | Alternative to full-width expansion |

**Analysis:**
- Significant UI/architecture change
- Not aligned with current "clean menu bar" vision
- Would require substantial work for unclear benefit
- Mark as "considering" but not prioritized

---

## Bug Reports / UX Issues

### 1. Global Shortcut Conflicts
**Priority: HIGH** | **Status: Needs Fix**

| Requester | Issue | Notes |
|-----------|-------|-------|
| u/a_tsygankov | "cmd + , for 'Open settings' overrides all other apps" | Should disable by default |

**Fix:**
- Remove default `⌘,` shortcut for Settings
- Users can still set it manually if desired
- Standard macOS convention is app-specific `⌘,`

---

### 2. Auto-Hide Window Stacking Issue
**Priority: MEDIUM** | **Status: Needs Investigation**

| Requester | Issue | Notes |
|-----------|-------|-------|
| u/JustABro_2321 | "when hiddenbar collapses, it buries the menubar app's settings window to the back" | Comparing to HiddenBar bug |

**Investigation:**
- Does SaneBar have this same issue?
- If auto-hide triggers while interacting with a menu bar app popup, does it bury the window?
- May need "smart" detection of active interactions

---

## Feature Request Sources

| Source | Link | Date Checked |
|--------|------|--------------|
| Reddit r/macapps | Launch thread | Jan 2026 |
| GitHub Issues | (check weekly) | - |

---

## Decision Log

| Date | Feature | Decision | Rationale |
|------|---------|----------|-----------|
| Jan 2026 | Menu Bar Spacing | Consider for v1.1 | High demand from power users |
| Jan 2026 | Secondary Menu Bar | Deprioritized | Architectural complexity, unclear demand |

---

## Next Steps

1. **Immediate (v1.0.x)**
   - [ ] Fix `⌘,` shortcut conflict
   - [ ] Add Find Icon to right-click menu
   - [ ] Profile Find Icon performance

2. **Short Term (v1.1)**
   - [ ] Investigate spacing control implementation
   - [ ] Research auto-hide interaction detection

3. **Evaluate Later**
   - Custom dividers
   - Secondary menu bar row
