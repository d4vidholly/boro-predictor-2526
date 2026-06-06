# Design Brief — The Boro Gazette Artwork

## Context

After entering all 46 predictions, players tap "Report" to open a newspaper modal called **The Boro Gazette**. It shows a mock front page with a headline, season review article, and an image that reflects how Boro finished.

Currently the image slot uses stock photos (`boro-paper.webp`, `boro-promotion.webp`, etc.) which carry licensing risk. This brief is for replacing all five images with original custom illustrations.

## Where artwork appears

- **Predict page** → Report modal → `#summary-img` element
- Displayed inside `.paper-image-frame` — a portrait frame styled to look like a newspaper photo
- Rendered at roughly **280×200px** on mobile, slightly wider on desktop
- Has a `.paper-caption` line beneath it (supplied by JS, not part of the image)

## Five images needed — one per outcome tier

| File to replace | Tier | Points | Headline (for reference) |
|---|---|---|---|
| `boro-paper.webp` | Smash the League (100+ pts) | 100+ | "Brilliant Boro finally 'Smash the League'" |
| `boro-promotion.webp` | Promotion Challenge (75–99 pts) | 75–99 | "Strong Season for Boro as Promotion Dream Stays Alive" |
| `boro-playoffs.webp` | Play-Off Push (65–74 pts) | 65–74 | "Boro End Well and Truly in the Play-Off Mix" |
| `boro-paper.webp` | Mid-Table (50–64 pts) | 50–64 | "Inconsistent Boro Make Do with Mid-Table Mediocrity" — *same file as tier 1, needs its own* |
| `boro-relegation.webp` | Tough Season (40–49 pts) | 40–49 | "A Season to Forget for Sorry Boro" |
| `boro-disaster.jpg` | Relegation Battle (<40 pts) | <40 | "Nightmare Season Ends in Disbelief for Boro" |

> Note: mid-table currently reuses the smash-the-league image — it should get its own file.

## Suggested filenames (to replace existing)

```
assets/boro-smash.webp       ← replaces boro-paper.webp (tier 1)
assets/boro-promotion.webp   ← same filename, new art
assets/boro-playoffs.webp    ← same filename, new art
assets/boro-midtable.webp    ← new file (currently no dedicated image)
assets/boro-relegation.webp  ← same filename, new art
assets/boro-disaster.webp    ← replaces boro-disaster.jpg
```

The JS in `predict/index.html` (`calculatePoints()`) references these paths directly — update the `summaryImg` strings once new files are named.

## Style direction

**The frame is a newspaper photo** — the artwork should feel like an editorial illustration or sports cartoon, not a photograph. Think match-day programme illustration, vintage football poster, or bold editorial graphic.

- Flat or semi-flat illustration preferred
- Boro colours: red `#C8102E`, white, black. Gold `#FFB400` as accent.
- No real player likenesses (licensing). Abstract figures, the Riverside silhouette, crowds, trophies, fire/rain motifs are all fine.
- Each image should visually communicate the season outcome at a glance — euphoric vs forgettable

## Mood per tier

| Tier | Mood | Visual ideas |
|---|---|---|
| Smash the League | Euphoric, historic | Trophy lift silhouette, confetti, packed Riverside, banner reading "Champions" |
| Promotion Challenge | Hopeful, exciting | Player pointing upward, promotion arrow, red flares, "Wembley" sign |
| Play-Off Push | Tense, dramatic | Two teams at a fork in the road, play-off bracket graphic, dramatic lighting |
| Mid-Table | Shrug, meh | Half-empty stadium, player with hands on hips, grey skies, mediocre scoreboard |
| Tough Season | Deflated | Head-in-hands figure, sparsely attended away end, rain, nil-nil scoreboard |
| Relegation Battle | Disbelief, dark | Trapdoor opening, sinking ship, manager with head down, ominous sky |

## Deliverables

6 illustrations, exported as `.webp` at 2× resolution (560×400px or similar) for crispness at the ~280px rendered size. Transparent or white background — the frame clips the image.

## Notes

- The modal has a vintage newspaper look (serif font, ruled lines, masthead). Artwork should complement that — editorial illustration fits better than a modern flat design.
- Caption text is rendered separately in HTML — don't include caption text in the artwork itself.
