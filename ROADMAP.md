# Boro Predictor — Roadmap & Feature Ideas

## Key Dates

| Date | Milestone |
|---|---|
| ~Mid June 2026 | EFL Championship 2026/27 fixtures released |
| 25 June 2026 | Fixture data live, predictor page open |
| 14 August 2026 | Season starts — predictions locked |

---

## Phase 1 — Fixture Data (before June 25)

- EFL releases 2026/27 Championship fixtures mid-June
- Pull via football API (football-data.org or API-Football) — one-time upsert into Supabase `fixtures` table
- Update `predict/index.html` to load fixtures from Supabase rather than hardcoded JS array
- Confirm 24 teams for 2026/27 (promotions/relegations) — add/remove badges in `assets/badges/`
- Recalculate month divider index map once real dates are in

## Phase 2 — Open the App (June 25 → August 14)

- Waitlist users can log in and access `predict/`
- Verify magic-link → player creation → predict → save flow end to end
- Set `predictions_locked = false` in Supabase settings

## Phase 3 — Lock & Run (August 14 onwards)

- Set `predictions_locked = true` before kickoff
- Enter results weekly via `ladder/SETUP.md` flow
- Ladder VIEW auto-computes points

---

## Waitlist / Non-Entrants

Users who sign up on the landing page but never enter the competition sit only in the `waitlist` table. Plan:

- Add **"keep me updated"** opt-in checkbox to landing form (separate GDPR consent from competition entry)
- Newsletter has two audiences:
  - **Players** — full results, ladder, standings, Manager of the Month
  - **Waitlist** — lighter version ("here's this week's results, join the league next season")
- Resend supports multiple audience lists for clean segmentation

---

## Analyst Page — Current Build

Six panels on `analyst/index.html`. Gate modal on entry. Top 4 are dashboard-style (2-col grid). Bottom 2 span full width as season overview panels.

### Panel 1 — Community Split
**What:** Pie/donut chart showing how the 24-player community split their prediction for the next fixture (home win / draw / away win).

**Current state:** Placeholder percentages (58% / 25% / 17%) hardcoded for Boro vs Swansea.

**To make live:**
- Query `predictions` table for fixture index 0 (next match), count predicted outcomes per player
- Determine each player's predicted result (Boro win / draw / loss) from their scoreline
- Calculate percentages and re-render the conic-gradient donut dynamically
- Update fixture label from `fixtures` table or hardcoded array

### Panel 2 — Most Common Score
**What:** The single most-predicted scoreline among all players for the next fixture. Shows score, a progress bar, and the count/percentage of players who picked it.

**Current state:** ✅ Live — queries `predictions` table (`fixture_index = 0`), groups by scoreline, surfaces the mode.

**Note:** Requires a Supabase RLS policy that allows anon reads of all `predictions` rows. If none exists, the panel shows "No predictions yet."

**To make live (if RLS blocks):**
- Add a Postgres policy: `CREATE POLICY "Public can read predictions" ON predictions FOR SELECT USING (true);`
- Or expose via a public Supabase function/view that returns aggregated counts only

### Panel 3 — Fan Profile
**What:** Classifies the player as Pessimist / Realist / Optimist by comparing their predicted Boro points vs Boro's actual points for completed fixtures.

**Current state:** ✅ Live — fetches from `results` table (actual Boro points), reads `boroScores` from localStorage (predicted points for same fixtures), compares diff.

**Thresholds (diff = predicted − actual):**
- ☀️ **Optimist** — predicted ≥ 3 pts more than Boro got
- 🔬 **Realist** — within 2 pts either way (including 0 matches played)
- 🌧️ **Pessimist** — predicted ≥ 3 pts fewer than Boro got

### Panel 4 — Bookies
**What:** Shows the implied probability of the player's own predicted scoreline based on betting market odds. Colour coded by chance: <5% Long Shot · 5–10% Possible · 10–15% Decent · 15%+ Strong.

**Current state:** Shows player's saved prediction for fixture 0 (from localStorage). Probability shows "—" with "Odds API coming soon" chip. Colour classes already in CSS.

**To make live:**
- Integrate The Odds API (or API-Football odds endpoint)
- For each upcoming fixture, fetch correct-score market odds
- Convert decimal odds to implied probability: `1 / decimal_odds * 100`
- Match against player's predicted scoreline and display
- Cache results (odds rarely change more than once/day)
- Threshold colours: <5% → red `.prob-long` · 5–10% → amber `.prob-poss` · 10–15% → blue `.prob-decent` · 15%+ → green `.prob-strong`

### Panel 5 — Season Achievement *(wide)*
**What:** The player's rarest correct prediction — the scoreline they got right that the fewest other players also got right.

**Current state:** Locked state shown (no blur). Preview example shown in greyed-out card.

**To make live:**
- Requires results to be entered in `results` table
- Query: join `predictions` + `results` to find player's correct exact-score predictions
- For each correct prediction, count how many other players predicted the same scoreline
- Surface the one with the lowest count (rarest)
- Display: "Boro 3–1 Derby · Only 2 players called this · Your rarest call"

### Panel 6 — Your Season *(wide)*
**What:** Full-season summary from the player's localStorage predictions — predicted points total, W-D-L record, and season outcome tier.

**Current state:** ✅ Live — reads `boroScores` from localStorage, calculates all-46-game record using `BORO_HOME` array, maps points to tier.

**Tiers:** 100+ → Smash the League · 75+ → Promotion Challenge · 65+ → Play-off Push · 50+ → Mid-table · 40+ → Tough Season · &lt;40 → Relegation Battle

---

## Premium Analyst Mode

**Pricing:** $3/month or $20/season (all 10 monthly skins guaranteed)

Predictions are locked before the season so no pay-to-win. Premium is purely cosmetic + insight.

### Feature Ideas

1. **Monthly Boro skins** — limited drops, e.g. retro kits, iconic eras (Juninho 96/97, Riverside opening). Only active subscribers unlock them. Creates FOMO and a collectible angle.

2. **Community prediction split** — per fixture, before kickoff: 64% home / 22% draw / 14% away. Flips to show actual result after the match.

3. **Bookies vs community overlay** — implied probability from odds (The Odds API) shown alongside what your league predicted. Highlights where the crowd diverges from the market.

4. **Historical H2H facts** — "Boro haven't won at Elland Road since 2012" auto-surfaced on each fixture card. Start with a static dataset, enrich via football-data.org API.

5. **Personal accuracy breakdown** — "You're great at predicting Boro home wins (78%) but terrible away (22%)." Season-long stat card, updates live.

6. **Head-to-head mode** — challenge another player, track who wins each gameweek between you two.

7. **Season trajectory graph** — your points over time vs league average. Basic chart visible to all; detailed drill-down is premium.

8. **Predicted final table** — aggregate all community predictions into a consensus Boro finish position.

9. **Monthly newsletter + Manager of the Month** — top points scorer that calendar month gets the award. Sent to all premium subscribers.

10. **Prediction badges / achievements** — cosmetic, shareable, premium-only. See achievements section below.

---

## Predictor Profile

Based on two axes plotted across the season:

- **Confidence** — how many goals do they predict vs actual average scorelines
- **Optimism** — how often they back Boro vs how Boro actually perform

### Archetypes

| Type | Description |
|---|---|
| **The Romantic** | Always backs Boro, always high-scoring games, perpetually wrong |
| **The Realist** | Tracks the form, picks with head not heart |
| **The Doomer** | Expects the worst, occasionally a genius |
| **The Tactician** | Brilliant at results, terrible on exact scores |
| **The Optimist** | Upgrades every Boro performance by exactly one goal |

Profile card lives on the account page. Shareable as an image. Updates live as predictions vs results accumulate through the season.

---

## Achievements

Earned badges displayed on the ladder (player chooses which to show if they hold multiple). Starts empty — fills as the season progresses.

### Rarity Tiers

**Common** — most players will earn these

| Badge | Trigger |
|---|---|
| **Founder** | Sign up for season 26/27 |
| **Strong Start** | Correct result in first game of the season
| **Manager of the Month** | Win manager of the month award |
| **Off the Mark** | Correct scoreline on any match |
| **Optimist** | Predict Boro get more points than they actually do |
| **Realist** | Predict Boro get within 10 points than they actually do |
| **Mystic** | Predict Boro get the exact number of points |
| **Pessimist** | Predict Boro get less points than they actually do |
| **Champion** | Come first in the final table |
| **Promoted** | Come Second in the final table |
| **Play offs** | Come third, fourth, fifth or sixth in the final table |
| **Relegated** | Finish 22nd, 23rd or 24th in the final table |
| **Full House** | Correct scoreline on Boxing Day |
| **Eye Spy** | Correct scoreline v Southampton |


*More to be added...*

### Schema (additions needed)

```sql
-- Achievement records
CREATE TABLE public.achievements (
  id         SERIAL PRIMARY KEY,
  player_id  UUID REFERENCES public.players(id) ON DELETE CASCADE,
  badge_key  TEXT NOT NULL,
  earned_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Active display badge on ladder
ALTER TABLE public.players ADD COLUMN display_badge TEXT;
```

Ladder VIEW joins on `display_badge` to show chosen badge per row.

---

## Ladder Display

Each row: **Rank / Club badge / Name / Achievement badge / Points**

Achievement badge slot is empty until earned. Once multiple badges are held, player picks which to display from account settings.

---

## Newsletter Stack

- **Resend** — integrates natively with Supabase, supports audience segmentation
- **Supabase Edge Function** — scheduled weekly, queries `results` for that week's scores + `ladder` for standings
- `newsletter_opt_in BOOLEAN DEFAULT TRUE` column on `players` table
- Subscription toggle in `account/index.html`
