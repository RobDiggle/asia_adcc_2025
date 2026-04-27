--How many matches were recorded per country (as a proxy for activity level)?

SELECT
    country,
    COUNT(*) AS matches_recorded
FROM (
    SELECT winner_country AS country
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'

    UNION ALL

    SELECT loser_country AS country
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
) AS country_matches
WHERE country IS NOT NULL
  AND country <> ''
GROUP BY country
ORDER BY matches_recorded DESC;

--Cleaning data where smoothcomp showcased athletes nationalities with
-- dual citizenship obscuring asia analysis

SELECT DISTINCT
    athlete_name,
    country,
    gym
FROM (
    SELECT
        winner_name AS athlete_name,
        winner_country AS country,
        gym_winner AS gym
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
      AND winner_country IN (
          'South Africa',
          'Ireland',
          'Slovakia',
          'Brazil',
          'Aboriginal Australian',
          'Canada',
          'Turkey',
          'Switzerland',
          'Greece'
      )

    UNION

    SELECT
        loser_name AS athlete_name,
        loser_country AS country,
        gym_loser AS gym
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
      AND loser_country IN (
          'South Africa',
          'Ireland',
          'Slovakia',
          'Brazil',
          'Aboriginal Australian',
          'Canada',
          'Turkey',
          'Switzerland',
          'Greece'
      )
) AS athletes
ORDER BY country, athlete_name;

--Updating athlete data to clean country column

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Connor Kearney'
  AND winner_country = 'Aboriginal Australian';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Connor Kearney'
  AND loser_country = 'Aboriginal Australian';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Ethan Enoch-Barlow'
  AND winner_country = 'Aboriginal Australian';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Ethan Enoch-Barlow'
  AND loser_country = 'Aboriginal Australian';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'David Stoilescu'
  AND winner_country = 'Canada';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'David Stoilescu'
AND loser_country = 'Canada';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Serkan Demir'
AND winner_country = 'Turkey';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Serkan Demir'
AND loser_country = 'Turkey';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Devon Coetzee'
AND winner_country = 'South Africa';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Devon Coetzee'
AND loser_country = 'South Africa';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Jordan Rozman'
AND winner_country = 'Slovakia';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Jordan Rozman'
AND loser_country = 'Slovakia';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Taiwan'
WHERE winner_name = 'Jozef Chen'
AND winner_country = 'Chinia';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Taiwan'
WHERE loser_name = 'Jozef Chen'
AND loser_country = 'China';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Conor Fagan'
AND winner_country = 'Ireland';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Conor Fagan'
AND loser_country = 'Ireland';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Ronan Martin'
AND winner_country = 'Ireland';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Ronan Martin'
AND loser_country = 'Ireland';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Nikita Moullakis'
AND winner_country = 'Greece';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Nikita Moullakis'
AND loser_country = 'Greece';

UPDATE asia_adcc_2025_trials
SET winner_country = 'Australia'
WHERE winner_name = 'Julia Livesey'
AND winner_country = 'Brazil';

UPDATE asia_adcc_2025_trials
SET loser_country = 'Australia'
WHERE loser_name = 'Julia Livesey'
AND loser_country = 'Brazil';

-- I realized that I was querying for masters pro as well as adult pro
-- but only adult pro is the actual trials division we are concerned with
SELECT * FROM asia_adcc_2025_trials
WHERE winner_name LIKE '%Augusto%'

-- delete all Masters (including Masters PRO)
DELETE FROM asia_adcc_2025_trials
WHERE bracket ILIKE '%MASTERS%';

--How many unique athletes did each country have (counting both winners and losers)?

SELECT
    country,
    COUNT(DISTINCT grappler_id) AS unique_athletes
FROM (
    SELECT
        winner_country AS country,
        winner_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'

    UNION

    SELECT
        loser_country AS country,
        loser_grappler_id AS grappler_id
    FROM asia_adcc_2025_trials
    WHERE event_id ILIKE '%PRO%'
) AS athletes
WHERE country IS NOT NULL
  AND country <> ''
  AND grappler_id IS NOT NULL
  AND grappler_id <> ''
GROUP BY country
ORDER BY unique_athletes DESC;


