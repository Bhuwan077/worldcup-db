-- ============================================================
--  STORED PROCEDURES — FIFA World Cup Modern Era (1990–2022)
--  Run AFTER schema.sql, seed_data.sql, and views.sql
-- ============================================================

USE worldcup_db;

-- ============================================================
-- SP 1: sp_player_career
-- Get full tournament-by-tournament stats for any player
-- Usage: CALL sp_player_career('Messi');
-- ============================================================
DROP PROCEDURE IF EXISTS sp_player_career;
DELIMITER $$
CREATE PROCEDURE sp_player_career(IN p_name VARCHAR(150))
BEGIN
    SELECT
        p.full_name,
        c.name              AS country,
        p.position,
        t.year,
        t.host_country,
        pts.matches_played,
        pts.goals,
        pts.assists,
        pts.yellow_cards,
        pts.red_cards,
        pts.minutes_played,
        ROUND(pts.goals / NULLIF(pts.matches_played, 0), 2) AS goals_per_match
    FROM player_tournament_stats pts
    JOIN players     p  ON pts.player_id     = p.player_id
    JOIN countries   c  ON p.country_id      = c.country_id
    JOIN tournaments t  ON pts.tournament_id = t.tournament_id
    WHERE p.full_name LIKE CONCAT('%', p_name, '%')
    ORDER BY t.year;
END$$
DELIMITER ;

-- ============================================================
-- SP 2: sp_scorer_career
-- Alias for sp_player_career (used in top_scorers_queries.sql)
-- Usage: CALL sp_scorer_career('Klose');
-- ============================================================
DROP PROCEDURE IF EXISTS sp_scorer_career;
DELIMITER $$
CREATE PROCEDURE sp_scorer_career(IN p_name VARCHAR(150))
BEGIN
    SELECT
        p.full_name,
        c.name              AS country,
        p.position,
        t.year,
        t.host_country,
        pts.matches_played,
        pts.goals,
        pts.assists,
        pts.yellow_cards,
        pts.red_cards,
        pts.minutes_played,
        ROUND(pts.goals / NULLIF(pts.matches_played, 0), 2) AS goals_per_match,
        ROUND(pts.goals / NULLIF(pts.minutes_played, 0) * 90, 2) AS goals_per_90
    FROM player_tournament_stats pts
    JOIN players     p  ON pts.player_id     = p.player_id
    JOIN countries   c  ON p.country_id      = c.country_id
    JOIN tournaments t  ON pts.tournament_id = t.tournament_id
    WHERE p.full_name LIKE CONCAT('%', p_name, '%')
    ORDER BY t.year;
END$$
DELIMITER ;

-- ============================================================
-- SP 3: sp_tournament_snapshot
-- Full team standings for any given World Cup year
-- Usage: CALL sp_tournament_snapshot(2022);
-- ============================================================
DROP PROCEDURE IF EXISTS sp_tournament_snapshot;
DELIMITER $$
CREATE PROCEDURE sp_tournament_snapshot(IN p_year YEAR)
BEGIN
    SELECT
        c.name              AS team,
        c.confederation,
        tt.group_stage      AS `group`,
        tt.final_position   AS position,
        tt.matches_played,
        tt.wins,
        tt.draws,
        tt.losses,
        tt.goals_for        AS gf,
        tt.goals_against    AS ga,
        (tt.goals_for - tt.goals_against) AS gd,
        (tt.wins * 3 + tt.draws)          AS points
    FROM tournament_teams tt
    JOIN countries   c  ON tt.country_id    = c.country_id
    JOIN tournaments t  ON tt.tournament_id = t.tournament_id
    WHERE t.year = p_year
    ORDER BY tt.group_stage, tt.final_position;
END$$
DELIMITER ;

-- ============================================================
-- SP 4: sp_head_to_head
-- All World Cup meetings between two nations
-- Usage: CALL sp_head_to_head('ARG', 'BRA');
-- ============================================================
DROP PROCEDURE IF EXISTS sp_head_to_head;
DELIMITER $$
CREATE PROCEDURE sp_head_to_head(IN team1 CHAR(3), IN team2 CHAR(3))
BEGIN
    SELECT
        t.year,
        m.stage,
        m.match_date,
        h.name              AS home_team,
        m.home_goals,
        m.away_goals,
        a.name              AS away_team,
        CASE
            WHEN m.penalties AND m.home_pen_score > m.away_pen_score THEN CONCAT(h.name, ' (pens)')
            WHEN m.penalties AND m.away_pen_score > m.home_pen_score THEN CONCAT(a.name, ' (pens)')
            WHEN m.home_goals > m.away_goals THEN h.name
            WHEN m.away_goals > m.home_goals THEN a.name
            ELSE 'Draw'
        END                 AS winner,
        m.attendance
    FROM matches m
    JOIN tournaments t  ON m.tournament_id = t.tournament_id
    JOIN countries   h  ON m.home_team_id  = h.country_id
    JOIN countries   a  ON m.away_team_id  = a.country_id
    WHERE (h.fifa_code = team1 AND a.fifa_code = team2)
       OR (h.fifa_code = team2 AND a.fifa_code = team1)
    ORDER BY t.year;
END$$
DELIMITER ;

-- ============================================================
-- SP 5: sp_country_history
-- All tournament appearances for a given country (by FIFA code)
-- Usage: CALL sp_country_history('BRA');
-- ============================================================
DROP PROCEDURE IF EXISTS sp_country_history;
DELIMITER $$
CREATE PROCEDURE sp_country_history(IN p_code CHAR(3))
BEGIN
    SELECT
        t.year,
        t.host_country,
        tt.group_stage      AS `group`,
        tt.final_position   AS finish,
        tt.matches_played,
        tt.wins,
        tt.draws,
        tt.losses,
        tt.goals_for        AS gf,
        tt.goals_against    AS ga,
        (tt.goals_for - tt.goals_against) AS gd
    FROM tournament_teams tt
    JOIN countries   c  ON tt.country_id    = c.country_id
    JOIN tournaments t  ON tt.tournament_id = t.tournament_id
    WHERE c.fifa_code = p_code
    ORDER BY t.year;
END$$
DELIMITER ;

-- ============================================================
-- Usage examples:
-- CALL sp_player_career('Messi');
-- CALL sp_scorer_career('Klose');
-- CALL sp_scorer_career('Mbappé');
-- CALL sp_tournament_snapshot(2022);
-- CALL sp_tournament_snapshot(2014);
-- CALL sp_head_to_head('ARG','BRA');
-- CALL sp_country_history('BRA');
-- CALL sp_country_history('GER');
-- ============================================================
