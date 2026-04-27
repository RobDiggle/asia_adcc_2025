-- 1. Distribution of finish methods (submission vs other)

SELECT
    CASE
        WHEN win_method = 'Submission' THEN 'Submission'
        ELSE 'Other'
    END AS finish_type,
    COUNT(*) AS total_matches,
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) AS percent
FROM asia_adcc_2025_trials
GROUP BY finish_type
ORDER BY total_matches DESC;

-- 2. Time-to-finish distribution (bins)

SELECT
    CASE
        WHEN match_time_seconds < 60 THEN '<60s'
        WHEN match_time_seconds >= 60 AND match_time_seconds < 180 THEN '60–180s'
        WHEN match_time_seconds >= 180 AND match_time_seconds < 300 THEN '180–300s'
        WHEN match_time_seconds >= 300 AND match_time_seconds < 600 THEN '300–600s'
        ELSE '600s+'
    END AS time_bucket,
    COUNT(*) AS total_matches
FROM asia_adcc_2025_trials
WHERE match_time_seconds IS NOT NULL
GROUP BY time_bucket
ORDER BY
    CASE time_bucket
        WHEN '<60s' THEN 1
        WHEN '60–180s' THEN 2
        WHEN '180–300s' THEN 3
        WHEN '300–600s' THEN 4
        WHEN '600s+' THEN 5
    END;

-- 3. Fastest finishes by country

-- Top 3 fastest finishes per division (including opponent)

SELECT
    bracket,
    winner_name,
    winner_country,
    gym_winner,
    loser_name AS opponent,
    match_time_seconds
FROM (
    SELECT
        bracket,
        winner_name,
        winner_country,
        gym_winner,
        loser_name,
        match_time_seconds,
        ROW_NUMBER() OVER (
            PARTITION BY bracket
            ORDER BY match_time_seconds ASC
        ) AS rn
    FROM asia_adcc_2025_trials
    WHERE match_time_seconds IS NOT NULL
) t
WHERE rn <= 3
ORDER BY bracket, match_time_seconds ASC;