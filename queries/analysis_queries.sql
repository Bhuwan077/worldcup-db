-- ============================================================
--  ANALYTICAL QUERIES — FIFA World Cup Modern Era (1990–2022)
--  Run AFTER schema.sql and seed_data.sql
-- ============================================================

USE worldcup_db;

-- ============================================================
-- 1. ALL-TIME TOP SCORERS (modern era)
-- ============================================================
SELECT
    full_name                           AS player,
    country,
    position,
    total_goals,
    total_assists,
    tournaments_played,
    ROUND(total_goals / tournaments_played, 2) AS goals_per_tournament
FROM vw_alltime_top_scorers
LIMIT 20;

-- ============================================================
-- 2. TOURNAMENT CHAMPIONS SUMMARY
-- ============================================================
SELECT
    year,
    host_country,
    champion,
    runner_up,
    third_place,
    total_goals,
    total_matches,
    ROUND(total_goals / total_matches, 2) AS avg_goals_per_match,
    golden_boot,
    golden_ball
FROM tournaments
ORDER BY year;

-- ============================================================
-- 3. MOST SUCCESSFUL COUNTRIES (by wins)
-- ============================================================
SELECT
    country,
    confederation,
    tournaments,
    total_wins,
    total_draws,
    total_losses,
    goals_scored,
    goals_conceded,
    goal_difference,
    ROUND(total_wins / (total_wins + total_draws + total_losses) * 100, 1) AS win_pct,
    best_finish
FROM vw_country_performance
ORDER BY total_wins DESC
LIMIT 15;

-- ============================================================
-- 4. CONFEDERATION PERFORMANCE ANALYSIS
-- ============================================================
SELECT
    c.confederation,
    COUNT(DISTINCT tt.tournament_id)              AS total_participations,
    COUNT(DISTINCT tt.country_id)                 AS distinct_nations,
    SUM(tt.wins)                                  AS total_wins,
    SUM(tt.goals_for)                             AS goals_scored,
    SUM(tt.goals_against)                         AS goals_conceded,
    ROUND(SUM(tt.wins) /
          (SUM(tt.wins)+SUM(tt.draws)+SUM(tt.losses)) * 100, 1) AS win_pct
FROM tournament_teams tt
JOIN countries c ON tt.country_id = c.country_id
GROUP BY c.confederation
ORDER BY win_pct DESC;

-- ============================================================
-- 5. PLAYER CAREER STATS — MESSI vs RONALDO vs KLOSE
-- ============================================================
SELECT
    p.full_name,
    c.name                          AS country,
    COUNT(DISTINCT pts.tournament_id) AS wcs_played,
    SUM(pts.goals)                  AS total_goals,
    SUM(pts.assists)                AS total_assists,
    SUM(pts.matches_played)         AS total_matches,
    SUM(pts.minutes_played)         AS total_minutes,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.matches_played),0), 2) AS goals_per_match,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.minutes_played),0) * 90, 2) AS goals_per_90
FROM player_tournament_stats pts
JOIN players   p ON pts.player_id  = p.player_id
JOIN countries c ON p.country_id   = c.country_id
WHERE p.full_name IN ('Lionel Messi','Cristiano Ronaldo','Miroslav Klose','Kylian Mbappé')
GROUP BY p.player_id
ORDER BY total_goals DESC;

-- ============================================================
-- 6. HOST NATION ADVANTAGE — did hosts perform better?
-- ============================================================
SELECT
    t.year,
    t.host_country,
    c.name   AS host_team,
    tt.final_position,
    tt.wins,
    tt.draws,
    tt.losses,
    tt.goals_for,
    tt.goals_against
FROM tournaments t
JOIN countries c
    ON c.name = t.host_country
   OR (t.year = 2002 AND c.name IN ('South Korea','Japan'))
JOIN tournament_teams tt
    ON tt.tournament_id = t.tournament_id
   AND tt.country_id = c.country_id
ORDER BY t.year;

-- ============================================================
-- 7. GOALS TREND BY TOURNAMENT (avg goals per match over time)
-- ============================================================
SELECT
    year,
    host_country,
    num_teams,
    total_goals,
    total_matches,
    ROUND(total_goals / total_matches, 2) AS avg_goals_per_match
FROM tournaments
ORDER BY year;

-- ============================================================
-- 8. COMEBACK KINGS — matches won from behind (requires goals table data)
-- ============================================================
SELECT
    t.year,
    m.stage,
    h.name  AS home_team,
    m.home_goals,
    m.away_goals,
    a.name  AS away_team,
    CASE
        WHEN m.penalties THEN 'Decided on penalties'
        WHEN m.home_goals > m.away_goals THEN h.name
        ELSE a.name
    END     AS winner,
    m.attendance
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN countries   h ON m.home_team_id  = h.country_id
JOIN countries   a ON m.away_team_id  = a.country_id
WHERE m.stage = 'Final'
ORDER BY t.year;

-- ============================================================
-- 9. PLAYER POSITIONS DISTRIBUTION BY TOURNAMENT
-- ============================================================
SELECT
    t.year,
    p.position,
    COUNT(DISTINCT pts.player_id)  AS players,
    SUM(pts.goals)                 AS goals,
    ROUND(AVG(pts.goals), 2)       AS avg_goals_per_player
FROM player_tournament_stats pts
JOIN players     p ON pts.player_id    = p.player_id
JOIN tournaments t ON pts.tournament_id = t.tournament_id
GROUP BY t.year, p.position
ORDER BY t.year, FIELD(p.position,'FW','MF','DF','GK');

-- ============================================================
-- 10. COUNTRY HEAD-TO-HEAD (example: Argentina vs Brazil)
-- ============================================================
SELECT
    t.year,
    m.stage,
    h.name          AS home,
    m.home_goals,
    m.away_goals,
    a.name          AS away,
    CASE
        WHEN m.home_goals > m.away_goals  THEN h.name
        WHEN m.away_goals > m.home_goals  THEN a.name
        WHEN m.home_pen_score > m.away_pen_score THEN h.name
        WHEN m.away_pen_score > m.home_pen_score THEN a.name
        ELSE 'Draw'
    END             AS winner
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN countries   h ON m.home_team_id  = h.country_id
JOIN countries   a ON m.away_team_id  = a.country_id
WHERE  (h.fifa_code = 'ARG' AND a.fifa_code = 'BRA')
    OR (h.fifa_code = 'BRA' AND a.fifa_code = 'ARG')
ORDER BY t.year;

-- ============================================================
-- 11. GOLDEN BOOT WINNERS ACROSS ALL EDITIONS
-- ============================================================
SELECT
    t.year,
    t.golden_boot AS top_scorer,
    t.champion,
    t.total_goals,
    ROUND(t.total_goals / t.total_matches, 2) AS avg_goals_per_match
FROM tournaments t
ORDER BY t.year;

-- ============================================================
-- 12. AFRICAN NATIONS PERFORMANCE (CAF confederation)
-- ============================================================
SELECT
    cp.country,
    cp.tournaments,
    cp.total_wins,
    cp.total_draws,
    cp.total_losses,
    cp.goals_scored,
    cp.goals_conceded,
    cp.best_finish
FROM vw_country_performance cp
JOIN countries c ON cp.country = c.name
WHERE c.confederation = 'CAF'
ORDER BY cp.total_wins DESC;

-- ============================================================
-- 13. STORED PROCEDURE: get all stats for a given player
-- ============================================================
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS sp_player_career(IN p_name VARCHAR(150))
BEGIN
    SELECT
        p.full_name,
        c.name              AS country,
        p.position,
        t.year,
        pts.matches_played,
        pts.goals,
        pts.assists,
        pts.yellow_cards,
        pts.red_cards,
        pts.minutes_played
    FROM player_tournament_stats pts
    JOIN players     p ON pts.player_id     = p.player_id
    JOIN countries   c ON p.country_id      = c.country_id
    JOIN tournaments t ON pts.tournament_id = t.tournament_id
    WHERE p.full_name LIKE CONCAT('%', p_name, '%')
    ORDER BY t.year;
END$$
DELIMITER ;

-- Usage:
-- CALL sp_player_career('Messi');
-- CALL sp_player_career('Ronaldo');

-- ============================================================
-- 14. STORED PROCEDURE: tournament snapshot
-- ============================================================
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS sp_tournament_snapshot(IN p_year YEAR)
BEGIN
    SELECT
        c.name              AS team,
        c.confederation,
        tt.group_stage,
        tt.final_position,
        tt.wins,
        tt.draws,
        tt.losses,
        tt.goals_for,
        tt.goals_against,
        (tt.goals_for - tt.goals_against) AS gd
    FROM tournament_teams tt
    JOIN countries   c ON tt.country_id    = c.country_id
    JOIN tournaments t ON tt.tournament_id = t.tournament_id
    WHERE t.year = p_year
    ORDER BY tt.final_position;
END$$
DELIMITER ;

-- Usage:
-- CALL sp_tournament_snapshot(2022);
-- CALL sp_tournament_snapshot(2014);
