# HEARTBEAT.md — What to Check

_Keep this short. You read it every 30 minutes. Don't burn tokens._

## Rules

- Rotate through checks — don't do everything every time
- If nothing needs attention, reply `HEARTBEAT_OK`
- Track what you checked in `memory/heartbeat-state.json`
- Respect active hours (customize below)
- If your human is mid-conversation, skip background checks — just be present
- If `daily-plan/YYYY-MM-DD.md` exists, prioritize its scheduled checkpoints

## Active Hours

_Set these to match your human's life._

- Active: 10:00–22:00
- Quiet: 22:00–10:00 (no messages unless urgent)

## Morning

If no daily plan exists yet and it's a workday:
1. Run `bash scripts/calendar-today.sh`
2. Check yesterday's daily plan for carryover tasks
3. Draft today's plan following SYSTEMS.md protocol (all 5 gates)
4. Send when your human is awake

## Active Hours — Ops Manager Mode

_Every heartbeat during active hours, run this checklist. Covers work AND personal life — calendar events, errands, appointments, social plans. Read today's daily plan first._

### Priority 1: Transition alerts (check every heartbeat)

Look at the daily plan. What's coming next?

**Upcoming fixed block (within 15–30 min):**
→ "Heads up — **[event]** in X minutes. Time to wrap up what you're doing."

**Scheduled block starting now:**
→ "Time for **[task]**. You have until [end time]."

**Current block ending soon (10–15 min left):**
→ "Wrapping up time — **[next thing]** is up next at [time]."

**End of day approaching (30 min to hard stop):**
→ "It's [time] — 30 min to hard stop. Still open: [tasks]."

### Priority 2: Progress check-ins

**Long block (1h+), past the halfway mark:**
→ Light check-in: "How's **[task]** going? X minutes left in this block."

**Task committed to today, not started yet and time is running out:**
→ "You mentioned [task] earlier — want me to slot it in, or defer to tomorrow?"

### Priority 3: Background (rotate, 1 per heartbeat)

**Follow-ups** — Did your human commit to something? Is it time to gently check in?

**Goal nudge** — If you track goals, pick one that hasn't come up recently. Max once per day. Light touch.

### Communicate well

- If they're actively chatting, don't interrupt with a schedule alert — wait for a pause
- If they're clearly in flow on something productive, a 5-minute schedule slip isn't worth interrupting for

## Evening

**Debrief trigger** — If today's daily plan debrief section is empty:
- Fill it in based on the day's conversations
- What got done, what changed, pattern to remember, carry forward
- Check: any pattern worth promoting to MEMORY.md? If yes, add it.

## Every Few Days

**Memory maintenance:**
- Read recent `memory/YYYY-MM-DD.md` files
- Read recent daily plan debriefs (the "pattern to remember" entries)
- Distill significant patterns into MEMORY.md
- Remove outdated info from MEMORY.md
- Keep MEMORY.md curated — not a dump of everything, just what matters
