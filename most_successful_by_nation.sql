-- Southeast Asia analysis

-- All Thai athletes with total wins

WITH thai_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Thailand'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Thailand'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM thai_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;

-- Singapore 

WITH singapore_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Singapore'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Singapore'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM singapore_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;

-- Vietnam

WITH vietnam_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Vietnam'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Vietnam'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM vietnam_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;

-- Malaysia

WITH malaysia_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Malaysia'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Malaysia'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM malaysia_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;

-- Philippines 

WITH philippines_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Philippines'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Philippines'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM philippines_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;

-- Cambodia

WITH cambodia_athletes AS (
    SELECT
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country = 'Cambodia'

    UNION ALL

    SELECT
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country = 'Cambodia'
)

SELECT
    athlete_name,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM cambodia_athletes
GROUP BY athlete_name
ORDER BY total_wins DESC, win_rate_percent DESC;


-- East Asia analysis (China,-- East Asia analysis

WITH east_asia_countries AS (
    SELECT unnest(ARRAY[
        'China',
        'Japan',
        'South Korea',
        'Taiwan',
        'Hong Kong',
        'Mongolia'
    ]) AS country
),
east_asia_athletes AS (
    SELECT
        winner_country AS country,
        winner_name AS athlete_name,
        1 AS win
    FROM asia_adcc_2025_trials
    WHERE winner_country IN (SELECT country FROM east_asia_countries)

    UNION ALL

    SELECT
        loser_country AS country,
        loser_name AS athlete_name,
        0 AS win
    FROM asia_adcc_2025_trials
    WHERE loser_country IN (SELECT country FROM east_asia_countries)
)

SELECT
    c.country,
    e.athlete_name,
    COALESCE(SUM(e.win), 0) AS total_wins,
    COUNT(e.athlete_name) AS total_matches,
    CASE
        WHEN COUNT(e.athlete_name) = 0 THEN 0
        ELSE ROUND(SUM(e.win)::numeric / COUNT(e.athlete_name) * 100, 2)
    END AS win_rate_percent
FROM east_asia_countries c
LEFT JOIN east_asia_athletes e
    ON c.country = e.country
GROUP BY c.country, e.athlete_name
ORDER BY c.country, total_wins DESC, win_rate_percent DESC; 

-- Central Asia analysis

-- Australia & NZ analysis



