# SOP ENFORCEMENT ACTIVE

You are working on **SaneBar**. The following rules are MANDATORY.

---

## On Session Start (IMMEDIATE - Before anything else)

The bootstrap hook outputs a ready toast automatically:
```
──────────────────────────────────────────────────
✅ Ready — Ruby, tools, hooks, MCP servers checked.
🧠 Memory will load on first response.

What would you like to work on today?
──────────────────────────────────────────────────
```

**Your first action** when the user sends any message: Call `mcp__memory__read_graph` to load cross-session context. This happens automatically - no need to mention it to the user.

---

## Before ANY Code Change

- [ ] **EXPLORE FIRST** - Read relevant files, grep patterns, understand context BEFORE editing. No edits until you have a clear picture. If unsure, say "I need to explore X before making changes."
- [ ] Verify current state with `grep`/`find` (NOT memory - Rule #13)
- [ ] If API involved: `./Scripts/SaneMaster.rb verify_api <API> [Framework]` (Rule #1)
- [ ] Two-Fix Rule: If you fail twice, STOP and investigate — that's the win, not the failure (Rule #2)

## After ANY Code Change

```bash
./Scripts/SaneMaster.rb verify        # Build + test (Rule #4)
killall -9 SaneBar                     # Kill old instances (Rule #5)
./Scripts/SaneMaster.rb launch         # Start fresh
./Scripts/SaneMaster.rb logs --follow  # Watch logs (Rule #6)
```

## For Bug Fixes (MANDATORY)

- [ ] Add regression test in `Tests/` (Rule #7)
- [ ] Document in `BUG_TRACKING.md` if persistent (Rule #8)
- [ ] Search for similar patterns elsewhere: `grep -r "pattern" Core/ UI/`

## Before Claiming Done

- [ ] Self-rate 1-10 with checklist (MANDATORY)
- [ ] Format: `**Self-rating: X/10**` with what you did well / missed

---

## Session Start (MANDATORY - DO IMMEDIATELY)

**Before doing ANYTHING else, execute these two steps:**

1. **Check Memory** - Call `mcp__memory__read_graph` to load cross-session context
   - Bug patterns, architecture decisions, file violations already tracked
   - Recent fixes and learnings from past sessions

2. **Health Check** - Run `./Scripts/SaneMaster.rb health`

⚠️ **If you skipped memory check, STOP and do it now.** Past context prevents repeated mistakes.

## Session End

Run the session end command:

```bash
./Scripts/SaneMaster.rb session_end
```

This will:
- Prompt for memory-worthy insights (bug patterns, concurrency gotchas, architecture decisions)
- Auto-record insights to Memory MCP
- Show session summary with memory stats
- Warn if entity count > 60 (consolidation needed)

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `./Scripts/SaneMaster.rb health` | Quick health check |
| `./Scripts/SaneMaster.rb verify` | Build + unit tests |
| `./Scripts/SaneMaster.rb test_mode` | Kill -> Build -> Launch -> Logs |
| `./Scripts/SaneMaster.rb logs --follow` | Stream live logs |
| `./Scripts/SaneMaster.rb verify_api X` | Check if API exists in SDK |
