-- ============================================================
--  VIEWS — FIFA World Cup Modern Era (1990–2022)
--  Run AFTER schema.sql and seed_data.sql
--  Contains all views referenced by top_scorers_queries.sql
-- ============================================================

USE worldcup_db;

-- ============================================================
-- VIEW: vw_top10_scorers_all_time
-- Full ranked list of all-time top scorers with career stats
-- ============================================================
CREATE OR REPLACE VIEW vw_top10_scorers_all_time AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(pts.goals) DESC, SUM(pts.assists) DESC) AS `rank`,
    p.full_name                                   AS player,
    c.name                                        AS country,
    c.confederation,
    p.position,
    COUNT(DISTINCT pts.tournament_id)             AS world_cups,
    SUM(pts.matches_played)                       AS total_matches,
    SUM(pts.goals)                                AS total_goals,
    SUM(pts.assists)                              AS total_assists,
    SUM(pts.goals) + SUM(pts.assists)             AS goal_contributions,
    SUM(pts.yellow_cards)                         AS yellow_cards,
    SUM(pts.red_cards)                            AS red_cards,
    SUM(pts.minutes_played)                       AS total_minutes,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.matches_played), 0), 3)  AS goals_per_match,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.minutes_played), 0) * 90, 2) AS goals_per_90,
    MIN(t.year)                                   AS first_wc,
    MAX(t.year)                                   AS last_wc
FROM player_tournament_stats pts
JOIN players     p  ON pts.player_id     = p.player_id
JOIN countries   c  ON p.country_id      = c.country_id
JOIN tournaments t  ON pts.tournament_id = t.tournament_id
GROUP BY p.player_id, p.full_name, c.name, c.confederation, p.position
ORDER BY total_goals DESC, total_assists DESC;

-- ============================================================
-- VIEW: vw_top_scorers_by_tournament
-- Best scorers broken down per individual tournament
-- ============================================================
CREATE OR REPLACE VIEW vw_top_scorers_by_tournament AS
SELECT
    ROW_NUMBER() OVER (
        PARTITION BY pts.tournament_id
        ORDER BY pts.goals DESC, pts.assists DESC
    )                                             AS rank_in_tournament,
    p.full_name                                   AS player,
    c.name                                        AS country,
    c.confederation,
    p.position,
    t.year                                        AS world_cup_year,
    t.host_country,
    pts.matches_played,
    pts.goals,
    pts.assists,
    pts.yellow_cards,
    pts.red_cards,
    pts.minutes_played,
    ROUND(pts.goals /
          NULLIF(pts.matches_played, 0), 2)       AS goals_per_match,
    ROUND(pts.goals /
          NULLIF(pts.minutes_played, 0) * 90, 2)  AS goals_per_90
FROM player_tournament_stats pts
JOIN players     p  ON pts.player_id     = p.player_id
JOIN countries   c  ON p.country_id      = c.country_id
JOIN tournaments t  ON pts.tournament_id = t.tournament_id
ORDER BY t.year, pts.goals DESC;

-- ============================================================
-- VIEW: vw_goals_with_match_context
-- Every goal log entry enriched with match and player details
-- Used by Q6 (finals goals) and Q11 (penalty/OG breakdown)
-- ============================================================
CREATE OR REPLACE VIEW vw_goals_with_match_context AS
SELECT
    t.year                                        AS world_cup,
    t.host_country,
    m.match_id,
    m.match_date,
    m.stage,
    m.group_label,
    h.name                                        AS home_team,
    m.home_goals,
    m.away_goals,
    a.name                                        AS away_team,
    m.attendance,
    g.goal_id,
    g.minute,
    p.full_name                                   AS scorer,
    c.name                                        AS scorer_country,
    p.position                                    AS scorer_position,
    g.is_penalty,
    g.is_own_goal,
    g.is_extra_time,
    CASE
        WHEN g.is_penalty    THEN 'Penalty'
        WHEN g.is_own_goal   THEN 'Own Goal'
        WHEN g.is_extra_time THEN 'Extra Time'
        ELSE 'Open Play'
    END                                           AS goal_type
FROM goals g
JOIN matches     m  ON g.match_id   = m.match_id
JOIN tournaments t  ON m.tournament_id = t.tournament_id
JOIN countries   h  ON m.home_team_id  = h.country_id
JOIN countries   a  ON m.away_team_id  = a.country_id
JOIN players     p  ON g.player_id     = p.player_id
JOIN countries   c  ON p.country_id    = c.country_id
ORDER BY t.year, m.match_date, g.minute;
