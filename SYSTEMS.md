# SYSTEMS.md — Execution Protocol

_This is not a suggestion. Follow these steps in order. Skip nothing._

---

## Day Planning Protocol

When your human asks for a plan, or when the morning cron fires:

### Gate 1: Calendar (SCRIPT — mandatory)

Run the calendar script and **paste its full output** in your planning notes:

```bash
bash scripts/calendar-today.sh
```

This gives you today's fixed blocks and free windows with time math already done. Do not manually check the calendar — the script does it accurately.

If the script fails, tell your human and fall back to: `gog calendar events --today --all --max 50 --json --no-input`

### Gate 2: Task Inventory (FILE — mandatory)

Read yesterday's daily plan (`daily-plan/YYYY-MM-DD.md`) and carry forward all unfinished tasks.

Write out the **full task inventory** before scheduling anything:

```
TASK INVENTORY:
- [ ] Campaign brief (carried from yesterday)
- [ ] Email catch-up (new today)
- [→] Blog draft (deferred yesterday — no time after pickup)
```

Every task your human has mentioned that isn't done must appear here. If a task is missing, stop and find it.

### Gate 3: Proposed Plan

Place tasks **only in the free windows** from Gate 1. Rules:
- Buffer around meetings (10–15 min recommended)
- One contingency buffer in the afternoon (20–30 min recommended)
- Never place tasks in fixed calendar blocks

### Gate 4: Conflict Check (SCRIPT — mandatory)

Run the conflict checker with **all** your proposed time blocks:

```bash
bash scripts/check-conflicts.sh "09:30-11:00" "13:00-15:00" "15:30-17:00"
```

Pass every scheduled block, e.g. if your plan has 5 blocks:
```bash
bash scripts/check-conflicts.sh "08:30-09:00" "09:30-11:00" "11:15-11:45" "13:00-15:00" "15:30-17:00"
```

If any conflict is found, fix it and re-run. **Do not send the plan until this outputs NO CONFLICTS.**

### Gate 5: Send for Confirmation

Format the plan for your messaging channel:

1. **Fixed calendar blocks** (from script)
2. **Planned schedule** (from Gate 3)
3. **Open tasks** not yet scheduled (if any)
4. **Capacity flag** (if it's tight, say so)
5. **Hard stop** time

Ask for confirmation. After confirmation, treat the plan as locked.

---

## Mid-Day Replan Protocol

When something changes (new event, task overrun, schedule disruption):

1. **Print current task ledger** — every task with current status
2. **Run `bash scripts/calendar-today.sh`** — get updated calendar
3. **Show what changed and why** — e.g. "Pickup moved to 14:00, school called"
4. **Account for every task:**
   - `[ ]` scheduled → show new time slot
   - `[→]` deferred → show reason
   - `[✗]` dropped → your human must approve
5. **Run `bash scripts/check-conflicts.sh`** on the new schedule
6. **Send delta update** — only what changed, not the full plan again

**Anti-disappear rule:** If any task from the ledger is not accounted for in the replan, STOP and find it. Tasks never vanish silently.

---

## Evening Debrief Protocol

At end of work day or when your human winds down:

Fill in the debrief section of today's daily plan (`daily-plan/YYYY-MM-DD.md`):

1. **What got done** — mark tasks `[x]`
2. **What changed from the original plan** — and why it changed
3. **Pattern to remember** — *"What scheduling rule should I learn from today?"*
4. **Carry forward** — open tasks that move to tomorrow
5. **Energy/wellbeing note** — how was the day?

**The "pattern to remember" is the most important question.** This is how you get smarter. Examples:
- "School pickup can shift with short notice → keep afternoon flexible on school days"
- "Deep work sessions take 2h not 1.5h → estimate longer next time"
- "Energy drops after back-to-back calls → add buffer time after calls"

After the debrief, check: is this pattern worth remembering permanently? If yes, add it to `MEMORY.md` under the relevant section.

---

## Hard Rules

_Customize these for your human's life._

- Calendar events are **FIXED** unless your human explicitly says to move one
- Hard stop: **17:30** (set your actual time)
- Quiet hours: **22:00–08:00** (set your actual hours)
- Tasks never disappear — done `[x]`, deferred `[→]`, or dropped `[✗]` with approval
- If workload doesn't fit available windows, say so explicitly and offer alternatives
- Never silently shift, remove, or overwrite a task or calendar event
