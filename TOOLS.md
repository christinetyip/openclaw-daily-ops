# TOOLS.md — Operational Notes

## GOG (Google Calendar CLI)

**Check today's calendar:**
```bash
gog calendar events --today --all --max 50 --json --no-input
```

**Check tomorrow:**
```bash
gog calendar events --from tomorrow --to tomorrow --all --max 50 --json --no-input
```

**Check specific date:**
```bash
gog calendar events --from 2026-02-15 --to 2026-02-15 --all --max 50 --json --no-input
```

**Create event (with invite so it appears on their calendar):**
```bash
gog calendar events create --title "Event Name" --start "2026-02-14T20:00:00" --end "2026-02-14T23:00:00" --attendees "their-email@example.com" --no-input
```
Check `gog calendar events create --help` for exact flags.

**Notes:**
- `--no-input` required for headless operation
- `--json` gives structured output for scripts
- `--all` includes all calendars
- Always ask before creating events

## Scripts

Planning scripts live in `scripts/`. Use these instead of raw commands.

**Calendar formatter:**
```bash
bash scripts/calendar-today.sh
```
Fetches today's calendar, outputs clean fixed blocks + free windows with time math. Use for all planning.

**Conflict checker:**
```bash
bash scripts/check-conflicts.sh "09:30-11:00" "13:00-15:00"
```
Takes proposed time blocks and checks against today's calendar. Outputs CLEAR or lists conflicts.

**Override work hours (optional):**
```bash
WORK_START=0900 WORK_END=1800 bash scripts/calendar-today.sh
```

**Override timezone (when traveling):**
```bash
TZ=America/New_York bash scripts/calendar-today.sh
```
