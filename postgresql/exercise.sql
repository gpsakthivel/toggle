--follow the PostgreSQL tutorials at https://www.pg-sql.com/


-- SQL statements
-- Create a table to store city information
CREATE TABLE cities (
  name VARCHAR(50),
  country VARCHAR(50),
  population INTEGER,
  area INTEGER
);

-- Insert records into the cities table
INSERT INTO cities
(name, country, population, area)
VALUES
('Tokyo', 'Japan', 38505000, 8223);

-- Insert multiple records
INSERT INTO cities
(name, country, population, area)
VALUES
('Delhi', 'India', 28125000, 2240),
('Shanghai', 'China', 22125000, 4015),
('Sao Paulo', 'Brazil', 20935000, 3043);

-- Calculating population density
SELECT name, (population / area) AS population_density FROM cities;

-- String functions
SELECT name || ', ' || country AS location FROM cities;
SELECT CONCAT(name, ', ',country) AS location FROM cities;
SELECT UPPER(name), LOWER(name), LENGTH(name) FROM cities;


-- Filtering records
-- Find cities with area greater than 4000
SELECT name, area FROM cities WHERE area > 4000;

-- Explanation of execution order of the above query:
-- SELECT keyword executes third in this query
-- FROM keyword executes first in this query
-- WHERE keyword executes second in this query
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area > 4000;

-- Find cities with area equal to 8223
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area = 8223;

-- Find cities with area not equal to 8223
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area != 8223;

-- Find cities with area between 2000 and 4000
SELECT 
  name, 
  area
FROM 
  cities
WHERE 
  area BETWEEN 2000 AND 4000;

-- Find cities with name in a specific list
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	name IN ('Delhi', 'Shanghai');

-- Find cities with name not in a specific list
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	name NOT IN ('Delhi', 'Shanghai');

-- Find cities with area not in a specific list
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area NOT IN (3043, 8223);

-- Find cities with area not in a specific list and name equal to 'Delhi'
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area NOT IN (3043, 8223) AND name = 'Delhi';

-- Find cities with area not in a specific list or name equal to 'Delhi'
SELECT 
	name, 
  area 
FROM 
	cities 
WHERE 
	area NOT IN (3043, 8223) OR name = 'Delhi';

-- Find cities with population density greater than 6000
SELECT 
  name, 
  population / area AS population_density 
FROM 
  cities 
WHERE 
  population / area > 6000;

-- Update the population of Tokyo
UPDATE cities
SET population = 39505000
WHERE name = 'Tokyo';

--- Delete the record for Tokyo
DELETE FROM cities WHERE name = 'Tokyo';


-- ============================================================
-- SQL JOINS
-- ============================================================
-- Joins combine rows from two or more tables based on a
-- related column between them.
--
-- Types of JOINs:
--   INNER JOIN  – rows with matching values in BOTH tables
--   LEFT JOIN   – all rows from left table + matched right rows
--   RIGHT JOIN  – all rows from right table + matched left rows
--   FULL JOIN   – all rows from both tables (matched or not)
-- ============================================================

-- Setup: create two related tables
CREATE TABLE users (
  id       SERIAL PRIMARY KEY,
  username VARCHAR(50)
);

CREATE TABLE photos (
  id      SERIAL PRIMARY KEY,
  url     VARCHAR(200),
  user_id INTEGER REFERENCES users(id)
);

-- Insert users (user_id 4 will have no photos)
INSERT INTO users (username) VALUES
  ('Alice'),
  ('Bob'),
  ('Carol'),
  ('Dave');

-- Insert photos (no photo is associated with user_id 4 / Dave)
-- photo_id 5 has a NULL user_id (orphaned photo)
INSERT INTO photos (url, user_id) VALUES
  ('https://img.example.com/alice1.jpg', 1),
  ('https://img.example.com/alice2.jpg', 1),
  ('https://img.example.com/bob1.jpg',   2),
  ('https://img.example.com/carol1.jpg', 3),
  ('https://img.example.com/orphan.jpg', NULL);

-- -------------------------------------------------------
-- INNER JOIN
-- Returns only rows where there is a match in BOTH tables.
-- Dave (user_id 4) and the orphaned photo are excluded.
-- -------------------------------------------------------
SELECT
  users.username,
  photos.url
FROM
  users
INNER JOIN photos ON photos.user_id = users.id;

-- -------------------------------------------------------
-- LEFT JOIN (LEFT OUTER JOIN)
-- Returns ALL rows from the left table (users), and the
-- matched rows from the right table (photos).
-- Dave appears with NULL for photo columns because he has
-- no photos.
-- -------------------------------------------------------
SELECT
  users.username,
  photos.url
FROM
  users
LEFT JOIN photos ON photos.user_id = users.id;

-- -------------------------------------------------------
-- RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns ALL rows from the right table (photos), and the
-- matched rows from the left table (users).
-- The orphaned photo appears with NULL for username.
-- -------------------------------------------------------
SELECT
  users.username,
  photos.url
FROM
  users
RIGHT JOIN photos ON photos.user_id = users.id;

-- -------------------------------------------------------
-- FULL JOIN (FULL OUTER JOIN)
-- Returns ALL rows from both tables.
-- Dave (no photos) and the orphaned photo (no user) both
-- appear with NULLs for the unmatched side.
-- -------------------------------------------------------
SELECT
  users.username,
  photos.url
FROM
  users
FULL JOIN photos ON photos.user_id = users.id;

-- -------------------------------------------------------
-- Practical example: find users who have NO photos
-- Use a LEFT JOIN and filter where the right side is NULL.
-- -------------------------------------------------------
SELECT
  users.username
FROM
  users
LEFT JOIN photos ON photos.user_id = users.id
WHERE
  photos.id IS NULL;

-- -------------------------------------------------------
-- Practical example: count photos per user (including
-- users with zero photos using LEFT JOIN + GROUP BY)
-- -------------------------------------------------------
SELECT
  users.username,
  COUNT(photos.id) AS photo_count
FROM
  users
LEFT JOIN photos ON photos.user_id = users.id
GROUP BY
  users.username
ORDER BY
  photo_count DESC;
