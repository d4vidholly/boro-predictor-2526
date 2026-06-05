# UX Testing Log

## Test 1 — Card Layout Preference
**Page:** `/ux-test/`
**Status:** Live
**URL:** https://d4vidholly.github.io/Boro-Predictor-2526/ux-test/

### What we're testing
Two fixture card layouts for entering score predictions:
- **Option A** — vertical layout (badge + team name on left, score controls on right, per row)
- **Option B** — horizontal layout (badges on outer edges, score controls in the centre)

Both cards are otherwise identical: same colour-coded result tab, same +/− buttons, same grey badge placeholder.

### Why
Before building the full 46-fixture predictor, we want to know which input pattern feels more natural to users — particularly on mobile.

### Method
- Users are shown both cards side by side (desktop) or stacked (mobile)
- Cards are randomly assigned left/right position each session to neutralise position bias
- Users enter a score on each card independently, then tap Select + Submit
- Results are stored anonymously in Supabase

### What we're measuring

| Metric | Signal |
|---|---|
| `preference` | Stated favourite (A or B) |
| `first_card_touched` | Which layout drew attention first |
| `interactions_a / b` | Engagement — how much each card was used |
| `corrections_a / b` | Reversed taps — proxy for button confusion |
| `interacted_both` | Did they try both before deciding |
| `time_to_complete_ms` | How long the task took |
| `viewport_width` | Desktop vs mobile split |
| `option_a_side` | Controls for left/right position bias |

### Viewing results
Run in Supabase SQL Editor:

```sql
-- Overall tally
select preference, count(*) from ux_votes group by preference;

-- Which card was touched first vs how they voted
select first_card_touched, preference, count(*)
from ux_votes group by first_card_touched, preference;

-- Average taps and corrections per card
select
  round(avg(interactions_a))  as avg_taps_a,
  round(avg(interactions_b))  as avg_taps_b,
  round(avg(corrections_a))   as avg_corrections_a,
  round(avg(corrections_b))   as avg_corrections_b,
  round(avg(time_to_complete_ms) / 1000) as avg_seconds
from ux_votes;

-- Check for position bias (does left/right affect the vote?)
select option_a_side, preference, count(*)
from ux_votes group by option_a_side, preference order by option_a_side;
```

### Findings
_To be completed once responses come in._

---
