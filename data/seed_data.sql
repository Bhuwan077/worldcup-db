-- ============================================================
--  SEED DATA — FIFA World Cup Modern Era (1990–2022)
--  Run AFTER schema.sql
-- ============================================================

USE worldcup_db;

-- ============================================================
-- TOURNAMENTS
-- ============================================================
INSERT INTO tournaments
    (year, host_country, host_continent, start_date, end_date, num_teams,
     champion, runner_up, third_place, fourth_place,
     total_goals, total_matches, golden_ball, golden_boot, golden_glove)
VALUES
(1990,'Italy',       'Europe',       '1990-06-08','1990-07-08',24,'West Germany','Argentina','Italy',        'England',     115,52,'Salvatore Schillaci','Salvatore Schillaci',  'Sergio Goycochea'),
(1994,'United States','North America','1994-06-17','1994-07-17',24,'Brazil',     'Italy',    'Sweden',       'Bulgaria',    141,52,'Romário',            'Oleg Salenko / Hristo Stoichkov','Andoni Zubizarreta'),
(1998,'France',      'Europe',       '1998-06-10','1998-07-12',32,'France',     'Brazil',   'Croatia',      'Netherlands', 171,64,'Ronaldo',            'Davor Šuker',           'Fabien Barthez'),
(2002,'South Korea / Japan','Asia',  '2002-05-31','2002-06-30',32,'Brazil',     'Germany',  'Turkey',       'South Korea', 161,64,'Oliver Kahn',        'Ronaldo',               'Oliver Kahn'),
(2006,'Germany',     'Europe',       '2006-06-09','2006-07-09',32,'Italy',      'France',   'Germany',      'Portugal',    147,64,'Zinedine Zidane',    'Miroslav Klose',        'Gianluigi Buffon'),
(2010,'South Africa','Africa',       '2010-06-11','2010-07-11',32,'Spain',      'Netherlands','Germany',    'Uruguay',     145,64,'Diego Forlán',       'Thomas Müller',         'Iker Casillas'),
(2014,'Brazil',      'South America','2014-06-12','2014-07-13',32,'Germany',    'Argentina','Netherlands',  'Brazil',      171,64,'Lionel Messi',       'James Rodríguez',       'Manuel Neuer'),
(2018,'Russia',      'Europe',       '2018-06-14','2018-07-15',32,'France',     'Croatia',  'Belgium',      'England',     169,64,'Luka Modrić',        'Harry Kane',            'Thibaut Courtois'),
(2022,'Qatar',       'Asia',         '2022-11-20','2022-12-18',32,'Argentina',  'France',   'Croatia',      'Morocco',     172,64,'Lionel Messi',       'Kylian Mbappé',         'Emiliano Martínez');

-- ============================================================
-- COUNTRIES (key nations)
-- ============================================================
INSERT INTO countries (name, fifa_code, confederation) VALUES
('Argentina',    'ARG', 'CONMEBOL'),
('Australia',    'AUS', 'AFC'),
('Belgium',      'BEL', 'UEFA'),
('Brazil',       'BRA', 'CONMEBOL'),
('Bulgaria',     'BUL', 'UEFA'),
('Cameroon',     'CMR', 'CAF'),
('Colombia',     'COL', 'CONMEBOL'),
('Croatia',      'CRO', 'UEFA'),
('Denmark',      'DEN', 'UEFA'),
('England',      'ENG', 'UEFA'),
('France',       'FRA', 'UEFA'),
('Germany',      'GER', 'UEFA'),
('Ghana',        'GHA', 'CAF'),
('Italy',        'ITA', 'UEFA'),
('Ivory Coast',  'CIV', 'CAF'),
('Japan',        'JPN', 'AFC'),
('Mexico',       'MEX', 'CONCACAF'),
('Morocco',      'MAR', 'CAF'),
('Netherlands',  'NED', 'UEFA'),
('Nigeria',      'NGA', 'CAF'),
('Poland',       'POL', 'UEFA'),
('Portugal',     'POR', 'UEFA'),
('Romania',      'ROU', 'UEFA'),
('Russia',       'RUS', 'UEFA'),
('Saudi Arabia', 'KSA', 'AFC'),
('Senegal',      'SEN', 'CAF'),
('Serbia',       'SRB', 'UEFA'),
('South Korea',  'KOR', 'AFC'),
('Spain',        'ESP', 'UEFA'),
('Sweden',       'SWE', 'UEFA'),
('Switzerland',  'SUI', 'UEFA'),
('Turkey',       'TUR', 'UEFA'),
('Ukraine',      'UKR', 'UEFA'),
('United States','USA', 'CONCACAF'),
('Uruguay',      'URU', 'CONMEBOL'),
('West Germany', 'DFB', 'UEFA'),  -- Pre-reunification
('Qatar',        'QAT', 'AFC');

-- ============================================================
-- PLAYERS (sample — notable players from the modern era)
-- ============================================================
INSERT INTO players (country_id, full_name, date_of_birth, position)
SELECT country_id, 'Ronaldo Nazário',    '1976-09-18', 'FW' FROM countries WHERE fifa_code='BRA' UNION ALL
SELECT country_id, 'Ronaldinho',         '1980-03-21', 'MF' FROM countries WHERE fifa_code='BRA' UNION ALL
SELECT country_id, 'Cafu',               '1970-06-07', 'DF' FROM countries WHERE fifa_code='BRA' UNION ALL
SELECT country_id, 'Lionel Messi',       '1987-06-24', 'FW' FROM countries WHERE fifa_code='ARG' UNION ALL
SELECT country_id, 'Diego Maradona',     '1960-10-30', 'MF' FROM countries WHERE fifa_code='ARG' UNION ALL
SELECT country_id, 'Gonzalo Higuaín',    '1987-12-10', 'FW' FROM countries WHERE fifa_code='ARG' UNION ALL
SELECT country_id, 'Zinedine Zidane',    '1972-06-23', 'MF' FROM countries WHERE fifa_code='FRA' UNION ALL
SELECT country_id, 'Thierry Henry',      '1977-08-17', 'FW' FROM countries WHERE fifa_code='FRA' UNION ALL
SELECT country_id, 'Kylian Mbappé',      '1998-12-20', 'FW' FROM countries WHERE fifa_code='FRA' UNION ALL
SELECT country_id, 'Antoine Griezmann',  '1991-03-21', 'FW' FROM countries WHERE fifa_code='FRA' UNION ALL
SELECT country_id, 'Miroslav Klose',     '1978-06-09', 'FW' FROM countries WHERE fifa_code='GER' UNION ALL
SELECT country_id, 'Oliver Kahn',        '1969-06-15', 'GK' FROM countries WHERE fifa_code='GER' UNION ALL
SELECT country_id, 'Thomas Müller',      '1989-09-13', 'FW' FROM countries WHERE fifa_code='GER' UNION ALL
SELECT country_id, 'Cristiano Ronaldo',  '1985-02-05', 'FW' FROM countries WHERE fifa_code='POR' UNION ALL
SELECT country_id, 'Luís Figo',          '1972-11-04', 'MF' FROM countries WHERE fifa_code='POR' UNION ALL
SELECT country_id, 'Luka Modrić',        '1985-09-09', 'MF' FROM countries WHERE fifa_code='CRO' UNION ALL
SELECT country_id, 'Ivan Rakitić',       '1988-03-10', 'MF' FROM countries WHERE fifa_code='CRO' UNION ALL
SELECT country_id, 'Davor Šuker',        '1968-01-01', 'FW' FROM countries WHERE fifa_code='CRO' UNION ALL
SELECT country_id, 'Iker Casillas',      '1981-05-20', 'GK' FROM countries WHERE fifa_code='ESP' UNION ALL
SELECT country_id, 'Andrés Iniesta',     '1984-05-11', 'MF' FROM countries WHERE fifa_code='ESP' UNION ALL
SELECT country_id, 'David Villa',        '1981-12-03', 'FW' FROM countries WHERE fifa_code='ESP' UNION ALL
SELECT country_id, 'Harry Kane',         '1993-07-28', 'FW' FROM countries WHERE fifa_code='ENG' UNION ALL
SELECT country_id, 'Wayne Rooney',       '1985-10-24', 'FW' FROM countries WHERE fifa_code='ENG' UNION ALL
SELECT country_id, 'Salvatore Schillaci','1964-12-01', 'FW' FROM countries WHERE fifa_code='ITA' UNION ALL
SELECT country_id, 'Gianluigi Buffon',   '1978-01-28', 'GK' FROM countries WHERE fifa_code='ITA' UNION ALL
SELECT country_id, 'Roberto Baggio',     '1967-02-18', 'FW' FROM countries WHERE fifa_code='ITA' UNION ALL
SELECT country_id, 'Diego Forlán',       '1979-05-19', 'FW' FROM countries WHERE fifa_code='URU' UNION ALL
SELECT country_id, 'Luis Suárez',        '1987-01-24', 'FW' FROM countries WHERE fifa_code='URU' UNION ALL
SELECT country_id, 'James Rodríguez',    '1991-07-12', 'MF' FROM countries WHERE fifa_code='COL' UNION ALL
SELECT country_id, 'Romário',            '1966-01-29', 'FW' FROM countries WHERE fifa_code='BRA';

-- ============================================================
-- TOURNAMENT TEAMS — 2022 Qatar (sample)
-- ============================================================
INSERT INTO tournament_teams (tournament_id, country_id, group_stage, final_position, matches_played, wins, draws, losses, goals_for, goals_against)
SELECT t.tournament_id, c.country_id, 'C', 1, 7, 5, 2, 0, 15, 8
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='ARG'
UNION ALL
SELECT t.tournament_id, c.country_id, 'D', 2, 7, 4, 1, 2, 16, 8
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='FRA'
UNION ALL
SELECT t.tournament_id, c.country_id, 'F', 3, 7, 4, 2, 1, 10, 6
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='CRO'
UNION ALL
SELECT t.tournament_id, c.country_id, 'F', 4, 7, 4, 0, 3, 6, 7
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='MAR'
UNION ALL
SELECT t.tournament_id, c.country_id, 'E', 5, 5, 3, 1, 1, 8, 4
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='NED'
UNION ALL
SELECT t.tournament_id, c.country_id, 'E', 6, 5, 3, 0, 2, 7, 5
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='BRA'
UNION ALL
SELECT t.tournament_id, c.country_id, 'G', 8, 4, 2, 1, 1, 6, 5
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='POR'
UNION ALL
SELECT t.tournament_id, c.country_id, 'E', 8, 4, 2, 0, 2, 3, 4
FROM tournaments t, countries c WHERE t.year=2022 AND c.fifa_code='ENG';

-- ============================================================
-- PLAYER TOURNAMENT STATS — sample career stats
-- ============================================================
-- Miroslav Klose (GER): 2002, 2006, 2010, 2014
INSERT INTO player_tournament_stats (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2002 THEN 7 WHEN 2006 THEN 7 WHEN 2010 THEN 4 WHEN 2014 THEN 7 END,
    CASE t.year WHEN 2002 THEN 5 WHEN 2006 THEN 5 WHEN 2010 THEN 4 WHEN 2014 THEN 2 END,
    CASE t.year WHEN 2002 THEN 1 WHEN 2006 THEN 1 WHEN 2010 THEN 1 WHEN 2014 THEN 2 END,
    1,
    CASE t.year WHEN 2002 THEN 630 WHEN 2006 THEN 560 WHEN 2010 THEN 360 WHEN 2014 THEN 420 END
FROM players p, tournaments t
WHERE p.full_name='Miroslav Klose' AND t.year IN (2002,2006,2010,2014);

-- Ronaldo Nazário (BRA): 1994, 1998, 2002, 2006
INSERT INTO player_tournament_stats (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 1994 THEN 2 WHEN 1998 THEN 7 WHEN 2002 THEN 7 WHEN 2006 THEN 5 END,
    CASE t.year WHEN 1994 THEN 0 WHEN 1998 THEN 4 WHEN 2002 THEN 8 WHEN 2006 THEN 3 END,
    CASE t.year WHEN 1994 THEN 0 WHEN 1998 THEN 2 WHEN 2002 THEN 1 WHEN 2006 THEN 0 END,
    0,
    CASE t.year WHEN 1994 THEN 120 WHEN 1998 THEN 630 WHEN 2002 THEN 630 WHEN 2006 THEN 450 END
FROM players p, tournaments t
WHERE p.full_name='Ronaldo Nazário' AND t.year IN (1994,1998,2002,2006);

-- Lionel Messi (ARG): 2006–2022
INSERT INTO player_tournament_stats (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2006 THEN 3 WHEN 2010 THEN 5 WHEN 2014 THEN 7 WHEN 2018 THEN 4 WHEN 2022 THEN 7 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 0 WHEN 2014 THEN 4 WHEN 2018 THEN 1 WHEN 2022 THEN 7 END,
    CASE t.year WHEN 2006 THEN 0 WHEN 2010 THEN 1 WHEN 2014 THEN 1 WHEN 2018 THEN 0 WHEN 2022 THEN 3 END,
    CASE t.year WHEN 2006 THEN 0 WHEN 2010 THEN 0 WHEN 2014 THEN 0 WHEN 2018 THEN 1 WHEN 2022 THEN 0 END,
    CASE t.year WHEN 2006 THEN 270 WHEN 2010 THEN 450 WHEN 2014 THEN 690 WHEN 2018 THEN 360 WHEN 2022 THEN 690 END
FROM players p, tournaments t
WHERE p.full_name='Lionel Messi' AND t.year IN (2006,2010,2014,2018,2022);

-- Kylian Mbappé (FRA): 2018, 2022
INSERT INTO player_tournament_stats (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2018 THEN 7 WHEN 2022 THEN 7 END,
    CASE t.year WHEN 2018 THEN 4 WHEN 2022 THEN 8 END,
    CASE t.year WHEN 2018 THEN 2 WHEN 2022 THEN 2 END,
    0,
    CASE t.year WHEN 2018 THEN 548 WHEN 2022 THEN 690 END
FROM players p, tournaments t
WHERE p.full_name='Kylian Mbappé' AND t.year IN (2018,2022);

-- Cristiano Ronaldo (POR): 2006–2022
INSERT INTO player_tournament_stats (player_id, tournament_id, matches_played, goals, assists, yellow_cards, minutes_played)
SELECT p.player_id, t.tournament_id,
    CASE t.year WHEN 2006 THEN 6 WHEN 2010 THEN 4 WHEN 2014 THEN 3 WHEN 2018 THEN 4 WHEN 2022 THEN 5 END,
    CASE t.year WHEN 2006 THEN 1 WHEN 2010 THEN 1 WHEN 2014 THEN 1 WHEN 2018 THEN 4 WHEN 2022 THEN 1 END,
    CASE t.year WHEN 2006 THEN 2 WHEN 2010 THEN 0 WHEN 2014 THEN 0 WHEN 2018 THEN 0 WHEN 2022 THEN 0 END,
    1,
    CASE t.year WHEN 2006 THEN 540 WHEN 2010 THEN 360 WHEN 2014 THEN 270 WHEN 2018 THEN 360 WHEN 2022 THEN 450 END
FROM players p, tournaments t
WHERE p.full_name='Cristiano Ronaldo' AND t.year IN (2006,2010,2014,2018,2022);
