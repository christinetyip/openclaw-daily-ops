#!/bin/bash
# calendar-today.sh — Fetch today's calendar and format for planning
# Run: bash scripts/calendar-today.sh
# Optional: WORK_START=0900 WORK_END=1730 bash scripts/calendar-today.sh

# Default timezone. Override with TZ env var when traveling.
export TZ="${TZ:-America/Los_Angeles}"

WORK_START="${WORK_START:-1000}"
WORK_END="${WORK_END:-2200}"

TMPFILE=$(mktemp)
gog calendar events --today --all --max 50 --json --no-input 2>/dev/null > "$TMPFILE"

if [ ! -s "$TMPFILE" ]; then
  echo "ERROR: Could not fetch calendar (empty output)"
  echo "Try manually: gog calendar events --today --all --max 50 --json --no-input"
  rm -f "$TMPFILE"
  exit 1
fi

node -e '
const fs = require("fs");
const raw = fs.readFileSync(process.argv[1], "utf8");

let events;
try {
  const parsed = JSON.parse(raw);
  events = Array.isArray(parsed) ? parsed : (parsed.items || parsed.events || []);
} catch(e) {
  console.log("ERROR: Could not parse calendar JSON");
  console.log("First 300 chars:", raw.slice(0, 300));
  process.exit(1);
}

const wsRaw = process.argv[2] || "0800";
const weRaw = process.argv[3] || "1730";
const wsMin = Math.floor(parseInt(wsRaw) / 100) * 60 + (parseInt(wsRaw) % 100);
const weMin = Math.floor(parseInt(weRaw) / 100) * 60 + (parseInt(weRaw) % 100);

const pad = n => String(n).padStart(2, "0");
const fmtMin = m => pad(Math.floor(m / 60)) + ":" + pad(m % 60);
const fmtDur = m => {
  const h = Math.floor(m / 60);
  const min = m % 60;
  if (h === 0) return min + "m";
  if (min === 0) return h + "h";
  return h + "h " + pad(min) + "m";
};

// Separate timed vs all-day events
const timed = [];
const allDay = [];

for (const e of events) {
  if (!e.start) continue;
  const title = e.summary || "No title";

  if (e.start.dateTime) {
    timed.push({
      title,
      start: new Date(e.start.dateTime),
      end: new Date(e.end.dateTime)
    });
  } else if (e.start.date) {
    allDay.push({ title });
  }
}

timed.sort((a, b) => a.start - b.start);

// Header
const now = new Date();
const days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
const dateStr = now.getFullYear() + "-" + pad(now.getMonth()+1) + "-" + pad(now.getDate());
console.log("TODAY: " + days[now.getDay()] + " " + dateStr);
console.log("=".repeat(45));

// All-day events
if (allDay.length > 0) {
  console.log("");
  console.log("ALL DAY:");
  allDay.forEach(e => console.log("  * " + e.title));
}

// Fixed blocks
console.log("");
console.log("FIXED BLOCKS:");
if (timed.length === 0) {
  console.log("  (no timed events today)");
} else {
  const fmt = d => pad(d.getHours()) + ":" + pad(d.getMinutes());
  timed.forEach(e => {
    console.log("  " + fmt(e.start) + "-" + fmt(e.end) + "  " + e.title);
  });
}

// Calculate free windows
const blocks = timed.map(e => ({
  start: e.start.getHours() * 60 + e.start.getMinutes(),
  end: e.end.getHours() * 60 + e.end.getMinutes()
})).filter(b => b.end > wsMin && b.start < weMin);

const windows = [];
let cursor = wsMin;
for (const b of blocks) {
  const bStart = Math.max(b.start, wsMin);
  const bEnd = Math.min(b.end, weMin);
  if (bStart > cursor) {
    windows.push({ start: cursor, end: bStart });
  }
  cursor = Math.max(cursor, bEnd);
}
if (cursor < weMin) {
  windows.push({ start: cursor, end: weMin });
}

console.log("");
console.log("FREE WINDOWS:");
let totalFree = 0;
if (windows.length === 0) {
  console.log("  (no free windows during work hours)");
} else {
  windows.forEach(w => {
    const dur = w.end - w.start;
    totalFree += dur;
    console.log("  " + fmtMin(w.start) + "-" + fmtMin(w.end) + "  (" + fmtDur(dur) + ")");
  });
}

console.log("");
console.log("TOTAL FREE: " + fmtDur(totalFree));
console.log("HARD STOP: " + fmtMin(weMin));
' "$TMPFILE" "$WORK_START" "$WORK_END"

rm -f "$TMPFILE"
