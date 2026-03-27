# OpenClaw Daily Ops Manager

Turn your OpenClaw agent into a daily operations manager that actually works.

This is the system I built after my agent kept shifting calendar events, losing tasks between replans, and misreading meeting times — despite detailed instructions telling it not to.

The fix wasn't better prompts. It was better architecture.

## What It Does

- **Morning:** Fetches your calendar, plans your day, sends you the schedule
- **During the day:** Transition alerts, wrap-up reminders, progress check-ins
- **Replans:** When things change, every task is accounted for — nothing disappears silently
- **Evening:** Structured debrief that extracts patterns so the agent gets smarter over time

## The Core Idea: Enforcement Levels

Most agent failures happen because everything runs on prompting — natural language instructions the model sometimes follows and sometimes doesn't. The fix is matching each task to the right enforcement level:

```
SOFT                                                        HARD
  |                |                |                          |
Prompting       Templates        Scripts                Cron/Hooks
"please do X"   "fill in this    "run this code,        "this runs
                 format"          use the output"        automatically"
```

| What | Level | Why |
|------|-------|-----|
| Personality, tone | Prompting | Doesn't need to be exact |
| Daily plan structure | Templates | Consistency matters |
| Calendar accuracy | Scripts | Errors cause real problems |
| Morning plan delivery | Cron/Heartbeat | Must happen on time |

**Principle: the more a step matters, the further right it should be.**

## How to Use This

**Don't copy these files verbatim.** This repo is a reference architecture. The recommended approach:

1. Download or clone this repo
2. Show the files to your OpenClaw agent
3. Tell it: "Read all of these files. Build me a similar daily ops system, customized for my life, using the same enforcement methods."
4. Your agent will ask you about your schedule, preferences, and tools — then build custom versions of everything

Your agent understands these files. They're written in the same format it already works with. It will know what to do.

### If you prefer to install manually

See [Manual Installation](#manual-installation) below.

## File Structure

```
├── SYSTEMS.md              # Planning protocol — the 5 gates
├── HEARTBEAT.md            # Proactive ops manager checklist
├── MEMORY.md               # Long-term memory template
├── TOOLS.md                # Operational notes (calendar commands, scripts)
├── daily-plan/
│   └── TEMPLATE.md         # Daily plan + task ledger + debrief
└── scripts/
    ├── calendar-today.sh   # Fetches calendar, formats clean output
    └── check-conflicts.sh  # Checks proposed times against calendar
```

## How It Works

### The 5-Gate Planning Protocol

Every plan goes through five gates before being sent. Gates 1 and 4 are scripts (hard enforcement). Gates 2, 3, 5 are template-driven (medium enforcement).

1. **Calendar** — Script fetches and formats today's events + free windows
2. **Task Inventory** — Agent prints every open task before scheduling anything
3. **Proposed Plan** — Tasks placed only in free windows, with buffers
4. **Conflict Check** — Script mechanically verifies no overlaps
5. **Send** — Plan goes to you for confirmation

### The Task Ledger

Every task gets a status. Nothing disappears:

- `[ ]` open
- `[x]` done
- `[→]` deferred (must include reason)
- `[✗]` dropped (must be approved by you)

### The Evening Debrief

The template asks: **"What scheduling rule should I learn from today?"**

This forces the agent to extract patterns, not just log events:
- "Meeting overran by 30 min" → "Add 15 min buffer after client calls"
- "Pickup time changed last minute" → "Keep afternoons flexible on school days"

Patterns get promoted to `MEMORY.md` over time. The agent gets better at planning because it remembers what went wrong.

### The Heartbeat (Ops Manager Mode)

Every 30 minutes during active hours, the agent runs through a priority checklist:

1. **Transition alerts** — "Meeting in 15 min, time to wrap up"
2. **Progress check-ins** — "How's the deep work going? 45 min left"
3. **End-of-day countdown** — "30 min to hard stop, these tasks are still open"

This covers work and personal life — calendar events, errands, social plans, everything.

## Prerequisites

- [OpenClaw](https://openclaw.ai) running (Docker, local, whatever)
- Google Calendar access via [GOG CLI](https://github.com/steipete/gogcli) (`gog` command working)
- A messaging channel (WhatsApp, Discord, etc.)

## For Your Agent

_This section is for your agent to read when building your custom system._

**Hey agent — if your human showed you this repo, here's what to do:**

1. **Read every file in this repo** to understand the architecture: the 5-gate planning protocol, the task ledger, the enforcement levels, the scripts, the heartbeat ops checklist, and the evening debrief.

2. **Ask your human** about their life:
   - What are your work hours?
   - What's your hard stop time?
   - What timezone are you in?
   - What messaging channel do you use?
   - What calendar tool do you use? (GOG, MCP Google Calendar, etc.)
   - Do you have quiet hours? When?
   - Any recurring events or constraints? (school pickup, family dinner, gym, etc.)

3. **Build custom versions** of each file for their life:
   - `SYSTEMS.md` — Adapt the 5-gate protocol. Keep the gates, customize the hard rules.
   - `HEARTBEAT.md` — Set active hours, morning plan time, evening debrief time.
   - `MEMORY.md` — Seed with any preferences they share during setup.
   - `TOOLS.md` — Document the actual commands for their calendar tool.
   - `daily-plan/TEMPLATE.md` — Keep the structure (task ledger, conflict check, debrief). Customize the hard stop time.
   - `scripts/calendar-today.sh` — Adapt if they use a different calendar tool. Keep the output format (FIXED BLOCKS + FREE WINDOWS).
   - `scripts/check-conflicts.sh` — Same — adapt the calendar fetch command, keep the conflict-checking logic.

4. **Key concepts to preserve** (don't lose these in customization):
   - Scripts for calendar accuracy — don't let the model interpret raw calendar data
   - Task ledger with status symbols — nothing disappears without a status
   - Conflict check before every plan — mechanical verification, not model judgment
   - Evening debrief with "what pattern should I learn?" — this is how you get smarter
   - Heartbeat transition alerts — proactive, not just reactive

5. **Add the planning rule to AGENTS.md:**
   ```
   - **Planning rule:** for any day planning/scheduling message, follow
     `SYSTEMS.md` strictly — including running calendar and conflict-check
     scripts. Never send a plan without verified calendar data.
   ```

6. **Test it together.** Ask your human: "Want me to plan tomorrow as a test run?" Walk through all 5 gates visibly so they can see how it works.

## Manual Installation

If you prefer to install the files directly instead of having your agent build custom versions:

1. **Copy files into your OpenClaw workspace:**

   ```bash
   docker cp SYSTEMS.md your-container:/home/node/.openclaw/workspace/
   docker cp HEARTBEAT.md your-container:/home/node/.openclaw/workspace/
   docker cp MEMORY.md your-container:/home/node/.openclaw/workspace/
   docker cp TOOLS.md your-container:/home/node/.openclaw/workspace/
   docker cp daily-plan/TEMPLATE.md your-container:/home/node/.openclaw/workspace/daily-plan/
   docker cp scripts/ your-container:/home/node/.openclaw/workspace/scripts/
   ```

2. **Make scripts executable:**

   ```bash
   docker exec --user root your-container chmod +x \
     /home/node/.openclaw/workspace/scripts/calendar-today.sh \
     /home/node/.openclaw/workspace/scripts/check-conflicts.sh
   ```

3. **Fix ownership (Docker only):**

   ```bash
   docker exec --user root your-container chown -R 1000:1000 \
     /home/node/.openclaw/workspace/scripts
   ```

4. **Add to your AGENTS.md** (see [For Your Agent](#for-your-agent) section, step 5)

5. **Configure for your life:** Update the Hard Rules in `SYSTEMS.md` and seed `MEMORY.md` with your preferences.

### Verify It Works

Ask your agent: "Plan my day."

It should:
1. Run `scripts/calendar-today.sh` and show you the output
2. List your task inventory
3. Propose a schedule using only free windows
4. Run `scripts/check-conflicts.sh` and show the result
5. Send you the plan for confirmation

If any gate is missing, the system is working — because you can see what was skipped.

## Customization

### Timezone

Scripts default to `Europe/Amsterdam`. Override when traveling:

```bash
TZ=America/New_York bash scripts/calendar-today.sh
```

To change the default, edit the `TZ` line in both scripts.

### Work Hours

Scripts default to 08:00–17:30. Override:

```bash
WORK_START=0900 WORK_END=1800 bash scripts/calendar-today.sh
```

### Hard Rules

Edit the **Hard Rules** section in `SYSTEMS.md` to match your life. Common things to set:
- Hard stop time
- Quiet hours (when the agent shouldn't message you)
- Work hours
- Which calendar events are fixed vs. flexible

## The Meta-Lesson

Most of the time when your agent is unreliable, the fix isn't a better prompt. It's moving that step from "instructions the model follows" to "code the model uses."

Prompt less. Verify more.

## Credits

Built by [@christinetyip](https://twitter.com/christinetyip). Part of building [Ensue](https://ensue.dev) in public.

## License

MIT — use it, fork it, make it yours.
