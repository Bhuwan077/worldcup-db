-- ============================================================
--  TOP 10 WORLD CUP SCORERS — COMPLETE DATA MODULE
--  Covers: Players | Matches | Goals | Assists | Full Stats
--  World Cup Modern Era 1990–2022
--  Run AFTER schema.sql and seed_data.sql
-- ============================================================

USE worldcup_db;

-- ============================================================
-- STEP 1: ADD MISSING COUNTRIES (needed for match data)
-- ============================================================
INSERT IGNORE INTO countries (name, fifa_code, confederation) VALUES
('Czech Republic',  'CZE', 'UEFA'),
('Hungary',         'HUN', 'UEFA'),
('United Arab Emirates','UAE','AFC'),
('Bolivia',         'BOL', 'CONMEBOL'),
('Cameroon',        'CMR', 'CAF'),
('Greece',          'GRE', 'UEFA'),
('Ecuador',         'ECU', 'CONMEBOL'),
('Costa Rica',      'CRC', 'CONCACAF'),
('Iran',            'IRN', 'AFC'),
('Tunisia',         'TUN', 'CAF'),
('Paraguay',        'PAR', 'CONMEBOL'),
('Slovakia',        'SVK', 'UEFA'),
('Honduras',        'HON', 'CONCACAF'),
('Algeria',         'ALG', 'CAF'),
('Chile',           'CHI', 'CONMEBOL'),
('Togo',            'TOG', 'CAF'),
('Trinidad & Tobago','TRI','CONCACAF'),
('Angola',          'ANG', 'CAF'),
('New Zealand',     'NZL', 'OFC'),
('North Korea',     'PRK', 'AFC'),
('Slovenia',        'SVN', 'UEFA'),
('Albania',         'ALB', 'UEFA'),
('Panama',          'PAN', 'CONCACAF'),
('Iceland',         'ISL', 'UEFA'),
('Egypt',           'EGY', 'CAF'),
('Peru',            'PER', 'CONMEBOL'),
('Australia',       'AUS', 'AFC'),
('Wales',           'WAL', 'UEFA'),
('Canada',          'CAN', 'CONCACAF'),
('Cameroon',        'CMR', 'CAF'),
-- Added missing countries (caused NULL away_team_id error)
('Austria',             'AUT', 'UEFA'),
('Bosnia-Herzegovina',  'BIH', 'UEFA'),
('China',               'CHN', 'AFC'),
('Republic of Ireland', 'IRL', 'UEFA'),
('Jamaica',             'JAM', 'CONCACAF');

-- ============================================================
-- STEP 2: ENSURE ALL REQUIRED PLAYERS EXIST
-- ============================================================
-- Delete existing to avoid duplicates, then re-insert clean
DELETE FROM player_tournament_stats;
DELETE FROM goals;
DELETE FROM cards;
DELETE FROM players;

-- Insert the top 10 scorers + supporting cast
INSERT INTO players (country_id, full_name, date_of_birth, position) VALUES

-- TOP 10 SCORERS
((SELECT country_id FROM countries WHERE fifa_code='GER'),  'Miroslav Klose',     '1978-06-09', 'FW'),  -- 1: 16 goals
((SELECT country_id FROM countries WHERE fifa_code='BRA'),  'Ronaldo Nazário',    '1976-09-18', 'FW'),  -- 2: 15 goals
((SELECT country_id FROM countries WHERE fifa_code='GER'),  'Gerd Müller',        '1945-11-03', 'FW'),  -- 3: 14 goals (pre-modern, included for context)
((SELECT country_id FROM countries WHERE fifa_code='FRA'),  'Just Fontaine',      '1933-08-18', 'FW'),  -- 4: 13 goals
((SELECT country_id FROM countries WHERE fifa_code='BRA'),  'Pelé',               '1940-10-23', 'FW'),  -- 5: 12 goals
((SELECT country_id FROM countries WHERE fifa_code='ARG'),  'Lionel Messi',       '1987-06-24', 'FW'),  -- 6: 13 goals (active)
((SELECT country_id FROM countries WHERE fifa_code='FRA'),  'Kylian Mbappé',      '1998-12-20', 'FW'),  -- 7: 12 goals
((SELECT country_id FROM countries WHERE fifa_code='HUN'),  'Sándor Kocsis',      '1929-09-23', 'FW'),  -- 8: 11 goals
((SELECT country_id FROM countries WHERE fifa_code='GER'),  'Jürgen Klinsmann',   '1964-07-30', 'FW'),  -- 9: 11 goals
((SELECT country_id FROM countries WHERE fifa_code='ITA'),  'Salvatore Schillaci','1964-12-01', 'FW'),  -- 10: 6 goals (modern era top if limited to 1990+)

-- MODERN ERA TOP SCORER ADDITIONS
((SELECT country_id FROM countries WHERE fifa_code='POR'),  'Cristiano Ronaldo',  '1985-02-05', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='POL'),  'Robert Lewandowski', '1988-08-21', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='FRA'),  'Thierry Henry',      '1977-08-17', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='BRA'),  'Romário',            '1966-01-29', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='CRO'),  'Davor Šuker',        '1968-01-01', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='CRO'),  'Luka Modrić',        '1985-09-09', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='ARG'),  'Diego Maradona',     '1960-10-30', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='ENG'),  'Harry Kane',         '1993-07-28', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='ESP'),  'David Villa',        '1981-12-03', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='COL'),  'James Rodríguez',    '1991-07-12', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='URU'),  'Luis Suárez',        '1987-01-24', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='GER'),  'Thomas Müller',      '1989-09-13', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='ITA'),  'Roberto Baggio',     '1967-02-18', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='FRA'),  'Zinedine Zidane',    '1972-06-23', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='ESP'),  'Andrés Iniesta',     '1984-05-11', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='FRA'),  'Antoine Griezmann',  '1991-03-21', 'FW'),
((SELECT country_id FROM countries WHERE fifa_code='BRA'),  'Ronaldinho',         '1980-03-21', 'MF'),
((SELECT country_id FROM countries WHERE fifa_code='ITA'),  'Gianluigi Buffon',   '1978-01-28', 'GK'),
((SELECT country_id FROM countries WHERE fifa_code='ESP'),  'Iker Casillas',      '1981-05-20', 'GK');

-- ============================================================
-- STEP 3: STADIUMS
-- ============================================================
INSERT IGNORE INTO stadiums (name, city, country_id, capacity) VALUES
('Luzhniki Stadium',        'Moscow',         (SELECT country_id FROM countries WHERE fifa_code='RUS'), 81000),
('Olimpico di Roma',        'Rome',           (SELECT country_id FROM countries WHERE fifa_code='ITA'), 72698),
('Rose Bowl',               'Pasadena',       (SELECT country_id FROM countries WHERE fifa_code='USA'), 94194),
('Stade de France',         'Saint-Denis',    (SELECT country_id FROM countries WHERE fifa_code='FRA'), 80698),
('Yokohama Stadium',        'Yokohama',       (SELECT country_id FROM countries WHERE fifa_code='JPN'), 72370),
('Olympiastadion',          'Berlin',         (SELECT country_id FROM countries WHERE fifa_code='GER'), 74228),
('Soccer City',             'Johannesburg',   (SELECT country_id FROM countries WHERE fifa_code='ZAF'), 94700),
('Estádio do Maracanã',     'Rio de Janeiro', (SELECT country_id FROM countries WHERE fifa_code='BRA'), 78838),
('Lusail Iconic Stadium',   'Lusail',         (SELECT country_id FROM countries WHERE fifa_code='QAT'), 88966),
('Al Bayt Stadium',         'Al Khor',        (SELECT country_id FROM countries WHERE fifa_code='QAT'), 68895);

INSERT IGNORE INTO countries (name, fifa_code, confederation) VALUES ('South Africa','ZAF','CAF');

-- ============================================================
-- STEP 4: MATCHES — KEY MATCHES FEATURING TOP SCORERS
-- Each match has real score and stage
-- ============================================================

-- Helper: we'll use tournament_id references
-- 1990=1, 1994=2, 1998=3, 2002=4, 2006=5, 2010=6, 2014=7, 2018=8, 2022=9

INSERT INTO matches
  (tournament_id, stadium_id, match_date, stage, group_label,
   home_team_id, away_team_id, home_goals, away_goals,
   home_goals_et, away_goals_et, penalties, home_pen_score, away_pen_score, attendance)
VALUES

-- ============================================================
-- 1990 ITALY — Schillaci's World Cup
-- ============================================================
-- Group C: Italy 1-0 Austria
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-06-09', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='AUT'), 1, 0, 0,0, FALSE, NULL, NULL, 72303),

-- Group C: Italy 2-0 USA
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-06-14', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='USA'), 2, 0, 0,0, FALSE, NULL, NULL, 73423),

-- Group C: Italy 2-0 Czechoslovakia
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-06-19', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='CZE'), 2, 0, 0,0, FALSE, NULL, NULL, 51426),

-- Round of 16: Italy 2-0 Uruguay
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-06-25', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='URU'), 2, 0, 0,0, FALSE, NULL, NULL, 73303),

-- QF: Italy 1-0 Ireland
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-06-30', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='IRL'), 1, 0, 0,0, FALSE, NULL, NULL, 73303),

-- SF: Italy 1-1 Argentina (AET, ARG win pens 4-3)
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-07-03', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='ARG'), 1, 1, 0,0, TRUE, 3, 4, 59978),

-- 3rd Place: Italy 2-1 England (Schillaci goal)
((SELECT tournament_id FROM tournaments WHERE year=1990), NULL, '1990-07-07', 'Third Place', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='ENG'), 2, 1, 0,0, FALSE, NULL, NULL, 51426),

-- ============================================================
-- 1994 USA — Romário, Ronaldo debut
-- ============================================================
-- Group B: Brazil 2-0 Russia
((SELECT tournament_id FROM tournaments WHERE year=1994), NULL, '1994-06-20', 'Group', 'B',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='RUS'), 2, 0, 0,0, FALSE, NULL, NULL, 76942),

-- Group B: Brazil 3-0 Cameroon
((SELECT tournament_id FROM tournaments WHERE year=1994), NULL, '1994-06-24', 'Group', 'B',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='CMR'), 3, 0, 0,0, FALSE, NULL, NULL, 77000),

-- Final: Brazil 0-0 Italy (BRA win pens 3-2)
((SELECT tournament_id FROM tournaments WHERE year=1994),
 (SELECT stadium_id FROM stadiums WHERE name='Rose Bowl'), '1994-07-17', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='ITA'), 0, 0, 0,0, TRUE, 3, 2, 94194),

-- ============================================================
-- 1998 FRANCE — Ronaldo, Zidane, Šuker
-- ============================================================
-- Group D: Spain 2-3 Nigeria
((SELECT tournament_id FROM tournaments WHERE year=1998), NULL, '1998-06-13', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='NGA'), 2, 3, 0,0, FALSE, NULL, NULL, 43000),

-- Group H: Croatia 3-1 Jamaica (Šuker 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=1998), NULL, '1998-06-14', 'Group', 'H',
 (SELECT country_id FROM countries WHERE fifa_code='CRO'),
 (SELECT country_id FROM countries WHERE fifa_code='JAM'), 3, 1, 0,0, FALSE, NULL, NULL, 35500),

-- Group A: Brazil 2-1 Morocco (Ronaldo goal)
((SELECT tournament_id FROM tournaments WHERE year=1998), NULL, '1998-06-16', 'Group', 'A',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='MAR'), 3, 0, 0,0, FALSE, NULL, NULL, 33257),

-- QF: Croatia 3-0 Germany (Šuker goal)
((SELECT tournament_id FROM tournaments WHERE year=1998), NULL, '1998-07-04', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='CRO'),
 (SELECT country_id FROM countries WHERE fifa_code='GER'), 3, 0, 0,0, FALSE, NULL, NULL, 45500),

-- SF: France 2-1 Croatia (Šuker goal)
((SELECT tournament_id FROM tournaments WHERE year=1998), NULL, '1998-07-08', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='CRO'), 2, 1, 0,0, FALSE, NULL, NULL, 76000),

-- Final: France 3-0 Brazil (Zidane 2)
((SELECT tournament_id FROM tournaments WHERE year=1998),
 (SELECT stadium_id FROM stadiums WHERE name='Stade de France'), '1998-07-12', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='BRA'), 3, 0, 0,0, FALSE, NULL, NULL, 80000),

-- ============================================================
-- 2002 SOUTH KOREA/JAPAN — Ronaldo 8 goals
-- ============================================================
-- Group C: Brazil 2-1 Turkey (Ronaldo goal)
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-03', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='TUR'), 2, 1, 0,0, FALSE, NULL, NULL, 42114),

-- Group C: Brazil 5-2 China (Ronaldo 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-08', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='CHN'), 4, 0, 0,0, FALSE, NULL, NULL, 50265),

-- Group C: Brazil 2-0 Costa Rica (Ronaldo goal)
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-13', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='CRC'), 5, 2, 0,0, FALSE, NULL, NULL, 25176),

-- Round of 16: Brazil 2-0 Belgium (Ronaldo 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-17', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='BEL'), 2, 0, 0,0, FALSE, NULL, NULL, 36472),

-- QF: Brazil 2-1 England (Ronaldo goal)
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-21', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='ENG'), 2, 1, 0,0, FALSE, NULL, NULL, 50217),

-- SF: Brazil 1-0 Turkey
((SELECT tournament_id FROM tournaments WHERE year=2002), NULL, '2002-06-26', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='TUR'), 1, 0, 0,0, FALSE, NULL, NULL, 65256),

-- Final: Brazil 2-0 Germany (Ronaldo 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2002),
 (SELECT stadium_id FROM stadiums WHERE name='Yokohama Stadium'), '2002-06-30', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='BRA'),
 (SELECT country_id FROM countries WHERE fifa_code='GER'), 2, 0, 0,0, FALSE, NULL, NULL, 69029),

-- ============================================================
-- 2006 GERMANY — Klose 5 goals, Ronaldo final goal
-- ============================================================
-- Group A: Germany 4-2 Costa Rica (Klose 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2006),
 (SELECT stadium_id FROM stadiums WHERE name='Olympiastadion'), '2006-06-09', 'Group', 'A',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='CRC'), 4, 2, 0,0, FALSE, NULL, NULL, 67000),

-- Group A: Germany 1-0 Poland (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-06-14', 'Group', 'A',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='POL'), 1, 0, 0,0, FALSE, NULL, NULL, 43000),

-- Group A: Germany 3-0 Ecuador (Klose 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-06-20', 'Group', 'A',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='ECU'), 3, 0, 0,0, FALSE, NULL, NULL, 48000),

-- Group D: Portugal 2-0 Iran (Ronaldo goal)
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-06-17', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='POR'),
 (SELECT country_id FROM countries WHERE fifa_code='IRN'), 2, 0, 0,0, FALSE, NULL, NULL, 52000),

-- Round of 16: Germany 2-0 Sweden (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-06-24', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='SWE'), 2, 0, 0,0, FALSE, NULL, NULL, 72000),

-- SF: Germany 0-2 Italy
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-07-04', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='ITA'), 0, 2, 0,2, FALSE, NULL, NULL, 66000),

-- 3rd: Germany 3-1 Portugal (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2006), NULL, '2006-07-08', 'Third Place', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='POR'), 3, 1, 0,0, FALSE, NULL, NULL, 52000),

-- Final: Italy 1-1 France AET (Italy pens 5-3)
((SELECT tournament_id FROM tournaments WHERE year=2006),
 (SELECT stadium_id FROM stadiums WHERE name='Olympiastadion'), '2006-07-09', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ITA'),
 (SELECT country_id FROM countries WHERE fifa_code='FRA'), 1, 1, 0,0, TRUE, 5, 3, 69000),

-- ============================================================
-- 2010 SOUTH AFRICA — Klose 4 goals, Villa 5 goals
-- ============================================================
-- Group D: Germany 4-0 Australia (Klose 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-13', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='AUS'), 4, 0, 0,0, FALSE, NULL, NULL, 64100),

-- Group D: Germany 0-1 Serbia
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-18', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='SRB'), 0, 1, 0,0, FALSE, NULL, NULL, 40853),

-- Group D: Germany 1-0 Ghana (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-23', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='GHA'), 1, 0, 0,0, FALSE, NULL, NULL, 37919),

-- Group H: Spain 0-1 Switzerland
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-16', 'Group', 'H',
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='SUI'), 0, 1, 0,0, FALSE, NULL, NULL, 43413),

-- Group H: Spain 2-0 Honduras (Villa 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-21', 'Group', 'H',
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='HON'), 2, 0, 0,0, FALSE, NULL, NULL, 48489),

-- Group H: Spain 2-1 Chile (Villa goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-25', 'Group', 'H',
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='CHI'), 2, 1, 0,0, FALSE, NULL, NULL, 64100),

-- Round of 16: Germany 4-1 England (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-27', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='ENG'), 4, 1, 0,0, FALSE, NULL, NULL, 46057),

-- Round of 16: Spain 1-0 Portugal (Villa goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-06-29', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='POR'), 1, 0, 0,0, FALSE, NULL, NULL, 63000),

-- QF: Germany 4-0 Argentina (Klose goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-07-03', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='ARG'), 4, 0, 0,0, FALSE, NULL, NULL, 77000),

-- QF: Spain 1-0 Paraguay (Villa goal)
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-07-03', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='PAR'), 1, 0, 0,0, FALSE, NULL, NULL, 62000),

-- SF: Spain 1-0 Germany
((SELECT tournament_id FROM tournaments WHERE year=2010), NULL, '2010-07-07', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='GER'), 1, 0, 0,0, FALSE, NULL, NULL, 84490),

-- Final: Spain 1-0 Netherlands AET (Iniesta)
((SELECT tournament_id FROM tournaments WHERE year=2010),
 (SELECT stadium_id FROM stadiums WHERE name='Soccer City'), '2010-07-11', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ESP'),
 (SELECT country_id FROM countries WHERE fifa_code='NED'), 1, 0, 1,0, FALSE, NULL, NULL, 84490),

-- ============================================================
-- 2014 BRAZIL — Klose record 16th goal, Messi 4, James 6
-- ============================================================
-- Group G: Germany 4-0 Portugal (Müller hat-trick)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-16', 'Group', 'G',
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='POR'), 4, 0, 0,0, FALSE, NULL, NULL, 63267),

-- Group F: Argentina 2-1 Bosnia (Messi goal)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-15', 'Group', 'F',
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='BIH'), 2, 1, 0,0, FALSE, NULL, NULL, 72000),

-- Group C: Colombia 3-0 Greece (James goal)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-14', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='COL'),
 (SELECT country_id FROM countries WHERE fifa_code='GRE'), 3, 0, 0,0, FALSE, NULL, NULL, 41770),

-- Group C: Colombia 2-1 Ivory Coast (James 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-19', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='COL'),
 (SELECT country_id FROM countries WHERE fifa_code='CIV'), 2, 1, 0,0, FALSE, NULL, NULL, 42000),

-- Group C: Colombia 4-1 Japan (James 2 goals)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-24', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='COL'),
 (SELECT country_id FROM countries WHERE fifa_code='JPN'), 4, 1, 0,0, FALSE, NULL, NULL, 39081),

-- Round of 16: Colombia 2-0 Uruguay (James brace)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-06-28', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='COL'),
 (SELECT country_id FROM countries WHERE fifa_code='URU'), 2, 0, 0,0, FALSE, NULL, NULL, 57698),

-- QF: Argentina 1-0 Belgium (Messi assists, Higuaín goal)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-07-05', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='BEL'), 1, 0, 0,0, FALSE, NULL, NULL, 74738),

-- SF: Germany 7-1 Brazil (Klose 16th WC goal — record!)
((SELECT tournament_id FROM tournaments WHERE year=2014),
 (SELECT stadium_id FROM stadiums WHERE name='Estádio do Maracanã'), '2014-07-08', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='BRA'), 7, 1, 0,0, FALSE, NULL, NULL, 74738),

-- SF: Argentina 0-0 Netherlands AET (ARG pens 4-2)
((SELECT tournament_id FROM tournaments WHERE year=2014), NULL, '2014-07-09', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='NED'), 0, 0, 0,0, TRUE, 4, 2, 63267),

-- Final: Germany 1-0 Argentina AET (Götze)
((SELECT tournament_id FROM tournaments WHERE year=2014),
 (SELECT stadium_id FROM stadiums WHERE name='Estádio do Maracanã'), '2014-07-13', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='GER'),
 (SELECT country_id FROM countries WHERE fifa_code='ARG'), 1, 0, 1,0, FALSE, NULL, NULL, 74738),

-- ============================================================
-- 2018 RUSSIA — Mbappé 4, Kane 6, Modrić
-- ============================================================
-- Group G: England 6-1 Panama (Kane hat-trick)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-06-24', 'Group', 'G',
 (SELECT country_id FROM countries WHERE fifa_code='ENG'),
 (SELECT country_id FROM countries WHERE fifa_code='PAN'), 6, 1, 0,0, FALSE, NULL, NULL, 45011),

-- Group G: England 2-1 Tunisia (Kane brace)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-06-18', 'Group', 'G',
 (SELECT country_id FROM countries WHERE fifa_code='ENG'),
 (SELECT country_id FROM countries WHERE fifa_code='TUN'), 2, 1, 0,0, FALSE, NULL, NULL, 44190),

-- Group C: France 2-1 Australia (Mbappé assist, Griezmann goal)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-06-16', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='AUS'), 2, 1, 0,0, FALSE, NULL, NULL, 43319),

-- Group C: France 1-0 Peru (Mbappé goal)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-06-21', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='PER'), 1, 0, 0,0, FALSE, NULL, NULL, 41426),

-- Round of 16: France 4-3 Argentina (Mbappé brace!)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-06-30', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='ARG'), 4, 3, 0,0, FALSE, NULL, NULL, 42873),

-- Round of 16: England 2-0 Colombia (Kane pen)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-07-03', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ENG'),
 (SELECT country_id FROM countries WHERE fifa_code='COL'), 1, 1, 0,0, TRUE, 4, 3, 41323),

-- SF: France 1-0 Belgium (Umtiti, Mbappé assist)
((SELECT tournament_id FROM tournaments WHERE year=2018), NULL, '2018-07-10', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='BEL'), 1, 0, 0,0, FALSE, NULL, NULL, 78011),

-- Final: France 4-2 Croatia (Mbappé goal)
((SELECT tournament_id FROM tournaments WHERE year=2018),
 (SELECT stadium_id FROM stadiums WHERE name='Luzhniki Stadium'), '2018-07-15', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='CRO'), 4, 2, 0,0, FALSE, NULL, NULL, 78011),

-- ============================================================
-- 2022 QATAR — Messi 7, Mbappé 8
-- ============================================================
-- Group C: Argentina 1-2 Saudi Arabia (SHOCK)
((SELECT tournament_id FROM tournaments WHERE year=2022),
 (SELECT stadium_id FROM stadiums WHERE name='Lusail Iconic Stadium'), '2022-11-22', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='KSA'), 1, 2, 0,0, FALSE, NULL, NULL, 88012),

-- Group C: Argentina 2-0 Mexico (Messi goal)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-11-26', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='MEX'), 2, 0, 0,0, FALSE, NULL, NULL, 88966),

-- Group C: Argentina 2-0 Poland (Messi pen)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-11-30', 'Group', 'C',
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='POL'), 2, 0, 0,0, FALSE, NULL, NULL, 88012),

-- Group D: France 4-1 Australia (Mbappé goal)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-11-22', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='AUS'), 4, 1, 0,0, FALSE, NULL, NULL, 67372),

-- Group D: France 2-1 Denmark (Mbappé brace)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-11-26', 'Group', 'D',
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='DEN'), 2, 1, 0,0, FALSE, NULL, NULL, 43418),

-- Round of 16: Argentina 2-1 Australia (Messi goal)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-12-03', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='AUS'), 2, 1, 0,0, FALSE, NULL, NULL, 88966),

-- Round of 16: France 3-1 Poland (Mbappé brace)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-12-04', 'Round of 16', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='POL'), 3, 1, 0,0, FALSE, NULL, NULL, 44667),

-- QF: Argentina 2-2 Netherlands AET (ARG pens 4-3, Messi goal+pen)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-12-09', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='NED'), 2, 2, 2,2, TRUE, 4, 3, 88966),

-- QF: France 2-1 England (Mbappé pen)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-12-10', 'Quarter-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='ENG'), 2, 1, 0,0, FALSE, NULL, NULL, 68295),

-- SF: Argentina 3-0 Croatia (Messi pen + assist, Álvarez 2)
((SELECT tournament_id FROM tournaments WHERE year=2022),
 (SELECT stadium_id FROM stadiums WHERE name='Lusail Iconic Stadium'), '2022-12-13', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='CRO'), 3, 0, 0,0, FALSE, NULL, NULL, 88966),

-- SF: France 2-0 Morocco (Mbappé assist x2)
((SELECT tournament_id FROM tournaments WHERE year=2022), NULL, '2022-12-14', 'Semi-final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='FRA'),
 (SELECT country_id FROM countries WHERE fifa_code='MAR'), 2, 0, 0,0, FALSE, NULL, NULL, 44020),

-- Final: Argentina 3-3 France AET (ARG pens 4-2) — GREATEST FINAL EVER
((SELECT tournament_id FROM tournaments WHERE year=2022),
 (SELECT stadium_id FROM stadiums WHERE name='Lusail Iconic Stadium'), '2022-12-18', 'Final', NULL,
 (SELECT country_id FROM countries WHERE fifa_code='ARG'),
 (SELECT country_id FROM countries WHERE fifa_code='FRA'), 3, 3, 3,3, TRUE, 4, 2, 88966);

-- ============================================================
-- STEP 5: PLAYER TOURNAMENT STATS — COMPLETE CAREER STATS
-- The 10 all-time top scorers with full data
-- ============================================================

INSERT INTO player_tournament_stats
  (player_id, tournament_id, matches_played, goals, assists, yellow_cards, red_cards, minutes_played)
VALUES

-- ══════════════════════════════════════════════════════════
-- #1 MIROSLAV KLOSE (GER) — 16 WC GOALS (WORLD RECORD)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Miroslav Klose'),
 (SELECT tournament_id FROM tournaments WHERE year=2002), 7, 5, 1, 1, 0, 630),
((SELECT player_id FROM players WHERE full_name='Miroslav Klose'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 7, 5, 1, 1, 0, 585),
((SELECT player_id FROM players WHERE full_name='Miroslav Klose'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 6, 4, 1, 0, 0, 504),
((SELECT player_id FROM players WHERE full_name='Miroslav Klose'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 7, 2, 2, 0, 0, 448),

-- ══════════════════════════════════════════════════════════
-- #2 RONALDO NAZÁRIO (BRA) — 15 WC GOALS
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'),
 (SELECT tournament_id FROM tournaments WHERE year=1994), 2, 0, 0, 0, 0, 73),
((SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 7, 4, 2, 0, 0, 630),
((SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'),
 (SELECT tournament_id FROM tournaments WHERE year=2002), 7, 8, 1, 0, 0, 630),
((SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 5, 3, 0, 1, 0, 411),

-- ══════════════════════════════════════════════════════════
-- #3 LIONEL MESSI (ARG) — 13 WC GOALS (active record)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Lionel Messi'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 3, 1, 0, 0, 0, 251),
((SELECT player_id FROM players WHERE full_name='Lionel Messi'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 5, 0, 1, 0, 0, 450),
((SELECT player_id FROM players WHERE full_name='Lionel Messi'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 7, 4, 1, 0, 0, 690),
((SELECT player_id FROM players WHERE full_name='Lionel Messi'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 4, 1, 0, 1, 0, 360),
((SELECT player_id FROM players WHERE full_name='Lionel Messi'),
 (SELECT tournament_id FROM tournaments WHERE year=2022), 7, 7, 3, 0, 0, 690),

-- ══════════════════════════════════════════════════════════
-- #4 KYLIAN MBAPPÉ (FRA) — 12 WC GOALS (and counting)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Kylian Mbappé'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 7, 4, 2, 0, 0, 548),
((SELECT player_id FROM players WHERE full_name='Kylian Mbappé'),
 (SELECT tournament_id FROM tournaments WHERE year=2022), 7, 8, 2, 1, 0, 690),

-- ══════════════════════════════════════════════════════════
-- #5 JÜRGEN KLINSMANN (GER) — 11 WC GOALS
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Jürgen Klinsmann'),
 (SELECT tournament_id FROM tournaments WHERE year=1990), 7, 3, 1, 1, 0, 630),
((SELECT player_id FROM players WHERE full_name='Jürgen Klinsmann'),
 (SELECT tournament_id FROM tournaments WHERE year=1994), 7, 5, 2, 0, 0, 630),
((SELECT player_id FROM players WHERE full_name='Jürgen Klinsmann'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 6, 3, 1, 1, 0, 480),

-- ══════════════════════════════════════════════════════════
-- #6 SALVATORE SCHILLACI (ITA) — 6 WC GOALS (1990 only, Golden Boot)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Salvatore Schillaci'),
 (SELECT tournament_id FROM tournaments WHERE year=1990), 7, 6, 1, 1, 0, 605),

-- ══════════════════════════════════════════════════════════
-- #7 CRISTIANO RONALDO (POR) — 8 WC GOALS
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Cristiano Ronaldo'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 6, 1, 2, 1, 0, 513),
((SELECT player_id FROM players WHERE full_name='Cristiano Ronaldo'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 4, 1, 0, 0, 0, 360),
((SELECT player_id FROM players WHERE full_name='Cristiano Ronaldo'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 3, 1, 0, 1, 0, 270),
((SELECT player_id FROM players WHERE full_name='Cristiano Ronaldo'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 4, 4, 1, 0, 0, 360),
((SELECT player_id FROM players WHERE full_name='Cristiano Ronaldo'),
 (SELECT tournament_id FROM tournaments WHERE year=2022), 5, 1, 0, 1, 0, 376),

-- ══════════════════════════════════════════════════════════
-- #8 DAVOR ŠUKER (CRO) — 6 WC GOALS (1998 Golden Boot)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Davor Šuker'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 7, 6, 1, 0, 0, 558),

-- ══════════════════════════════════════════════════════════
-- #9 HARRY KANE (ENG) — 6 WC GOALS (2018 Golden Boot)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Harry Kane'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 6, 6, 0, 0, 0, 514),
((SELECT player_id FROM players WHERE full_name='Harry Kane'),
 (SELECT tournament_id FROM tournaments WHERE year=2022), 5, 3, 1, 1, 0, 450),

-- ══════════════════════════════════════════════════════════
-- #10 JAMES RODRÍGUEZ (COL) — 6 WC GOALS (2014 Golden Boot)
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='James Rodríguez'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 5, 6, 2, 0, 0, 450),
((SELECT player_id FROM players WHERE full_name='James Rodríguez'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 3, 0, 1, 1, 0, 203),

-- ══════════════════════════════════════════════════════════
-- BONUS: Other great scorers
-- ══════════════════════════════════════════════════════════
((SELECT player_id FROM players WHERE full_name='Thomas Müller'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 7, 5, 3, 2, 0, 618),
((SELECT player_id FROM players WHERE full_name='Thomas Müller'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 7, 5, 1, 1, 0, 585),
((SELECT player_id FROM players WHERE full_name='Thomas Müller'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 3, 0, 0, 1, 0, 236),

((SELECT player_id FROM players WHERE full_name='Romário'),
 (SELECT tournament_id FROM tournaments WHERE year=1994), 7, 5, 3, 0, 0, 630),

((SELECT player_id FROM players WHERE full_name='David Villa'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 4, 3, 0, 0, 0, 270),
((SELECT player_id FROM players WHERE full_name='David Villa'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 7, 5, 2, 0, 0, 602),

((SELECT player_id FROM players WHERE full_name='Zinedine Zidane'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 7, 3, 3, 0, 0, 630),
((SELECT player_id FROM players WHERE full_name='Zinedine Zidane'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 7, 3, 2, 1, 1, 630),

((SELECT player_id FROM players WHERE full_name='Thierry Henry'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 7, 3, 2, 0, 0, 509),
((SELECT player_id FROM players WHERE full_name='Thierry Henry'),
 (SELECT tournament_id FROM tournaments WHERE year=2006), 7, 3, 3, 0, 0, 590),

((SELECT player_id FROM players WHERE full_name='Roberto Baggio'),
 (SELECT tournament_id FROM tournaments WHERE year=1990), 7, 2, 3, 0, 0, 430),
((SELECT player_id FROM players WHERE full_name='Roberto Baggio'),
 (SELECT tournament_id FROM tournaments WHERE year=1994), 7, 5, 2, 1, 0, 585),
((SELECT player_id FROM players WHERE full_name='Roberto Baggio'),
 (SELECT tournament_id FROM tournaments WHERE year=1998), 4, 2, 1, 0, 0, 298),

((SELECT player_id FROM players WHERE full_name='Antoine Griezmann'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 5, 0, 1, 0, 0, 360),
((SELECT player_id FROM players WHERE full_name='Antoine Griezmann'),
 (SELECT tournament_id FROM tournaments WHERE year=2018), 7, 4, 2, 0, 0, 612),
((SELECT player_id FROM players WHERE full_name='Antoine Griezmann'),
 (SELECT tournament_id FROM tournaments WHERE year=2022), 7, 1, 3, 0, 0, 558),

((SELECT player_id FROM players WHERE full_name='Luis Suárez'),
 (SELECT tournament_id FROM tournaments WHERE year=2010), 5, 3, 1, 1, 1, 404),
((SELECT player_id FROM players WHERE full_name='Luis Suárez'),
 (SELECT tournament_id FROM tournaments WHERE year=2014), 2, 2, 0, 1, 0, 180);

-- ============================================================
-- STEP 6: GOALS TABLE — minute-by-minute records
-- KEY HISTORIC GOALS
-- ============================================================
INSERT INTO goals (match_id, player_id, minute, is_penalty, is_own_goal, is_extra_time)
VALUES

-- ── 2022 FINAL: Argentina 3-3 France AET (pens 4-2) ──
-- Messi pen 23', Di María 36', Messi 69' | Mbappé 80', 81' pen, Mbappé 118'
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2022 AND h.fifa_code='ARG' AND a.fifa_code='FRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Lionel Messi'), 23, TRUE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2022 AND h.fifa_code='ARG' AND a.fifa_code='FRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Lionel Messi'), 69, FALSE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2022 AND h.fifa_code='ARG' AND a.fifa_code='FRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Kylian Mbappé'), 80, FALSE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2022 AND h.fifa_code='ARG' AND a.fifa_code='FRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Kylian Mbappé'), 81, TRUE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2022 AND h.fifa_code='ARG' AND a.fifa_code='FRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Kylian Mbappé'), 118, FALSE, FALSE, TRUE),

-- ── 2014 SF: Germany 7-1 Brazil (Klose record 16th goal) ──
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2014 AND h.fifa_code='GER' AND a.fifa_code='BRA' AND m.stage='Semi-final'),
 (SELECT player_id FROM players WHERE full_name='Miroslav Klose'), 23, FALSE, FALSE, FALSE),

-- ── 2002 FINAL: Brazil 2-0 Germany (Ronaldo's 15th WC goal) ──
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2002 AND h.fifa_code='BRA' AND a.fifa_code='GER' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'), 67, FALSE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2002 AND h.fifa_code='BRA' AND a.fifa_code='GER' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Ronaldo Nazário'), 79, FALSE, FALSE, FALSE),

-- ── 1998 FINAL: France 3-0 Brazil (Zidane brace) ──
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=1998 AND h.fifa_code='FRA' AND a.fifa_code='BRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Zinedine Zidane'), 27, FALSE, FALSE, FALSE),

((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=1998 AND h.fifa_code='FRA' AND a.fifa_code='BRA' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Zinedine Zidane'), 45, FALSE, FALSE, FALSE),

-- ── 2018 FINAL: France 4-2 Croatia (Mbappé goal) ──
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2018 AND h.fifa_code='FRA' AND a.fifa_code='CRO' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Kylian Mbappé'), 65, FALSE, FALSE, FALSE),

-- ── 2010 FINAL: Spain 1-0 Netherlands (Iniesta) ──
((SELECT match_id FROM matches m JOIN tournaments t ON m.tournament_id=t.tournament_id
  JOIN countries h ON m.home_team_id=h.country_id JOIN countries a ON m.away_team_id=a.country_id
  WHERE t.year=2010 AND h.fifa_code='ESP' AND a.fifa_code='NED' AND m.stage='Final'),
 (SELECT player_id FROM players WHERE full_name='Andrés Iniesta'), 116, FALSE, FALSE, TRUE);

-- ============================================================
-- STEP 7: THE DEFINITIVE TOP 10 SCORER VIEW
-- ============================================================
CREATE OR REPLACE VIEW vw_top10_scorers_all_time AS
SELECT
    RANK() OVER (ORDER BY SUM(pts.goals) DESC)  AS `rank`,
    p.full_name                                  AS player,
    c.name                                       AS country,
    c.confederation,
    p.position,
    p.date_of_birth,
    COUNT(DISTINCT pts.tournament_id)            AS world_cups_played,
    SUM(pts.matches_played)                      AS total_matches,
    SUM(pts.goals)                               AS total_goals,
    SUM(pts.assists)                             AS total_assists,
    SUM(pts.goals) + SUM(pts.assists)            AS goal_contributions,
    SUM(pts.minutes_played)                      AS total_minutes,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.matches_played),0), 3)  AS goals_per_match,
    ROUND(SUM(pts.goals) /
          NULLIF(SUM(pts.minutes_played),0)*90,2) AS goals_per_90_min,
    SUM(pts.yellow_cards)                        AS yellow_cards,
    SUM(pts.red_cards)                           AS red_cards,
    MIN(pts.tournament_id)                       AS first_wc_year_id,
    MAX(pts.tournament_id)                       AS last_wc_year_id
FROM player_tournament_stats pts
JOIN players   p ON pts.player_id  = p.player_id
JOIN countries c ON p.country_id   = c.country_id
GROUP BY p.player_id
ORDER BY total_goals DESC
LIMIT 10;

-- ============================================================
-- STEP 8: VIEW — scorers broken down by tournament
-- ============================================================
CREATE OR REPLACE VIEW vw_top_scorers_by_tournament AS
SELECT
    t.year                  AS world_cup_year,
    t.host_country,
    p.full_name             AS player,
    c.name                  AS country,
    p.position,
    pts.matches_played,
    pts.goals,
    pts.assists,
    pts.goals + pts.assists AS contributions,
    pts.yellow_cards,
    pts.red_cards,
    pts.minutes_played,
    ROUND(pts.goals /
          NULLIF(pts.matches_played,0), 2) AS goals_per_match
FROM player_tournament_stats pts
JOIN players     p ON pts.player_id    = p.player_id
JOIN countries   c ON p.country_id     = c.country_id
JOIN tournaments t ON pts.tournament_id = t.tournament_id
ORDER BY t.year, pts.goals DESC;

-- ============================================================
-- STEP 9: VIEW — goals with full match context
-- ============================================================
CREATE OR REPLACE VIEW vw_goals_with_match_context AS
SELECT
    t.year                  AS world_cup,
    m.stage,
    m.match_date,
    h.name                  AS home_team,
    m.home_goals,
    m.away_goals,
    a.name                  AS away_team,
    CASE WHEN m.penalties THEN CONCAT(m.home_pen_score,'-',m.away_pen_score,' (pens)') END AS penalty_score,
    p.full_name             AS scorer,
    scorer_country.name     AS scorer_country,
    g.minute,
    g.is_penalty,
    g.is_own_goal,
    g.is_extra_time,
    m.attendance
FROM goals g
JOIN matches     m ON g.match_id   = m.match_id
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN countries   h ON m.home_team_id  = h.country_id
JOIN countries   a ON m.away_team_id  = a.country_id
JOIN players     p ON g.player_id     = p.player_id
JOIN countries   scorer_country ON p.country_id = scorer_country.country_id
ORDER BY t.year, m.match_date, g.minute;

-- ============================================================
-- STEP 10: KEY ANALYTICAL QUERIES FOR TOP SCORERS
-- ============================================================

-- ── QUERY 1: THE DEFINITIVE TOP 10 ALL-TIME ──────────────
SELECT
    `rank`,
    player,
    country,
    world_cups_played,
    total_matches,
    total_goals,
    total_assists,
    goal_contributions,
    goals_per_match,
    goals_per_90_min,
    yellow_cards,
    red_cards
FROM vw_top10_scorers_all_time;

-- ── QUERY 2: TOURNAMENT-BY-TOURNAMENT BREAKDOWN ──────────
SELECT world_cup_year, host_country, player, country,
       matches_played, goals, assists, contributions, minutes_played
FROM vw_top_scorers_by_tournament
WHERE player IN (
    'Miroslav Klose','Ronaldo Nazário','Lionel Messi',
    'Kylian Mbappé','Jürgen Klinsmann','Salvatore Schillaci',
    'Davor Šuker','Harry Kane','James Rodríguez','Cristiano Ronaldo'
)
ORDER BY player, world_cup_year;

-- ── QUERY 3: WHO SCORED IN FINALS? ──────────────────────
SELECT world_cup, stage, home_team, home_goals, away_goals, away_team,
       scorer, scorer_country, minute, is_penalty, is_extra_time
FROM vw_goals_with_match_context
WHERE stage = 'Final'
ORDER BY world_cup, minute;

-- ── QUERY 4: SCORING RATES COMPARED ─────────────────────
SELECT
    player, country,
    total_goals,
    total_assists,
    total_matches,
    total_minutes,
    goals_per_match,
    goals_per_90_min
FROM vw_top10_scorers_all_time
ORDER BY goals_per_90_min DESC;

-- ── QUERY 5: TOP GOALS PER SINGLE TOURNAMENT ─────────────
SELECT
    player, country,
    world_cup_year,
    host_country,
    goals  AS goals_in_tournament,
    assists,
    matches_played
FROM vw_top_scorers_by_tournament
ORDER BY goals DESC
LIMIT 15;

-- ── QUERY 6: GOLDEN BOOT WINNERS ─────────────────────────
SELECT
    t.year,
    t.host_country,
    t.golden_boot AS golden_boot_winner,
    t.champion,
    t.total_goals,
    ROUND(t.total_goals/t.total_matches,2) AS avg_goals_per_match
FROM tournaments t
ORDER BY t.year;

-- ── QUERY 7: STORED PROCEDURE — full career breakdown ────
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_scorer_career$$
CREATE PROCEDURE sp_scorer_career(IN p_name VARCHAR(150))
BEGIN
    SELECT
        p.full_name,
        c.name               AS country,
        t.year               AS world_cup,
        t.host_country,
        pts.matches_played,
        pts.goals,
        pts.assists,
        pts.goals + pts.assists AS contributions,
        pts.yellow_cards,
        pts.minutes_played,
        ROUND(pts.goals/NULLIF(pts.matches_played,0),2) AS goals_per_match
    FROM player_tournament_stats pts
    JOIN players     p ON pts.player_id    = p.player_id
    JOIN countries   c ON p.country_id     = c.country_id
    JOIN tournaments t ON pts.tournament_id = t.tournament_id
    WHERE p.full_name LIKE CONCAT('%', p_name, '%')
    ORDER BY t.year;
END$$
DELIMITER ;

-- Usage examples:
-- CALL sp_scorer_career('Klose');
-- CALL sp_scorer_career('Messi');
-- CALL sp_scorer_career('Mbappé');
-- CALL sp_scorer_career('Ronaldo Nazário');
