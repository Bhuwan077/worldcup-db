-- ============================================================
--  FIFA WORLD CUP DATABASE (Modern Era 1990–2022)
--  Database: MySQL 8.0+
--  Author:   [Your Name]
--  GitHub:   https://github.com/[your-username]/worldcup-db
-- ============================================================

CREATE DATABASE IF NOT EXISTS worldcup_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE worldcup_db;

-- ============================================================
-- TABLE: tournaments
-- ============================================================
CREATE TABLE tournaments (
    tournament_id   INT           PRIMARY KEY AUTO_INCREMENT,
    year            YEAR          NOT NULL,
    host_country    VARCHAR(100)  NOT NULL,
    host_continent  VARCHAR(50)   NOT NULL,
    start_date      DATE          NOT NULL,
    end_date        DATE          NOT NULL,
    num_teams       TINYINT       NOT NULL DEFAULT 32,
    champion        VARCHAR(100),
    runner_up       VARCHAR(100),
    third_place     VARCHAR(100),
    fourth_place    VARCHAR(100),
    total_goals     SMALLINT,
    total_matches   TINYINT,
    golden_ball     VARCHAR(100)  COMMENT 'Best player of the tournament',
    golden_boot     VARCHAR(100)  COMMENT 'Top scorer',
    golden_glove    VARCHAR(100)  COMMENT 'Best goalkeeper',
    UNIQUE KEY uq_year (year)
) ENGINE=InnoDB COMMENT='One row per World Cup edition';

-- ============================================================
-- TABLE: countries
-- ============================================================
CREATE TABLE countries (
    country_id      INT           PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100)  NOT NULL,
    fifa_code       CHAR(3)       NOT NULL,
    confederation   ENUM('UEFA','CONMEBOL','CAF','AFC','CONCACAF','OFC') NOT NULL,
    UNIQUE KEY uq_fifa_code (fifa_code)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: tournament_teams
-- Participation record linking a country to a tournament
-- ============================================================
CREATE TABLE tournament_teams (
    id              INT           PRIMARY KEY AUTO_INCREMENT,
    tournament_id   INT           NOT NULL,
    country_id      INT           NOT NULL,
    group_stage     CHAR(1)       COMMENT 'Group letter: A-H',
    final_position  TINYINT       COMMENT 'Final rank (1=champion)',
    matches_played  TINYINT       DEFAULT 0,
    wins            TINYINT       DEFAULT 0,
    draws           TINYINT       DEFAULT 0,
    losses          TINYINT       DEFAULT 0,
    goals_for       TINYINT       DEFAULT 0,
    goals_against   TINYINT       DEFAULT 0,
    UNIQUE KEY uq_team_tournament (tournament_id, country_id),
    CONSTRAINT fk_tt_tournament FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id),
    CONSTRAINT fk_tt_country    FOREIGN KEY (country_id)    REFERENCES countries(country_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: stadiums
-- ============================================================
CREATE TABLE stadiums (
    stadium_id      INT           PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(150)  NOT NULL,
    city            VARCHAR(100)  NOT NULL,
    country_id      INT           NOT NULL,
    capacity        INT,
    CONSTRAINT fk_stadium_country FOREIGN KEY (country_id) REFERENCES countries(country_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: matches
-- ============================================================
CREATE TABLE matches (
    match_id        INT           PRIMARY KEY AUTO_INCREMENT,
    tournament_id   INT           NOT NULL,
    stadium_id      INT,
    match_date      DATE          NOT NULL,
    stage           ENUM('Group','Round of 16','Quarter-final','Semi-final','Third Place','Final') NOT NULL,
    group_label     CHAR(1)       COMMENT 'Null for knockout matches',
    home_team_id    INT           NOT NULL,
    away_team_id    INT           NOT NULL,
    home_goals      TINYINT       NOT NULL DEFAULT 0,
    away_goals      TINYINT       NOT NULL DEFAULT 0,
    home_goals_et   TINYINT       DEFAULT 0 COMMENT 'Goals in extra time',
    away_goals_et   TINYINT       DEFAULT 0,
    penalties       BOOLEAN       DEFAULT FALSE,
    home_pen_score  TINYINT,
    away_pen_score  TINYINT,
    attendance      INT,
    CONSTRAINT fk_match_tournament  FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id),
    CONSTRAINT fk_match_stadium     FOREIGN KEY (stadium_id)    REFERENCES stadiums(stadium_id),
    CONSTRAINT fk_match_home        FOREIGN KEY (home_team_id)  REFERENCES countries(country_id),
    CONSTRAINT fk_match_away        FOREIGN KEY (away_team_id)  REFERENCES countries(country_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: players
-- ============================================================
CREATE TABLE players (
    player_id       INT           PRIMARY KEY AUTO_INCREMENT,
    country_id      INT           NOT NULL,
    full_name       VARCHAR(150)  NOT NULL,
    date_of_birth   DATE,
    position        ENUM('GK','DF','MF','FW') NOT NULL,
    CONSTRAINT fk_player_country FOREIGN KEY (country_id) REFERENCES countries(country_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: player_tournament_stats
-- Aggregated stats per player per tournament
-- ============================================================
CREATE TABLE player_tournament_stats (
    id              INT           PRIMARY KEY AUTO_INCREMENT,
    player_id       INT           NOT NULL,
    tournament_id   INT           NOT NULL,
    matches_played  TINYINT       DEFAULT 0,
    goals           TINYINT       DEFAULT 0,
    assists         TINYINT       DEFAULT 0,
    yellow_cards    TINYINT       DEFAULT 0,
    red_cards       TINYINT       DEFAULT 0,
    minutes_played  SMALLINT      DEFAULT 0,
    UNIQUE KEY uq_player_tournament (player_id, tournament_id),
    CONSTRAINT fk_pts_player     FOREIGN KEY (player_id)     REFERENCES players(player_id),
    CONSTRAINT fk_pts_tournament FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: goals
-- ============================================================
CREATE TABLE goals (
    goal_id         INT           PRIMARY KEY AUTO_INCREMENT,
    match_id        INT           NOT NULL,
    player_id       INT           NOT NULL,
    minute          TINYINT       NOT NULL,
    is_penalty      BOOLEAN       DEFAULT FALSE,
    is_own_goal     BOOLEAN       DEFAULT FALSE,
    is_extra_time   BOOLEAN       DEFAULT FALSE,
    CONSTRAINT fk_goal_match  FOREIGN KEY (match_id)  REFERENCES matches(match_id),
    CONSTRAINT fk_goal_player FOREIGN KEY (player_id) REFERENCES players(player_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE: cards
-- ============================================================
CREATE TABLE cards (
    card_id         INT           PRIMARY KEY AUTO_INCREMENT,
    match_id        INT           NOT NULL,
    player_id       INT           NOT NULL,
    card_type       ENUM('Yellow','Second Yellow','Red') NOT NULL,
    minute          TINYINT       NOT NULL,
    CONSTRAINT fk_card_match  FOREIGN KEY (match_id)  REFERENCES matches(match_id),
    CONSTRAINT fk_card_player FOREIGN KEY (player_id) REFERENCES players(player_id)
) ENGINE=InnoDB;

-- ============================================================
-- VIEWS
-- ============================================================

-- All-time top scorers across modern era
CREATE OR REPLACE VIEW vw_alltime_top_scorers AS
SELECT
    p.full_name,
    c.name          AS country,
    p.position,
    SUM(pts.goals)  AS total_goals,
    SUM(pts.assists) AS total_assists,
    COUNT(DISTINCT pts.tournament_id) AS tournaments_played
FROM player_tournament_stats pts
JOIN players  p ON pts.player_id     = p.player_id
JOIN countries c ON p.country_id     = c.country_id
GROUP BY p.player_id
ORDER BY total_goals DESC;

-- Country performance summary across all editions
CREATE OR REPLACE VIEW vw_country_performance AS
SELECT
    c.name               AS country,
    c.confederation,
    COUNT(DISTINCT tt.tournament_id) AS tournaments,
    SUM(tt.wins)         AS total_wins,
    SUM(tt.draws)        AS total_draws,
    SUM(tt.losses)       AS total_losses,
    SUM(tt.goals_for)    AS goals_scored,
    SUM(tt.goals_against) AS goals_conceded,
    SUM(tt.goals_for) - SUM(tt.goals_against) AS goal_difference,
    MIN(tt.final_position) AS best_finish
FROM tournament_teams tt
JOIN countries c ON tt.country_id = c.country_id
GROUP BY c.country_id
ORDER BY total_wins DESC;

-- Match results with team names
CREATE OR REPLACE VIEW vw_match_results AS
SELECT
    t.year,
    m.stage,
    m.group_label,
    m.match_date,
    h.name  AS home_team,
    m.home_goals,
    m.away_goals,
    a.name  AS away_team,
    m.penalties,
    m.home_pen_score,
    m.away_pen_score,
    s.name  AS stadium,
    s.city,
    m.attendance
FROM matches m
JOIN tournaments t ON m.tournament_id = t.tournament_id
JOIN countries   h ON m.home_team_id  = h.country_id
JOIN countries   a ON m.away_team_id  = a.country_id
LEFT JOIN stadiums s ON m.stadium_id  = s.stadium_id
ORDER BY m.match_date;
