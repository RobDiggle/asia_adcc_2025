--1. What was the total medal count per country in terms of golds, silvers and bronzes?

SELECT
    country,
    COUNT(*) FILTER (WHERE medal = 'Gold') AS golds,
    COUNT(*) FILTER (WHERE medal = 'Silver') AS silvers,
    COUNT(*) FILTER (WHERE medal = 'Bronze') AS bronzes,
    COUNT(*) AS total_medals
FROM asia_trials_2025_medals
GROUP BY country
ORDER BY golds DESC, total_medals DESC;

-- 2. Overall win rate vs loss rate by country, accounting for sample size

WITH country_results AS (
    SELECT
        winner_country AS country,
        1 AS wins,
        0 AS losses
    FROM asia_adcc_2025_trials
    WHERE winner_country IS NOT NULL
      AND winner_country <> ''

    UNION ALL

    SELECT
        loser_country AS country,
        0 AS wins,
        1 AS losses
    FROM asia_adcc_2025_trials
    WHERE loser_country IS NOT NULL
      AND loser_country <> ''
)

SELECT
    country,
    SUM(wins) AS total_wins,
    SUM(losses) AS total_losses,
    SUM(wins + losses) AS total_matches,
    ROUND(SUM(wins)::numeric / SUM(wins + losses) * 100, 2) AS win_rate_percent
FROM country_results
GROUP BY country
ORDER BY win_rate_percent DESC, total_matches DESC;

-- 3. Submission rate per country
-- Percentage of wins by submission

SELECT
    winner_country AS country,
    COUNT(*) AS total_wins,
    COUNT(*) FILTER (WHERE win_method = 'Submission') AS submission_wins,
    ROUND(
        COUNT(*) FILTER (WHERE win_method = 'Submission')::numeric
        / COUNT(*) * 100,
        2
    ) AS submission_rate_percent
FROM asia_adcc_2025_trials
WHERE winner_country IS NOT NULL
  AND winner_country <> ''
GROUP BY winner_country
ORDER BY submission_rate_percent DESC, total_wins DESC;

-- 4. Average match time per country

SELECT
    winner_country AS country,
    COUNT(*) AS wins_sample_size,
    ROUND(AVG(match_time_seconds), 2) AS avg_match_time_seconds
FROM asia_adcc_2025_trials
WHERE winner_country IS NOT NULL
  AND winner_country <> ''
  AND match_time_seconds IS NOT NULL
GROUP BY winner_country
ORDER BY avg_match_time_seconds ASC;

-- 5. Head-to-head records between countries

-- Head-to-head with wins, losses, and win %

WITH h2h AS (
    SELECT
        winner_country AS country_a,
        loser_country AS country_b,
        1 AS win,
        0 AS loss
    FROM asia_adcc_2025_trials
    WHERE winner_country IS NOT NULL
      AND loser_country IS NOT NULL
      AND winner_country <> ''
      AND loser_country <> ''
      AND winner_country <> loser_country

    UNION ALL

    SELECT
        loser_country AS country_a,
        winner_country AS country_b,
        0 AS win,
        1 AS loss
    FROM asia_adcc_2025_trials
    WHERE winner_country IS NOT NULL
      AND loser_country IS NOT NULL
      AND winner_country <> ''
      AND loser_country <> ''
      AND winner_country <> loser_country
)

SELECT
    country_a,
    country_b,
    SUM(win) AS wins,
    SUM(loss) AS losses,
    SUM(win + loss) AS total_matches,
    ROUND(SUM(win)::numeric / SUM(win + loss) * 100, 2) AS win_rate_percent
FROM h2h
GROUP BY country_a, country_b
ORDER BY country_a, win_rate_percent DESC;

-- 6. Upsets: lower-represented countries defeating higher-represented countries

WITH country_representation AS (
    SELECT
        country,
        COUNT(DISTINCT grappler_id) AS unique_athletes
    FROM (
        SELECT winner_country AS country, winner_grappler_id AS grappler_id
        FROM asia_adcc_2025_trials

        UNION

        SELECT loser_country AS country, loser_grappler_id AS grappler_id
        FROM asia_adcc_2025_trials
    ) AS athletes
    WHERE country IS NOT NULL
      AND country <> ''
      AND grappler_id IS NOT NULL
      AND grappler_id <> ''
    GROUP BY country
)

SELECT
    t.winner_name,
    t.winner_country,
    wr.unique_athletes AS winner_country_athletes,
    t.loser_name,
    t.loser_country,
    lr.unique_athletes AS loser_country_athletes,
    t.bracket,
    t.win_method,
    t.submission_type,
    t.match_time_seconds
FROM asia_adcc_2025_trials t
JOIN country_representation wr
    ON t.winner_country = wr.country
JOIN country_representation lr
    ON t.loser_country = lr.country
WHERE wr.unique_athletes < lr.unique_athletes
  AND t.winner_country <> t.loser_country
ORDER BY
    (lr.unique_athletes - wr.unique_athletes) DESC,
    t.winner_country;