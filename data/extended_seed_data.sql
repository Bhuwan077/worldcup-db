-- ============================================================
--  EXTENDED SEED DATA — FIFA World Cup Modern Era (1990–2022)
--  Run AFTER schema.sql, seed_data.sql
--  Adds: all 9 tournament_teams, extra player stats,
--        goals log, cards log, stadiums
-- ============================================================

USE worldcup_db;

-- ============================================================
-- MISSING COUNTRIES (needed for matches in top10_scorers_complete.sql)
-- ============================================================
INSERT IGNORE INTO countries (name, fifa_code, confederation) VALUES
('Austria',             'AUT', 'UEFA'),
('Bosnia-Herzegovina',  'BIH', 'UEFA'),
('China',               'CHN', 'AFC'),
('Republic of Ireland', 'IRL', 'UEFA'),
('Jamaica',             'JAM', 'CONCACAF');

-- ============================================================
-- TOURNAMENT TEAMS — 1990 Italy
-- Top finishers + group stage data
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'ITA' code, 'C' g, 3  pos, 7 mp, 6 w, 1 d, 0 l, 10 gf, 2  ga UNION ALL
    SELECT 'ARG',      'B', 2,   7, 5, 1, 1, 7, 5  UNION ALL
    SELECT 'ENG',      'F', 4,   7, 3, 3, 1, 8, 6  UNION ALL
    SELECT 'GER',      'D', 1,   7, 6, 1, 0, 15, 5 UNION ALL -- West Germany stored as GER for queries
    SELECT 'BRA',      'C', 5,   4, 3, 0, 1, 4, 2  UNION ALL
    SELECT 'SWE',      'C', 8,   4, 1, 2, 1, 3, 4  UNION ALL
    SELECT 'ESP',      'E', 5,   5, 3, 1, 1, 6, 4  UNION ALL
    SELECT 'URU',      'E', 7,   4, 2, 0, 2, 5, 5
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 1990;

-- ============================================================
-- TOURNAMENT TEAMS — 1994 United States
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'BRA' code, 'B' g, 1  pos, 7 mp, 5 w, 2 d, 0 l, 11 gf, 3  ga UNION ALL
    SELECT 'ITA',      'E', 2,   7, 4, 1, 2, 6, 5  UNION ALL
    SELECT 'SWE',      'B', 3,   7, 5, 0, 2, 15, 8 UNION ALL
    SELECT 'BUL',      'D', 4,   6, 3, 1, 2, 7, 7  UNION ALL
    SELECT 'GER',      'C', 5,   5, 3, 1, 1, 9, 7  UNION ALL
    SELECT 'ROM',      'A', 6,   5, 3, 1, 1, 9, 7  UNION ALL -- Romania
    SELECT 'NED',      'F', 7,   5, 2, 2, 1, 8, 5  UNION ALL
    SELECT 'ESP',      'C', 8,   5, 2, 1, 2, 7, 5
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 1994;

-- Romania not in countries yet, add it
INSERT IGNORE INTO countries (name, fifa_code, confederation) VALUES ('Romania', 'ROM', 'UEFA');

-- ============================================================
-- TOURNAMENT TEAMS — 1998 France
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'FRA' code, 'C' g, 1  pos, 7 mp, 6 w, 1 d, 0 l, 15 gf, 2  ga UNION ALL
    SELECT 'BRA',      'A', 2,   7, 4, 1, 2, 14, 10 UNION ALL
    SELECT 'CRO',      'H', 3,   7, 5, 0, 2, 11, 5  UNION ALL
    SELECT 'NED',      'E', 4,   7, 3, 2, 2, 13, 10 UNION ALL
    SELECT 'GER',      'F', 5,   5, 3, 1, 1, 10, 6  UNION ALL
    SELECT 'ARG',      'H', 6,   5, 2, 2, 1, 10, 5  UNION ALL
    SELECT 'ITA',      'B', 7,   5, 2, 2, 1, 11, 5  UNION ALL
    SELECT 'ENG',      'G', 8,   5, 2, 1, 2, 7, 7
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 1998;

-- ============================================================
-- TOURNAMENT TEAMS — 2002 South Korea/Japan
-- ============================================================
INSERT IGNORE INTO countries (name, fifa_code, confederation) VALUES ('South Korea', 'KOR', 'AFC');

INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'BRA' code, 'C' g, 1  pos, 7 mp, 7 w, 0 d, 0 l, 18 gf, 4  ga UNION ALL
    SELECT 'GER',      'E', 2,   7, 5, 1, 1, 14, 9  UNION ALL
    SELECT 'TUR',      'C', 3,   7, 5, 0, 2, 15, 9  UNION ALL
    SELECT 'KOR',      'D', 4,   7, 3, 2, 2, 8, 6   UNION ALL
    SELECT 'ESP',      'B', 5,   5, 3, 2, 0, 9, 4   UNION ALL
    SELECT 'ENG',      'F', 6,   5, 3, 0, 2, 8, 6   UNION ALL
    SELECT 'SEN',      'A', 7,   5, 3, 1, 1, 7, 6   UNION ALL
    SELECT 'USA',      'D', 8,   5, 2, 1, 2, 5, 9
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 2002;

-- ============================================================
-- TOURNAMENT TEAMS — 2006 Germany
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'ITA' code, 'E' g, 1  pos, 7 mp, 6 w, 1 d, 0 l, 12 gf, 2  ga UNION ALL
    SELECT 'FRA',      'G', 2,   7, 4, 2, 1, 9, 6   UNION ALL
    SELECT 'GER',      'A', 3,   7, 5, 1, 1, 14, 6  UNION ALL
    SELECT 'POR',      'D', 4,   7, 5, 0, 2, 11, 6  UNION ALL
    SELECT 'ENG',      'B', 5,   5, 3, 1, 1, 6, 3   UNION ALL
    SELECT 'ARG',      'C', 6,   5, 3, 1, 1, 11, 5  UNION ALL
    SELECT 'BRA',      'F', 7,   5, 3, 1, 1, 11, 6  UNION ALL
    SELECT 'ESP',      'H', 8,   4, 2, 0, 2, 4, 5
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 2006;

-- ============================================================
-- TOURNAMENT TEAMS — 2010 South Africa
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'ESP' code, 'H' g, 1  pos, 7 mp, 6 w, 1 d, 0 l, 8  gf, 2  ga UNION ALL
    SELECT 'NED',      'E', 2,   7, 5, 1, 1, 12, 6  UNION ALL
    SELECT 'GER',      'D', 3,   7, 5, 0, 2, 16, 10 UNION ALL
    SELECT 'URU',      'A', 4,   7, 4, 1, 2, 11, 8  UNION ALL
    SELECT 'ARG',      'B', 5,   5, 4, 0, 1, 10, 6  UNION ALL
    SELECT 'BRA',      'G', 6,   5, 3, 1, 1, 9, 5   UNION ALL
    SELECT 'GHA',      'D', 7,   5, 2, 2, 1, 5, 4   UNION ALL
    SELECT 'PAR',      'F', 8,   5, 1, 3, 1, 3, 4
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 2010;

-- ============================================================
-- TOURNAMENT TEAMS — 2014 Brazil
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'GER' code, 'G' g, 1  pos, 7 mp, 6 w, 1 d, 0 l, 18 gf, 4  ga UNION ALL
    SELECT 'ARG',      'F', 2,   7, 4, 3, 0, 8, 4   UNION ALL
    SELECT 'NED',      'B', 3,   7, 4, 1, 2, 15, 8  UNION ALL
    SELECT 'BRA',      'A', 4,   7, 3, 1, 3, 11, 14 UNION ALL
    SELECT 'COL',      'C', 5,   5, 4, 0, 1, 12, 5  UNION ALL
    SELECT 'FRA',      'E', 6,   5, 4, 0, 1, 10, 5  UNION ALL
    SELECT 'BEL',      'H', 7,   5, 4, 0, 1, 8, 4   UNION ALL
    SELECT 'CRC',      'D', 8,   5, 2, 2, 1, 4, 4
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 2014;

-- ============================================================
-- TOURNAMENT TEAMS — 2018 Russia
-- ============================================================
INSERT IGNORE INTO tournament_teams
    (tournament_id, country_id, group_stage, final_position,
     matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, g, pos, mp, w, d, l, gf, ga
FROM tournaments t
JOIN (
    SELECT 'FRA' code, 'C' g, 1  pos, 7 mp, 6 w, 1 d, 0 l, 12 gf, 4  ga UNION ALL
    SELECT 'CRO',      'D', 2,   7, 4, 2, 1, 14, 9  UNION ALL
    SELECT 'BEL',      'G', 3,   7, 6, 0, 1, 16, 6  UNION ALL
    SELECT 'ENG',      'G', 4,   7, 4, 0, 3, 12, 9  UNION ALL
    SELECT 'URU',      'A', 5,   5, 4, 0, 1, 7, 3   UNION ALL
    SELECT 'BRA',      'E', 6,   5, 3, 1, 1, 8, 4   UNION ALL
    SELECT 'RUS',      'A', 7,   5, 3, 0, 2, 9, 7   UNION ALL
    SELECT 'SWE',      'F', 8,   5, 3, 0, 2, 6, 5
) x ON c.fifa_code = x.code
JOIN countries c ON c.fifa_code = x.code
WHERE t.year = 2018;

-- ============================================================
-- EXTRA PLAYER TOURNAMENT STATS
-- ============================================================

-- Salvatore Schillaci (ITA): 1990 — 6 goals, Golden Boot winner
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id, 7, 6, 1, 1, 517
FROM players p, tournaments t
WHERE p.full_name = 'Salvatore Schillaci' AND t.year = 1990;

-- Davor Šuker (CRO): 1998 — 6 goals, Golden Boot winner
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id, 7, 6, 0, 1, 521
FROM players p, tournaments t
WHERE p.full_name = 'Davor Šuker' AND t.year = 1998;

-- Roberto Baggio (ITA): 1990, 1994, 1998
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 1990 THEN 7 WHEN 1994 THEN 7 WHEN 1998 THEN 4 END,
    CASE t.year WHEN 1990 THEN 2 WHEN 1994 THEN 5 WHEN 1998 THEN 2 END,
    CASE t.year WHEN 1990 THEN 1 WHEN 1994 THEN 1 WHEN 1998 THEN 0 END,
    CASE t.year WHEN 1990 THEN 0 WHEN 1994 THEN 1 WHEN 1998 THEN 1 END,
    CASE t.year WHEN 1990 THEN 540 WHEN 1994 THEN 630 WHEN 1998 THEN 270 END
FROM players p, tournaments t
WHERE p.full_name = 'Roberto Baggio' AND t.year IN (1990, 1994, 1998);

-- Romário (BRA): 1994 — 5 goals, star of the tournament
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id, 7, 5, 3, 0, 630
FROM players p, tournaments t
WHERE p.full_name = 'Romário' AND t.year = 1994;

-- Thierry Henry (FRA): 1998, 2002, 2006, 2010
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 1998 THEN 6 WHEN 2002 THEN 3 WHEN 2006 THEN 6 WHEN 2010 THEN 3 END,
    CASE t.year WHEN 1998 THEN 3 WHEN 2002 THEN 0 WHEN 2006 THEN 3 WHEN 2010 THEN 0 END,
    CASE t.year WHEN 1998 THEN 2 WHEN 2002 THEN 0 WHEN 2006 THEN 3 WHEN 2010 THEN 0 END,
    CASE t.year WHEN 1998 THEN 1 WHEN 2002 THEN 1 WHEN 2006 THEN 0 WHEN 2010 THEN 1 END,
    CASE t.year WHEN 1998 THEN 472 WHEN 2002 THEN 183 WHEN 2006 THEN 526 WHEN 2010 THEN 220 END
FROM players p, tournaments t
WHERE p.full_name = 'Thierry Henry' AND t.year IN (1998, 2002, 2006, 2010);

-- James Rodríguez (COL): 2014 — 6 goals, Golden Boot
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id, 5, 6, 2, 0, 450
FROM players p, tournaments t
WHERE p.full_name = 'James Rodríguez' AND t.year = 2014;

-- Harry Kane (ENG): 2018 — 6 goals, Golden Boot; 2022 — 3 goals
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2018 THEN 6 WHEN 2022 THEN 5 END,
    CASE t.year WHEN 2018 THEN 6 WHEN 2022 THEN 3 END,
    CASE t.year WHEN 2018 THEN 0 WHEN 2022 THEN 0 END,
    0,
    CASE t.year WHEN 2018 THEN 540 WHEN 2022 THEN 450 END
FROM players p, tournaments t
WHERE p.full_name = 'Harry Kane' AND t.year IN (2018, 2022);

-- Diego Forlán (URU): 2002, 2010 — won Golden Ball 2010
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2002 THEN 3 WHEN 2010 THEN 7 END,
    CASE t.year WHEN 2002 THEN 0 WHEN 2010 THEN 5 END,
    CASE t.year WHEN 2002 THEN 0 WHEN 2010 THEN 2 END,
    1,
    CASE t.year WHEN 2002 THEN 186 WHEN 2010 THEN 630 END
FROM players p, tournaments t
WHERE p.full_name = 'Diego Forlán' AND t.year IN (2002, 2010);

-- Zinedine Zidane (FRA): 1998, 2002, 2006 — Golden Ball 2006
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, red_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 1998 THEN 7 WHEN 2002 THEN 2 WHEN 2006 THEN 7 END,
    CASE t.year WHEN 1998 THEN 2 WHEN 2002 THEN 0 WHEN 2006 THEN 3 END,
    CASE t.year WHEN 1998 THEN 3 WHEN 2002 THEN 0 WHEN 2006 THEN 2 END,
    CASE t.year WHEN 1998 THEN 1 WHEN 2002 THEN 0 WHEN 2006 THEN 0 END,
    CASE t.year WHEN 1998 THEN 0 WHEN 2002 THEN 0 WHEN 2006 THEN 1 END, -- Red card in 2006 final
    CASE t.year WHEN 1998 THEN 630 WHEN 2002 THEN 180 WHEN 2006 THEN 637 END
FROM players p, tournaments t
WHERE p.full_name = 'Zinedine Zidane' AND t.year IN (1998, 2002, 2006);

-- Andrés Iniesta (ESP): 2006, 2010 — scored the 2010 final winner
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2006 THEN 6 WHEN 2010 THEN 7 END,
    CASE t.year WHEN 2006 THEN 0 WHEN 2010 THEN 1 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 4 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 0 END,
    CASE t.year WHEN 2006 THEN 490 WHEN 2010 THEN 660 END
FROM players p, tournaments t
WHERE p.full_name = 'Andrés Iniesta' AND t.year IN (2006, 2010);

-- David Villa (ESP): 2006, 2010 — 9 total goals across both tournaments
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2006 THEN 6 WHEN 2010 THEN 7 END,
    CASE t.year WHEN 2006 THEN 3 WHEN 2010 THEN 5 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 0 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 1 END,
    CASE t.year WHEN 2006 THEN 527 WHEN 2010 THEN 605 END
FROM players p, tournaments t
WHERE p.full_name = 'David Villa' AND t.year IN (2006, 2010);

-- Luis Suárez (URU): 2010, 2014
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, red_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2010 THEN 5 WHEN 2014 THEN 2 END,
    CASE t.year WHEN 2010 THEN 3 WHEN 2014 THEN 2 END,
    CASE t.year WHEN 2010 THEN 1 WHEN 2014 THEN 0 END,
    CASE t.year WHEN 2010 THEN 1 WHEN 2014 THEN 0 END,
    CASE t.year WHEN 2010 THEN 0 WHEN 2014 THEN 1 END, -- biting incident ban
    CASE t.year WHEN 2010 THEN 392 WHEN 2014 THEN 162 END
FROM players p, tournaments t
WHERE p.full_name = 'Luis Suárez' AND t.year IN (2010, 2014);

-- Luka Modrić (CRO): 2006, 2014, 2018, 2022 — Golden Ball 2018
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2006 THEN 3 WHEN 2014 THEN 3 WHEN 2018 THEN 7 WHEN 2022 THEN 7 END,
    CASE t.year WHEN 2006 THEN 0 WHEN 2014 THEN 0 WHEN 2018 THEN 2 WHEN 2022 THEN 1 END,
    CASE t.year WHEN 2006 THEN 0 WHEN 2014 THEN 1 WHEN 2018 THEN 1 WHEN 2022 THEN 1 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2014 THEN 2 WHEN 2018 THEN 1 WHEN 2022 THEN 2 END,
    CASE t.year WHEN 2006 THEN 270 WHEN 2014 THEN 270 WHEN 2018 THEN 690 WHEN 2022 THEN 690 END
FROM players p, tournaments t
WHERE p.full_name = 'Luka Modrić' AND t.year IN (2006, 2014, 2018, 2022);

-- Antoine Griezmann (FRA): 2014, 2018, 2022
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2014 THEN 4 WHEN 2018 THEN 7 WHEN 2022 THEN 7 END,
    CASE t.year WHEN 2014 THEN 0 WHEN 2018 THEN 3 WHEN 2022 THEN 1 END,
    CASE t.year WHEN 2014 THEN 0 WHEN 2018 THEN 2 WHEN 2022 THEN 5 END,
    CASE t.year WHEN 2014 THEN 0 WHEN 2018 THEN 1 WHEN 2022 THEN 0 END,
    CASE t.year WHEN 2014 THEN 294 WHEN 2018 THEN 690 WHEN 2022 THEN 690 END
FROM players p, tournaments t
WHERE p.full_name = 'Antoine Griezmann' AND t.year IN (2014, 2018, 2022);

-- Thomas Müller (GER): 2010 — 5 goals Golden Boot; 2014 — 5 goals; 2018
INSERT IGNORE INTO player_tournament_stats
    (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2010 THEN 6 WHEN 2014 THEN 7 WHEN 2018 THEN 5 END,
    CASE t.year WHEN 2010 THEN 5 WHEN 2014 THEN 5 WHEN 2018 THEN 2 END,
    CASE t.year WHEN 2010 THEN 3 WHEN 2014 THEN 3 WHEN 2018 THEN 1 END,
    CASE t.year WHEN 2010 THEN 0 WHEN 2014 THEN 0 WHEN 2018 THEN 0 END,
    CASE t.year WHEN 2010 THEN 524 WHEN 2014 THEN 630 WHEN 2018 THEN 405 END
FROM players p, tournaments t
WHERE p.full_name = 'Thomas Müller' AND t.year IN (2010, 2014, 2018);

-- ============================================================
-- STADIUMS — Key World Cup venues across all 9 tournaments
-- ============================================================
INSERT IGNORE INTO stadiums (name, city, country_id, capacity)
VALUES
-- 1990 Italy
('Stadio Olimpico',        'Rome',           (SELECT country_id FROM countries WHERE fifa_code='ITA'), 82656),
('Stadio Giuseppe Meazza', 'Milan',          (SELECT country_id FROM countries WHERE fifa_code='ITA'), 75923),
-- 1994 USA
('Rose Bowl',              'Pasadena',       (SELECT country_id FROM countries WHERE fifa_code='USA'), 94194),
('Pontiac Silverdome',     'Detroit',        (SELECT country_id FROM countries WHERE fifa_code='USA'), 76537),
-- 1998 France
('Stade de France',        'Saint-Denis',    (SELECT country_id FROM countries WHERE fifa_code='FRA'), 80698),
('Stade Vélodrome',        'Marseille',      (SELECT country_id FROM countries WHERE fifa_code='FRA'), 67394),
-- 2002 Korea/Japan
('Yokohama International', 'Yokohama',       (SELECT country_id FROM countries WHERE fifa_code='JPN'), 72327),
('Seoul World Cup Stadium','Seoul',          (SELECT country_id FROM countries WHERE fifa_code='KOR'), 66806),
-- 2006 Germany
('Olympiastadion',         'Berlin',         (SELECT country_id FROM countries WHERE fifa_code='GER'), 74228),
('Allianz Arena',          'Munich',         (SELECT country_id FROM countries WHERE fifa_code='GER'), 66000),
-- 2010 South Africa
('Soccer City',            'Johannesburg',   (SELECT country_id FROM countries WHERE fifa_code='ZAF'), 94700),
('Cape Town Stadium',      'Cape Town',      (SELECT country_id FROM countries WHERE fifa_code='ZAF'), 64100),
-- 2014 Brazil
('Estádio do Maracanã',    'Rio de Janeiro', (SELECT country_id FROM countries WHERE fifa_code='BRA'), 78838),
('Estádio Nacional',       'Brasília',       (SELECT country_id FROM countries WHERE fifa_code='BRA'), 72888),
-- 2018 Russia
('Luzhniki Stadium',       'Moscow',         (SELECT country_id FROM countries WHERE fifa_code='RUS'), 81000),
('Saint Petersburg Stadium','Saint Petersburg',(SELECT country_id FROM countries WHERE fifa_code='RUS'), 68134),
-- 2022 Qatar
('Lusail Iconic Stadium',  'Lusail',         (SELECT country_id FROM countries WHERE fifa_code='QAT'), 88966),
('Al Bayt Stadium',        'Al Khor',        (SELECT country_id FROM countries WHERE fifa_code='QAT'), 68895),
('Khalifa International',  'Doha',           (SELECT country_id FROM countries WHERE fifa_code='QAT'), 45857);

-- ============================================================
-- GOALS LOG — World Cup Finals (1990–2022)
-- ============================================================

-- We need match IDs. Insert the Finals first, then reference them.
-- Use a temp approach: insert finals into matches, then goals.

-- 1990 Final: West Germany 1-0 Argentina
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Stadio Olimpico' LIMIT 1),
       '1990-07-08', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='GER'),
       (SELECT country_id FROM countries WHERE fifa_code='ARG'),
       1, 0, 0, 0, FALSE, 73603
FROM tournaments t WHERE t.year = 1990;

-- 1994 Final: Brazil 0-0 Italy (Brazil won 3-2 on pens)
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, home_pen_score, away_pen_score, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Rose Bowl' LIMIT 1),
       '1994-07-17', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='BRA'),
       (SELECT country_id FROM countries WHERE fifa_code='ITA'),
       0, 0, 0, 0, TRUE, 3, 2, 94194
FROM tournaments t WHERE t.year = 1994;

-- 1998 Final: France 3-0 Brazil
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Stade de France' LIMIT 1),
       '1998-07-12', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='FRA'),
       (SELECT country_id FROM countries WHERE fifa_code='BRA'),
       3, 0, 0, 0, FALSE, 80000
FROM tournaments t WHERE t.year = 1998;

-- 2002 Final: Brazil 2-0 Germany
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Yokohama International' LIMIT 1),
       '2002-06-30', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='BRA'),
       (SELECT country_id FROM countries WHERE fifa_code='GER'),
       2, 0, 0, 0, FALSE, 69029
FROM tournaments t WHERE t.year = 2002;

-- 2006 Final: Italy 1-1 France AET (Italy won 5-3 on pens)
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, home_pen_score, away_pen_score, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Olympiastadion' LIMIT 1),
       '2006-07-09', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='ITA'),
       (SELECT country_id FROM countries WHERE fifa_code='FRA'),
       1, 1, 0, 0, TRUE, 5, 3, 69000
FROM tournaments t WHERE t.year = 2006;

-- 2010 Final: Spain 1-0 Netherlands AET
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Soccer City' LIMIT 1),
       '2010-07-11', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='ESP'),
       (SELECT country_id FROM countries WHERE fifa_code='NED'),
       1, 0, 1, 0, FALSE, 84490
FROM tournaments t WHERE t.year = 2010;

-- 2014 Final: Germany 1-0 Argentina AET
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Estádio do Maracanã' LIMIT 1),
       '2014-07-13', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='GER'),
       (SELECT country_id FROM countries WHERE fifa_code='ARG'),
       1, 0, 1, 0, FALSE, 74738
FROM tournaments t WHERE t.year = 2014;

-- 2018 Final: France 4-2 Croatia
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Luzhniki Stadium' LIMIT 1),
       '2018-07-15', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='FRA'),
       (SELECT country_id FROM countries WHERE fifa_code='CRO'),
       4, 2, 0, 0, FALSE, 78011
FROM tournaments t WHERE t.year = 2018;

-- 2022 Final: Argentina 3-3 France AET (Argentina won 4-2 on pens)
INSERT IGNORE INTO matches
    (tournament_id, stadium_id, match_date, stage, home_team_id, away_team_id,
     home_goals, away_goals, home_goals_et, away_goals_et, penalties, home_pen_score, away_pen_score, attendance)
SELECT t.tournament_id,
       (SELECT stadium_id FROM stadiums WHERE name='Lusail Iconic Stadium' LIMIT 1),
       '2022-12-18', 'Final',
       (SELECT country_id FROM countries WHERE fifa_code='ARG'),
       (SELECT country_id FROM countries WHERE fifa_code='FRA'),
       3, 3, 0, 0, TRUE, 4, 2, 88966
FROM tournaments t WHERE t.year = 2022;

-- ============================================================
-- GOALS — 2022 Final (Argentina 3-3 France AET)
-- Most memorable final in WC history
-- ============================================================
INSERT IGNORE INTO goals (match_id, player_id, minute, is_penalty, is_own_goal, is_extra_time)
SELECT m.match_id, p.player_id, 23, TRUE, FALSE, FALSE
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN players p ON p.full_name = 'Lionel Messi'
WHERE t.year = 2022 AND m.stage = 'Final'
UNION ALL
-- Angel Di María goal (substituted in, player not in DB — use Messi stand-in note)
-- Messi 2nd goal min 108 (AET penalty)
SELECT m.match_id, p.player_id, 108, TRUE, FALSE, TRUE
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN players p ON p.full_name = 'Lionel Messi'
WHERE t.year = 2022 AND m.stage = 'Final'
UNION ALL
-- Mbappé hat-trick
SELECT m.match_id, p.player_id, 80, TRUE, FALSE, FALSE
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN players p ON p.full_name = 'Kylian Mbappé'
WHERE t.year = 2022 AND m.stage = 'Final'
UNION ALL
SELECT m.match_id, p.player_id, 81, FALSE, FALSE, FALSE
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN players p ON p.full_name = 'Kylian Mbappé'
WHERE t.year = 2022 AND m.stage = 'Final'
UNION ALL
SELECT m.match_id, p.player_id, 118, TRUE, FALSE, TRUE
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN players p ON p.full_name = 'Kylian Mbappé'
WHERE t.year = 2022 AND m.stage = 'Final';

-- ============================================================
-- GOALS — 2018 Final (France 4-2 Croatia)
-- ============================================================
INSERT IGNORE INTO goals (match_id, player_id, minute, is_penalty, is_own_goal, is_extra_time)
-- Griezmann pen (34')
SELECT m.match_id, p.player_id, 34, TRUE, FALSE, FALSE
FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
JOIN players p ON p.full_name='Antoine Griezmann'
WHERE t.year=2018 AND m.stage='Final'
UNION ALL
-- Modrić goal (69')
SELECT m.match_id, p.player_id, 69, FALSE, FALSE, FALSE
FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
JOIN players p ON p.full_name='Luka Modrić'
WHERE t.year=2018 AND m.stage='Final';

-- ============================================================
-- CARDS — Notable cards from finals
-- ============================================================
INSERT IGNORE INTO cards (match_id, player_id, card_type, minute)
-- Zidane red card — 2006 Final (headbutt on Materazzi)
SELECT m.match_id, p.player_id, 'Red', 110
FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
JOIN players p ON p.full_name='Zinedine Zidane'
WHERE t.year=2006 AND m.stage='Final'
UNION ALL
-- Suárez yellow — 2010 QF vs Ghana (handball on the line)
SELECT m.match_id, p.player_id, 'Yellow', 120
FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
JOIN players p ON p.full_name='Luis Suárez'
WHERE t.year=2010 AND m.stage='Quarter-final'
  AND m.home_team_id = (SELECT country_id FROM countries WHERE fifa_code='URU')
LIMIT 1;
