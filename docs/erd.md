# Entity-Relationship Diagram — FIFA World Cup DB

## Tables & Relationships

```
tournaments
  PK: tournament_id
  ├── year, host_country, host_continent
  ├── start_date, end_date, num_teams
  ├── champion, runner_up, third_place, fourth_place
  ├── total_goals, total_matches
  └── golden_ball, golden_boot, golden_glove

countries
  PK: country_id
  ├── name, fifa_code (UNIQUE)
  └── confederation (UEFA/CONMEBOL/CAF/AFC/CONCACAF/OFC)

tournament_teams  [junction: tournaments ↔ countries]
  PK: id
  FK: tournament_id → tournaments
  FK: country_id    → countries
  └── group_stage, final_position, wins, draws, losses, goals_for, goals_against

stadiums
  PK: stadium_id
  FK: country_id → countries
  └── name, city, capacity

matches
  PK: match_id
  FK: tournament_id → tournaments
  FK: stadium_id    → stadiums
  FK: home_team_id  → countries
  FK: away_team_id  → countries
  └── match_date, stage, group_label
      home_goals, away_goals, home_goals_et, away_goals_et
      penalties, home_pen_score, away_pen_score, attendance

players
  PK: player_id
  FK: country_id → countries
  └── full_name, date_of_birth, position (GK/DF/MF/FW)

player_tournament_stats  [junction: players ↔ tournaments]
  PK: id
  FK: player_id     → players
  FK: tournament_id → tournaments
  └── matches_played, goals, assists, yellow_cards, red_cards, minutes_played

goals
  PK: goal_id
  FK: match_id  → matches
  FK: player_id → players
  └── minute, is_penalty, is_own_goal, is_extra_time

cards
  PK: card_id
  FK: match_id  → matches
  FK: player_id → players
  └── card_type (Yellow/Second Yellow/Red), minute
```

## Relationship Map

```
tournaments ──────< tournament_teams >────── countries
     │                                           │
     │                                           │
     └──────────< matches >──────────────────────┤
                    │    │                       │
                    │    └──< goals >── players >─┤
                    │    └──< cards >── players >─┘
                    │
                 stadiums ──────────────────── countries


players ─────< player_tournament_stats >──── tournaments
```

## Cardinality

| Relationship | Type | Notes |
|---|---|---|
| tournaments → tournament_teams | 1:M | One WC has many team entries |
| countries → tournament_teams | 1:M | One country appears in many WCs |
| tournaments → matches | 1:M | One WC has many matches |
| countries → matches (home/away) | 1:M | One country plays many matches |
| stadiums → matches | 1:M | One stadium hosts many matches |
| players → goals | 1:M | One player scores many goals |
| matches → goals | 1:M | One match has many goals |
| players → cards | 1:M | One player receives many cards |
| matches → cards | 1:M | One match has many cards |
| players → player_tournament_stats | 1:M | One player has stats across WCs |
| tournaments → player_tournament_stats | 1:M | One WC has stats for many players |

## ENUM Types

| Column | Values |
|---|---|
| `countries.confederation` | UEFA, CONMEBOL, CAF, AFC, CONCACAF, OFC |
| `players.position` | GK, DF, MF, FW |
| `matches.stage` | Group, Round of 16, Quarter-final, Semi-final, Third Place, Final |
| `cards.card_type` | Yellow, Second Yellow, Red |

## Key Design Decisions

- **`tournament_teams`** is a junction table storing per-edition team statistics. Avoids bloating the countries table with repeated stats.
- **`player_tournament_stats`** stores aggregated stats per player per WC. This enables fast analytical queries (top scorers, career totals) without scanning the raw goals table.
- **`goals`** stores individual goal events for granular analysis (penalties, own goals, extra time). Both tables can coexist — stats for quick queries, goals for deep dives.
- **`matches.home_team_id / away_team_id`** both reference `countries`, not `tournament_teams`, to support matches where team labels are arbitrary (host vs visitor).
- All tables use `ENGINE=InnoDB` for FK enforcement and ACID compliance.
- `utf8mb4` charset ensures player names with accents and special characters render correctly.
