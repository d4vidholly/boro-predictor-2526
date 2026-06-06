# BADGES.md

Achievement badges for the 2026/27 season. Earned badges display on the ladder — player chooses which to show if they hold multiple.

For schema changes needed, see `ROADMAP.md` → Achievements → Schema.

---

## Status key

- `pending` — not yet implemented
- `done` — awarded and displaying

---

## Common

| Badge | Key | Trigger | Status |
|---|---|---|---|
| Founder | `founder` | Sign up for season 26/27 | `pending` |
| Strong Start | `strong` | Correct result in first game of the season | `pending` |
| Off the Mark | `offmark` | Correct scoreline on any match | `pending` |
| Manager of the Month | `motm` | Win manager of the month award | `pending` |
| Full House | `fullhouse` | Correct scoreline on Boxing Day | `pending` |
| Eye Spy | `eyespy` | Correct scoreline v Southampton | `pending` |

## Fan Profile

Awarded based on predicted vs actual Boro points at season end.

| Badge | Key | Trigger | Status |
|---|---|---|---|
| Optimist | `optimist` | Predicted Boro points > actual | `pending` |
| Realist | `realist` | Predicted within 10 pts of actual | `pending` |
| Mystic | `mystic` | Predicted Boro exact points total | `pending` |
| Pessimist | `pessimist` | Predicted Boro points < actual | `pending` |

## Final Table

Awarded based on where the player finishes in the prediction ladder.

| Badge | Key | Trigger | Status |
|---|---|---|---|
| Champion | `champion` | 1st in final ladder | `pending` |
| Promoted | `promoted` | 2nd in final ladder | `pending` |
| Play-Offs | `playoffs` | 3rd–6th in final ladder | `pending` |
| Relegated | `relegated` | 22nd–24th in final ladder | `pending` |

---

## Notes

- Badge IDs in the JS `BADGES` array (`ladder/index.html`) must match the `Key` column above exactly.
- `display_badge` column exists on `players` table — player selects active badge from account page.
- `achievements` table records earned badges with `earned_at` timestamp.
- More badges TBC — see ROADMAP.md for ideas in progress.
