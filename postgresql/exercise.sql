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
