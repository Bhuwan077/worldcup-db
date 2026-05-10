# ⚽ FIFA World Cup Database (1990–2022)

![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-blue?logo=mysql)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

A well-structured, professional MySQL database covering the **FIFA World Cup modern era (1990–2022)**. Designed as a portfolio project demonstrating relational database design, normalization, data analysis, and SQL best practices.

---

## 📁 Project Structure

```
worldcup_db/
├── schema/
│   ├── schema.sql              # Tables, base views, foreign keys
│   ├── views.sql               # Extended views (top scorers, goals context)
│   └── stored_procedures.sql  # 5 reusable stored procedures
├── data/
│   ├── seed_data.sql           # Core: tournaments, countries, players, stats
│   ├── extended_seed_data.sql  # All 9 tournament_teams, goals, cards, stadiums
│   └── top10_scorers_complete.sql  # Match data for top scorer analysis (FIXED)
├── queries/
│   ├── analysis_queries.sql    # 14 analytical queries
│   └── top_scorers_queries.sql # 12 top scorer queries
├── docs/
│   └── erd.md                  # Entity-Relationship diagram & design notes
├── .gitignore
└── README.md
```

---

## 🗄️ Database Design

### Entity-Relationship Overview

```
tournaments ──< tournament_teams >── countries
    │                                    │
    └──< matches >──────────────────────-┤
              │                          │
              ├──< goals >── players >───┘
              └──< cards >── players
                   │
                stadiums

players ──< player_tournament_stats >── tournaments
```

### Tables

| Table | Description | Records |
|---|---|---|
| `tournaments` | One row per World Cup edition (1990–2022) | 9 |
| `countries` | All national teams with FIFA codes & confederation | 60+ |
| `tournament_teams` | Participation: group, position, W/D/L, goals | 70+ |
| `stadiums` | Venues with capacity and host country | 19 |
| `matches` | Key matches with score, stage, attendance | 100+ |
| `players` | Player registry with position and nationality | 30 |
| `player_tournament_stats` | Aggregated stats per player per tournament | 50+ |
| `goals` | Individual goal log (minute, penalty, OG flags) | 20+ |
| `cards` | Yellow/red cards per match | 5+ |

### Views

| View | Purpose |
|---|---|
| `vw_alltime_top_scorers` | Career totals ranked by goals |
| `vw_top10_scorers_all_time` | Full ranked list with goals per 90 (window function) |
| `vw_top_scorers_by_tournament` | Best scorers broken down per tournament |
| `vw_goals_with_match_context` | Every goal enriched with match and player details |
| `vw_country_performance` | Country summary across all editions |
| `vw_match_results` | Human-readable match results with team names |

### Stored Procedures

| Procedure | Usage |
|---|---|
| `sp_player_career(name)` | Full career stats for any player |
| `sp_scorer_career(name)` | Career stats with goals per 90 |
| `sp_tournament_snapshot(year)` | All team standings for a given World Cup |
| `sp_head_to_head(code1, code2)` | All WC meetings between two nations |
| `sp_country_history(code)` | All tournament appearances for a country |

---

## 🚀 Quick Start

### Prerequisites
- MySQL 8.0+ (or MariaDB 10.5+)

### Setup — Run files in this exact order

```bash
# 1. Schema (tables + base views)
mysql -u root -p < schema/schema.sql

# 2. Core seed data
mysql -u root -p worldcup_db < data/seed_data.sql

# 3. Extended data (all 9 tournament_teams, goals, stadiums)
mysql -u root -p worldcup_db < data/extended_seed_data.sql

# 4. Top scorer match data
mysql -u root -p worldcup_db < data/top10_scorers_complete.sql

# 5. Extended views
mysql -u root -p worldcup_db < schema/views.sql

# 6. Stored procedures
mysql -u root -p worldcup_db < schema/stored_procedures.sql
```

### Verify

```sql
USE worldcup_db;
SELECT COUNT(*) FROM tournaments;       -- 9
SELECT COUNT(*) FROM countries;         -- 60+
SELECT COUNT(*) FROM tournament_teams;  -- 70+
SELECT * FROM vw_top10_scorers_all_time LIMIT 5;
```

---

## 📊 Sample Queries

```sql
-- All-time top scorers
SELECT `rank`, player, country, total_goals, goals_per_match
FROM vw_top10_scorers_all_time LIMIT 10;

-- Messi vs Ronaldo vs Klose vs Mbappé
CALL sp_scorer_career('Messi');
CALL sp_scorer_career('Klose');

-- 2022 Final goals
SELECT world_cup, scorer, scorer_country, minute, goal_type
FROM vw_goals_with_match_context WHERE stage = 'Final' AND world_cup = 2022;

-- Head to head
CALL sp_head_to_head('ARG', 'BRA');

-- Full tournament standings
CALL sp_tournament_snapshot(2022);
```

---

## 💡 Key SQL Concepts Demonstrated

| Concept | Where Used |
|---|---|
| **Normalization (3NF)** | Separate tables for countries, players, tournaments |
| **Foreign Keys** | All relationships enforced via FK constraints |
| **ENUM types** | `stage`, `position`, `confederation`, `card_type` |
| **Window functions** | `ROW_NUMBER() OVER()` in `vw_top10_scorers_all_time` |
| **Views** | 6 views from simple lookups to multi-join aggregates |
| **Stored Procedures** | 5 procedures with IN parameters |
| **Aggregate functions** | SUM, COUNT, AVG, ROUND, NULLIF |
| **JOINs** | INNER, LEFT JOIN throughout |
| **CASE expressions** | Winner calculation, goal type classification |
| **GROUP_CONCAT** | Multi-year scoring history |

---

## 🗺️ Roadmap

- [x] 9 normalized tables with FK constraints
- [x] All 9 World Cup tournaments seeded
- [x] 30 key players with full career stats
- [x] tournament_teams for all 9 editions
- [x] All 9 World Cup Finals in matches table
- [x] Goals and cards log
- [x] 6 analytical views incl. window functions
- [x] 5 stored procedures
- [x] 26 total analytical queries
- [ ] Full match data for all 64 matches per tournament
- [ ] Complete per-match goal log
- [ ] Managers/coaching staff table
- [ ] Referee table
- [ ] Python CSV/Excel export script

---

## 📄 License

[MIT](https://choosealicense.com/licenses/mit/)

> *Built as a portfolio project to demonstrate relational database design, MySQL proficiency, and data analytics skills.*
