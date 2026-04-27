-- 1. Win rate per gym (min sample threshold = 5 matches)

WITH gym_results AS (
    SELECT
        gym_winner AS gym,
        1 AS win,
        1 AS match
    FROM asia_adcc_2025_trials

    UNION ALL

    SELECT
        gym_loser AS gym,
        0 AS win,
        1 AS match
    FROM asia_adcc_2025_trials
)

SELECT
    gym,
    SUM(win) AS total_wins,
    COUNT(*) AS total_matches,
    ROUND(SUM(win)::numeric / COUNT(*) * 100, 2) AS win_rate_percent
FROM gym_results
WHERE gym IS NOT NULL AND gym <> ''
GROUP BY gym
ORDER BY win_rate_percent DESC, total_matches DESC;

-- 2. Submission rate per gym

SELECT
    gym_winner AS gym,
    COUNT(*) AS total_wins,
    COUNT(*) FILTER (WHERE win_method = 'Submission') AS submission_wins,
    ROUND(
        COUNT(*) FILTER (WHERE win_method = 'Submission')::numeric
        / COUNT(*) * 100,
        2
    ) AS submission_rate_percent
FROM asia_adcc_2025_trials
WHERE gym_winner IS NOT NULL AND gym_winner <> ''
GROUP BY gym_winner
HAVING COUNT(*) >= 5
ORDER BY submission_rate_percent DESC, total_wins DESC;

-- 3. Gym depth vs volume (unique athletes vs matches)

WITH gym_athletes AS (
    SELECT gym_winner AS gym, winner_grappler_id AS grappler_id, 1 AS match
    FROM asia_adcc_2025_trials

    UNION ALL

    SELECT gym_loser AS gym, loser_grappler_id AS grappler_id, 1 AS match
    FROM asia_adcc_2025_trials
)

SELECT
    gym,
    COUNT(DISTINCT grappler_id) AS unique_athletes,
    COUNT(*) AS total_matches
FROM gym_athletes
WHERE gym IS NOT NULL AND gym <> ''
  AND grappler_id IS NOT NULL AND grappler_id <> ''
GROUP BY gym
ORDER BY unique_athletes DESC, total_matches DESC;

-- 4. Total number of gyms represented

SELECT
    COUNT(DISTINCT gym) AS total_gyms
FROM (
    SELECT gym_winner AS gym FROM asia_adcc_2025_trials
    UNION
    SELECT gym_loser AS gym FROM asia_adcc_2025_trials
) g
WHERE gym IS NOT NULL AND gym <> '';

-- 5. Countries by number of gyms (most to least)

WITH gym_country AS (
    SELECT DISTINCT gym_winner AS gym, winner_country AS country
    FROM asia_adcc_2025_trials

    UNION

    SELECT DISTINCT gym_loser AS gym, loser_country AS country
    FROM asia_adcc_2025_trials
)

SELECT
    country,
    COUNT(DISTINCT gym) AS total_gyms
FROM gym_country
WHERE country IS NOT NULL AND country <> ''
  AND gym IS NOT NULL AND gym <> ''
GROUP BY country
ORDER BY total_gyms DESC;

-- 6. Gyms by number of athletes (most vs least)

WITH gym_athletes AS (
    SELECT gym_winner AS gym, winner_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials

    UNION

    SELECT gym_loser AS gym, loser_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
)

SELECT
    gym,
    COUNT(DISTINCT grappler_id) AS unique_athletes
FROM gym_athletes
WHERE gym IS NOT NULL AND gym <> ''
  AND grappler_id IS NOT NULL AND grappler_id <> ''
GROUP BY gym
ORDER BY unique_athletes DESC;

