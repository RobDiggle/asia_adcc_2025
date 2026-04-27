-- 1. How many athletes in each division (unique athletes per bracket)

SELECT
    bracket,
    COUNT(DISTINCT grappler_id) AS unique_athletes
FROM (
    SELECT bracket, winner_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'

    UNION

    SELECT bracket, loser_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
) AS athletes
WHERE grappler_id IS NOT NULL
  AND grappler_id <> ''
GROUP BY bracket
ORDER BY unique_athletes DESC;

-- 2. Athletes per division segmented by country

SELECT
    bracket,
    country,
    COUNT(DISTINCT grappler_id) AS unique_athletes
FROM (
    SELECT bracket, winner_country AS country, winner_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'

    UNION

    SELECT bracket, loser_country AS country, loser_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
) AS athletes
WHERE grappler_id IS NOT NULL
  AND grappler_id <> ''
  AND country IS NOT NULL
  AND country <> ''
GROUP BY bracket, country
ORDER BY bracket, unique_athletes DESC;