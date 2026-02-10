---
name: block-external-posts
enabled: true
event: bash
action: warn
pattern: gh\s+(issue|pr)\s+comment|gh\s+api\s+.*(--method\s+(POST|PUT|PATCH)|-(X)\s+(POST|PUT|PATCH))|gh\s+api\s+repos/.*/comments|curl\s+.*(-X\s+POST|--data|--json|-d\s).*resend\.com|curl\s+.*(-X\s+POST|--data|--json|-d\s).*email-api\.saneapps\.com
---

**BLOCKED: External post detected**

You are about to post to GitHub or send an email. This is blocked because:

1. **Show the draft to the user FIRST** — paste the full comment/email text in chat
2. **Wait for explicit approval** — user says "yes, post it" or "approved"
3. **Only then execute** the command

This rule exists because Claude previously posted GitHub comments and sent emails
without showing drafts to the user. The user said: "I'm in control here, not you."

**What to do now:**
- Show the exact text you plan to post
- Ask: "Here's my draft for [target]. Should I post it?"
- Wait for approval before re-running the command
