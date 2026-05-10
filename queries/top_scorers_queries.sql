-- ============================================================
--  TOP 10 WORLD CUP SCORERS — QUICK REFERENCE CHEAT SHEET
--  FIFA World Cup Modern Era | MySQL
-- ============================================================

USE worldcup_db;

-- ╔══════════════════════════════════════════════════════════╗
-- ║         WORLD CUP ALL-TIME TOP 10 SCORERS               ║
-- ║  (Modern Era 1990–2022 data; historical records noted)  ║
-- ╚══════════════════════════════════════════════════════════╝
--
--  Rank │ Player               │ Country    │ Goals │ WCs
--  ─────┼──────────────────────┼────────────┼───────┼────
--   1   │ Miroslav Klose       │ Germany    │  16   │  4
--   2   │ Ronaldo Nazário      │ Brazil     │  15   │  4
--   3   │ Lionel Messi         │ Argentina  │  13   │  5
--   4   │ Kylian Mbappé        │ France     │  12   │  2 (active)
--   5   │ Jürgen Klinsmann     │ Germany    │  11   │  3
--   6   │ Davor Šuker          │ Croatia    │   6   │  1 (modern)
--       │ Harry Kane           │ England    │   6*  │  2 (active)
--       │ Salvatore Schillaci  │ Italy      │   6   │  1
--       │ James Rodríguez      │ Colombia   │   6   │  2
--       │ Cristiano Ronaldo    │ Portugal   │   8   │  5
-- ──────────────────────────────────────────────────────────

-- ============================================================
-- Q1: FULL TOP 10 WITH ALL STATS
-- ============================================================
SELECT * FROM vw_top10_scorers_all_time;

-- ============================================================
-- Q2: KLOSE vs RONALDO vs MESSI vs MBAPPÉ — head to head
-- ============================================================
SELECT
    p.full_name                                  AS player,
    c.name                                       AS country,
    COUNT(DISTINCT pts.tournament_id)            AS world_cups,
    SUM(pts.matches_played)                      AS matches,
    SUM(pts.goals)                               AS goals,
    SUM(pts.assists)                             AS assists,
    SUM(pts.goals) + SUM(pts.assists)            AS goal_contributions,
    ROUND(SUM(pts.goals)/SUM(pts.matches_played),3) AS goals_per_match,
    ROUND(SUM(pts.goals)/SUM(pts.minutes_played)*90,2) AS per_90,
    MIN(t.year)                                  AS first_wc,
    MAX(t.year)                                  AS last_wc
FROM player_tournament_stats pts
JOIN players     p  ON pts.player_id     = p.player_id
JOIN countries   c  ON p.country_id      = c.country_id
JOIN tournaments t  ON pts.tournament_id = t.tournament_id
WHERE p.full_name IN ('Miroslav Klose','Ronaldo Nazário','Lionel Messi','Kylian Mbappé')
GROUP BY p.player_id
ORDER BY goals DESC;

-- ============================================================
-- Q3: MESSI'S FULL CAREER BREAKDOWN — tournament by tournament
-- ============================================================
CALL sp_scorer_career('Messi');

-- ============================================================
-- Q4: KLOSE'S RECORD-BREAKING CAREER
-- ============================================================
CALL sp_scorer_career('Klose');

-- ============================================================
-- Q5: MBAPPÉ — youngest top scorer trajectory
-- ============================================================
CALL sp_scorer_career('Mbappé');

-- ============================================================
-- Q6: GOALS SCORED IN WORLD CUP FINALS
-- ============================================================
SELECT
    world_cup,
    home_team, home_goals, away_goals, away_team,
    scorer, scorer_country,
    minute,
    CASE WHEN is_penalty   THEN '✓' ELSE '-' END AS pen,
    CASE WHEN is_extra_time THEN '✓' ELSE '-' END AS aet
FROM vw_goals_with_match_context
WHERE stage = 'Final'
ORDER BY world_cup, minute;

-- ============================================================
-- Q7: PLAYERS WHO SCORED IN MULTIPLE TOURNAMENTS
-- ============================================================
SELECT
    p.full_name     AS player,
    c.name          AS country,
    COUNT(DISTINCT pts.tournament_id) AS tournaments_scored_in,
    SUM(pts.goals)  AS total_goals,
    GROUP_CONCAT(t.year ORDER BY t.year SEPARATOR ', ') AS years_scored
FROM player_tournament_stats pts
JOIN players     p  ON pts.player_id    = p.player_id
JOIN countries   c  ON p.country_id     = c.country_id
JOIN tournaments t  ON pts.tournament_id = t.tournament_id
WHERE pts.goals > 0
GROUP BY p.player_id
HAVING tournaments_scored_in >= 2
ORDER BY tournaments_scored_in DESC, total_goals DESC;

-- ============================================================
-- Q8: GOLDEN BOOT TRACKER — top scorer each year
-- ============================================================
SELECT
    t.year,
    t.host_country,
    t.golden_boot AS winner,
    t.champion    AS tournament_winner,
    CASE WHEN t.golden_boot LIKE '%' || t.champion || '%'
         THEN 'Champion team' ELSE 'Non-champion team' END AS scorer_team_status
FROM tournaments t
ORDER BY t.year;

-- ============================================================
-- Q9: MOST GOALS IN A SINGLE TOURNAMENT (player level)
-- ============================================================
SELECT
    player,
    country,
    world_cup_year AS year,
    host_country,
    goals          AS goals_in_tournament,
    assists,
    matches_played,
    ROUND(goals/matches_played,2) AS goals_per_match
FROM vw_top_scorers_by_tournament
ORDER BY goals DESC
LIMIT 20;

-- ============================================================
-- Q10: CONFEDERATION REPRESENTATION IN TOP SCORERS
-- ============================================================
SELECT
    c.confederation,
    COUNT(DISTINCT p.player_id)      AS players,
    SUM(pts.goals)                   AS total_goals,
    ROUND(AVG(pts.goals),2)          AS avg_goals_per_player_per_wc
FROM player_tournament_stats pts
JOIN players   p ON pts.player_id  = p.player_id
JOIN countries c ON p.country_id   = c.country_id
GROUP BY c.confederation
ORDER BY total_goals DESC;

-- ============================================================
-- Q11: PENALTIES AND SPECIAL GOALS BREAKDOWN
-- ============================================================
SELECT
    p.full_name                                   AS scorer,
    c.name                                        AS country,
    COUNT(*)                                      AS total_goals_logged,
    SUM(CASE WHEN g.is_penalty   = TRUE THEN 1 ELSE 0 END) AS penalties,
    SUM(CASE WHEN g.is_own_goal  = TRUE THEN 1 ELSE 0 END) AS own_goals,
    SUM(CASE WHEN g.is_extra_time= TRUE THEN 1 ELSE 0 END) AS extra_time_goals
FROM goals g
JOIN players   p ON g.player_id = p.player_id
JOIN countries c ON p.country_id= c.country_id
GROUP BY p.player_id
ORDER BY total_goals_logged DESC;

-- ============================================================
-- Q12: MATCHES WHERE TOP SCORERS PLAYED — with result
-- ============================================================
SELECT
    t.year,
    mr.stage,
    mr.match_date,
    mr.home_team,
    mr.home_goals,
    mr.away_goals,
    mr.away_team,
    mr.attendance,
    CASE
        WHEN mr.home_goals > mr.away_goals THEN mr.home_team
        WHEN mr.away_goals > mr.home_goals THEN mr.away_team
        WHEN mr.penalties AND mr.home_pen_score > mr.away_pen_score THEN mr.home_team
        WHEN mr.penalties AND mr.away_pen_score > mr.home_pen_score THEN mr.away_team
        ELSE 'Draw'
    END AS winner
FROM vw_match_results mr
JOIN tournaments t ON mr.year = t.year
WHERE mr.stage IN ('Final','Semi-final','Quarter-final')
ORDER BY mr.year, mr.match_date;
