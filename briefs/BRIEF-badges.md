# Design Brief — Achievement Badges

## Context

Boro Predictor awards achievement badges to players that display on the prediction ladder. Each player earns badges across the season and picks one to show on the table. Currently rendered as a coloured circle + emoji in the browser — this brief is for replacing those with custom SVG icons.

## Where badges appear

- **Ladder table** — small badge column, one per row, ~28×28px rendered size
- **Account page** — badge picker grid (future), larger at ~48×48px
- **Ladder tooltip** — badge name on hover

## Technical format

- SVG, square artboard, ideally 48×48px viewBox
- Must read cleanly at 28px (ladder) and 48px (account picker)
- Saved to `assets/badges/achievements/` — one file per badge, named by key (e.g. `founder.svg`)
- Loaded via the JS `BADGES` array in `ladder/index.html` — currently uses `emoji` + `color` fields; once SVGs are ready the renderer will swap to `<img>` tags

## Brand

- **Palette:** `--red` #C8102E, `--red-dark` #8A0F1F, `--gold` #FFB400, `--black` #1A1A1A, `--white` #FFFFFF
- **Feel:** Bold, flat, confident. Championship football — not Premier League gloss, not Sunday league rough. Think Panini sticker meets modern badge design.
- No gradients needed, flat fill preferred. Thin stroke detail acceptable.

## Badges to design

| Key | Name | Current colour | Suggested direction |
|---|---|---|---|
| `founder` | Founder | Purple #7c3aed | Shield or crest mark — "original member" feel |
| `strong` | Strong Start | Amber #d97706 | Lightning bolt or upward arrow |
| `offmark` | Off the Mark | Red #dc2626 | Target / bullseye |
| `motm` | Manager of the Month | Bronze #b45309 | Clipboard or tactical board |
| `fullhouse` | Full House | Green #16a34a | Snowflake or Christmas tree (Boxing Day) |
| `eyespy` | Eye Spy | Teal #0891b2 | Eye icon |
| `optimist` | Optimist | Orange #ea580c | Sun / sunrise |
| `realist` | Realist | Blue #1d4ed8 | Magnifying glass or scales |
| `mystic` | Mystic | Purple #7c3aed | Crystal ball or star |
| `pessimist` | Pessimist | Dark grey #374151 | Rain cloud |
| `champion` | Champion | Gold #b45309 | Trophy or crown |
| `promoted` | Promoted | Green #16a34a | Rocket or upward arrow (distinct from Strong Start) |
| `playoffs` | Play-Offs | Cyan #0891b2 | Playoff bracket or arena arch |
| `relegated` | Relegated | Dark red #991b1b | Downward arrow or trap door |

## Deliverables

13 SVG files, one per badge. Each should work:
- On a white/light background (account picker)
- On a dark/red background (ladder row if highlighted)

A single-colour or two-colour version is preferable for versatility.

## Nice to have

A blank "locked" badge — empty slot shown before a player earns anything. Currently a grey circle, could be a faint outline crest.
