# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Boro Predictor is a static web app for Middlesbrough FC fans to predict scores for all 46 fixtures in the 2025/26 EFL Championship season. It also includes a separate multi-player prediction league backed by Supabase with a waitlist landing page and a live points ladder.

## Running the App

No build step or install required — open any HTML file directly in a browser. All external libraries load from CDN. There are no automated tests.

## Page Architecture

Four distinct pages, each self-contained:

| File | Purpose |
|---|---|
| `index.html` | Main predictor — all 46 fixtures, localStorage-only, no auth |
| `landing.html` | Simple interest registration page (no Supabase — form is a stub, `TODO` in script) |
| `boro-landing/index.html` | Full landing page with Supabase waitlist email capture |
| `boro-ladder/index.html` | Live points ladder — requires Supabase auth (magic link sign-in) |

`results.html` is an incomplete page that fetches from a Google Apps Script URL; it also reads from `localStorage` key `boroPredictions` (note: `index.html` saves under `boroScores` — these differ and is a known inconsistency).

## index.html — Predictor App

All application logic is inline `<script>`. `styles.css` handles all styling including the newspaper-style report modal.

### Data Model

- `fixtures` — 46 `{ home, away, date }` objects. Only `fixtures[0]` has a real date (`9/8/25`); all others are placeholder `30/8/25`.
- `scores` — 46 `{ home, away }` objects; the only mutable state.
- `teams` — lookup from team name → badge SVG path in `badges/`. Norwich City's entry points to `.png` rather than `.svg` (known inconsistency).

Predictions persist via `saveScoresToLocal()` / `loadScoresFromLocal()` under `localStorage` key `boroScores`.

### Month Dividers

`renderFixtures()` uses a hardcoded index map to inject month header SVGs between fixture cards:

```js
{ 0: 'August', 4: 'September', 8: 'October', 12: 'November',
  18: 'December', 24: 'January', 30: 'February', 35: 'March',
  39: 'April', 45: 'May' }
```

If fixtures are reordered, these indices must be updated manually.

### Key Functions

| Function | Purpose |
|---|---|
| `renderFixtures()` | Builds full fixture list DOM from `fixtures` + `scores` |
| `changeScore(index, team, delta)` | Mutates `scores`, clamps 0–9, updates colour, saves |
| `updateFixtureColor(index)` | Applies `.win` / `.loss` class based on Boro's predicted result |
| `calculatePoints()` | Tallies wins/draws/losses/GD, maps total points to one of 6 narrative tiers, opens report modal |
| `submitPredictions()` | Exports to `.xlsx` via XLSX CDN library |

### Season Outcome Tiers

`calculatePoints()` maps points totals to narrative outcomes: 100+ → "Smash the League", 75+ → promotion, 65+ → play-offs, 50+ → mid-table, 40+ → poor season, <40 → relegation nightmare.

### Scoring Rules

- Correct home goals: 1 pt
- Correct away goals: 1 pt
- Correct result (W/D/L): 1 pt
- Exact scoreline: 4 pts (replaces the above three, not in addition)

## Supabase Integration (boro-landing + boro-ladder)

Both `boro-landing/index.html` and `boro-ladder/index.html` contain hardcoded `SUPABASE_URL` and `SUPABASE_ANON_KEY` constants near the top of their `<script>` blocks. These are the anon (public) keys — safe to expose client-side.

`boro-ladder/schema.sql` defines the full schema: `waitlist`, `players`, `fixtures`, `predictions`, `results`, `settings` tables plus a `ladder` VIEW that computes points using the same scoring rules as the JS app. Row Level Security is enabled on all tables.

The ladder uses magic-link auth (`sb.auth.signInWithOtp`). A Postgres trigger (`handle_new_user`) auto-creates a row in `players` on first login using the email prefix as the default name.

Predictions are locked site-wide via a `settings` table row (`key = 'predictions_locked'`, `value = 'true'/'false'`). The ladder page reads this on load.

See `boro-ladder/SETUP.md` for the end-to-end setup guide (Supabase project creation, running schema.sql, configuring redirect URLs for GitHub Pages, and day-to-day result entry).

## Assets

- `badges/` — SVG team logos. 24 clubs; Norwich City's path in the `teams` object points to `.png`.
- Root SVGs — UI icons (`help.svg`, `clearall.svg`, `Download.svg`) and month header images (`August.svg`, etc.).
- Outcome images — `boro-paper.webp`, `boro-promotion.webp`, `boro-playoffs.webp`, `boro-relegation.webp`, `boro-disaster.jpg` — used in the report modal.
