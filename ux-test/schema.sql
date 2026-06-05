-- ── Initial table (run once) ─────────────────────────────────────────────────

create table ux_votes (
  id                   uuid        default gen_random_uuid() primary key,
  preference           text        not null check (preference in ('A', 'B')),
  first_card_touched   text        check (first_card_touched in ('A', 'B')),
  interactions_a       integer     default 0,
  interactions_b       integer     default 0,
  corrections_a        integer     default 0,
  corrections_b        integer     default 0,
  interacted_both      boolean     default false,
  time_to_complete_ms  integer,
  viewport_width       integer,
  option_a_side        text        check (option_a_side in ('left', 'right')),
  created_at           timestamptz default now()
);

alter table ux_votes enable row level security;

create policy "public insert" on ux_votes for insert with check (true);
create policy "public read"   on ux_votes for select using (true);


-- ── Migration (if table already exists from v1) ───────────────────────────────

alter table ux_votes
  add column if not exists first_card_touched  text    check (first_card_touched in ('A', 'B')),
  add column if not exists interactions_a      integer default 0,
  add column if not exists interactions_b      integer default 0,
  add column if not exists corrections_a       integer default 0,
  add column if not exists corrections_b       integer default 0,
  add column if not exists interacted_both     boolean default false,
  add column if not exists time_to_complete_ms integer,
  add column if not exists viewport_width      integer,
  add column if not exists option_a_side       text    check (option_a_side in ('left', 'right'));


-- ── Useful queries ────────────────────────────────────────────────────────────

-- Overall preference tally
select preference, count(*) from ux_votes group by preference;

-- Preference split by which side A was shown on (checks for position bias)
select option_a_side, preference, count(*)
from ux_votes group by option_a_side, preference order by option_a_side, preference;

-- Did people interact with both cards before choosing?
select interacted_both, preference, count(*)
from ux_votes group by interacted_both, preference;

-- Which card was touched first, and did that predict their vote?
select first_card_touched, preference, count(*)
from ux_votes group by first_card_touched, preference;

-- Average interactions and corrections per card
select
  round(avg(interactions_a))  as avg_taps_a,
  round(avg(interactions_b))  as avg_taps_b,
  round(avg(corrections_a))   as avg_corrections_a,
  round(avg(corrections_b))   as avg_corrections_b,
  round(avg(time_to_complete_ms) / 1000) as avg_seconds
from ux_votes;
