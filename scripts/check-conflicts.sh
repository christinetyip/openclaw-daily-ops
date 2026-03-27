#!/bin/bash
# check-conflicts.sh — Check proposed time blocks against today's calendar
# Run: bash scripts/check-conflicts.sh "09:30-11:00" "13:00-15:00" "15:30-17:00"
# Each argument is a HH:MM-HH:MM time range

# Default timezone. Override with TZ env var when traveling.
export TZ="${TZ:-America/Los_Angeles}"

if [ $# -eq 0 ]; then
  echo "Usage: bash scripts/check-conflicts.sh \"HH:MM-HH:MM\" [\"HH:MM-HH:MM\" ...]"
  echo "Example: bash scripts/check-conflicts.sh \"09:30-11:00\" \"13:00-15:00\""
  exit 1
fi

TMPFILE=$(mktemp)
gog calendar events --today --all --max 50 --json --no-input 2>/dev/null > "$TMPFILE"

if [ ! -s "$TMPFILE" ]; then
  echo "ERROR: Could not fetch calendar (empty output)"
  rm -f "$TMPFILE"
  exit 1
fi

node -e '
const fs = require("fs");
const raw = fs.readFileSync(process.argv[1], "utf8");
const proposed = process.argv.slice(2);

let events;
try {
  const parsed = JSON.parse(raw);
  events = Array.isArray(parsed) ? parsed : (parsed.items || parsed.events || []);
} catch(e) {
  console.log("ERROR: Could not parse calendar JSON");
  process.exit(1);
}

const calBlocks = events
  .filter(e => e.start && e.start.dateTime)
  .map(e => {
    const s = new Date(e.start.dateTime);
    const end = new Date(e.end.dateTime);
    return {
      title: e.summary || "No title",
      startMin: s.getHours() * 60 + s.getMinutes(),
      endMin: end.getHours() * 60 + end.getMinutes()
    };
  });

const pad = n => String(n).padStart(2, "0");
const fmtMin = m => pad(Math.floor(m / 60)) + ":" + pad(m % 60);

let conflicts = 0;
let checked = 0;

for (const p of proposed) {
  const match = p.match(/^(\d{2}):(\d{2})-(\d{2}):(\d{2})$/);
  if (!match) {
    console.log("SKIP: \"" + p + "\" is not a valid HH:MM-HH:MM range");
    continue;
  }
  checked++;
  const pStart = parseInt(match[1]) * 60 + parseInt(match[2]);
  const pEnd = parseInt(match[3]) * 60 + parseInt(match[4]);

  for (const cal of calBlocks) {
    // Two ranges overlap if start1 < end2 AND start2 < end1
    if (pStart < cal.endMin && cal.startMin < pEnd) {
      console.log("CONFLICT: " + p + " overlaps with " +
        fmtMin(cal.startMin) + "-" + fmtMin(cal.endMin) + " " + cal.title);
      conflicts++;
    }
  }
}

console.log("");
if (conflicts === 0) {
  console.log("NO CONFLICTS FOUND (" + checked + " blocks checked)");
} else {
  console.log(conflicts + " conflict(s) detected. Fix before sending plan.");
}
' "$TMPFILE" "$@"

rm -f "$TMPFILE"
