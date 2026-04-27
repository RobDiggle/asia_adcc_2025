-- Overall gender distribution
SELECT
    gender,
    COUNT(*) AS total_matches
FROM asia_adcc_2025_trials
WHERE event_id ILIKE '%PRO%'
GROUP BY gender
ORDER BY total_matches DESC;

-- Gender distribution within each country (by athlete participation)
SELECT
    country,
    gender,
    COUNT(*) AS total_entries
FROM (
    SELECT winner_country AS country, gender
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'

    UNION ALL

    SELECT loser_country AS country, gender
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
) AS combined
WHERE country IS NOT NULL
  AND country <> ''
GROUP BY country, gender
ORDER BY country, total_entries DESC;