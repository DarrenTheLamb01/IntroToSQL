-- Welcome to My Intro to SQL Project!

-- Create Tables
CREATE TABLE cheese_production (
	Year INTEGER,
	Period TEXT,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Domain TEXT,
	Value INTEGER
);


CREATE TABLE honey_production (
	Year INTEGER,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Value INTEGER
);


CREATE TABLE milk_production (
	Year INTEGER,
	Period TEXT,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Domain TEXT,
	Value INTEGER
);


CREATE TABLE coffee_production (
	Year INTEGER,
	Period TEXT,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Value INTEGER
);


CREATE TABLE egg_production (
	Year INTEGER,
	Period TEXT,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Value INTEGER
);


CREATE TABLE state_lookup (
	State TEXT,
	State_ANSI INTEGER
);


CREATE TABLE yogurt_production (
	Year INTEGER,
	Period TEXT,
	Geo_Level TEXT,
	State_ANSI INTEGER,
	Commodity_ID INTEGER,
	Domain TEXT,
	Value INTEGER
);

-- Clean Data
UPDATE cheese_production SET value = REPLACE(value, ',', '');

UPDATE honey_production SET value = REPLACE(value, ',', '');

UPDATE milk_production SET value = REPLACE(value, ',', '');

UPDATE coffee_production SET value = REPLACE(value, ',', '');

UPDATE egg_production SET value = REPLACE(value, ',', '');

UPDATE yogurt_production SET value = REPLACE(value, ',', '');

-- Exploratory Data Analysis

-- Find the total milk production for the year 2023. (91,812,000,000)
SELECT SUM(CAST(REPLACE(Value, ',', '') AS BIGINT)) AS Total_Milk_Production
FROM milk_production
WHERE Year = 2023;

/*
Show coffee production data for the year 2015. (6,600,000)
What is the total value? */
SELECT * 
FROM coffee_production
WHERE year = 2015;

-- Find the average honey production for the year 2022. (3,133,275)
SELECT avg(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM honey_production
WHERE year = 2022;

/*
Get the state names with their corresponding ANSI codes from the state_lookup table.
What number is Iowa? (19) */
SELECT State, State_ANSI
FROM state_lookup;

-- Find the highest yogurt production value for the year 2022. (793,256,000)
SELECT max(value)
FROM yogurt_production
WHERE year = 2022;

/*
Find states where both honey and milk were produced in 2022.
Did State_ANSI "35" produce both honey and milk in 2022? (No) */
SELECT hp.State_ANSI, hp.value AS honey, mp.Value AS milk
FROM honey_production hp INNER JOIN milk_production mp 
ON hp.State_ANSI  = mp.State_ANSI
WHERE hp.year = 2022 and hp.State_ANSI = 35;

-- Find the total yogurt production for states that also produced cheese in 2022. (1,171,095,000)
SELECT SUM(CAST(REPLACE(yp.Value, ',', '') AS BIGINT))
FROM yogurt_production yp
WHERE yp.Year = 2022 AND yp.State_ANSI IN (
    SELECT DISTINCT cp.State_ANSI FROM cheese_production cp WHERE cp.Year = 2022
);

-- What is the total milk production for 2023? (91,812,000,000)
SELECT SUM(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM milk_production
WHERE year = 2023;

/*
Which states had cheese production greater than 100 million in April 2023? (3)
How many states are there? */
SELECT State_ANSI, period, SUM(CAST(REPLACE(Value, ',', '') AS BIGINT)) as total_value
FROM cheese_production
WHERE year = 2023 AND period = 'APR'
GROUP BY state_ansi
HAVING total_value > 100000000;

-- What is the total value of coffee production for 2011? (7,600,000)
SELECT SUM(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM coffee_production
WHERE year = 2011;

-- Find the average honey production for 2022. (3,133,275)
SELECT AVG(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM honey_production
WHERE year = 2022;

-- What is the State_ANSI code for Florida? (12)
SELECT state_ansi
FROM state_lookup
WHERE state = 'FLORIDA';

/*
List all states with their cheese production values, even if they didn't produce any cheese in April of 2023.
What is the total for NEW JERSEY? (4,889,000) */
SELECT SUM(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM cheese_production cp
WHERE cp.Period = 'APR' and year = '2023' and 
cp.State_ANSI = (SELECT sl.State_ANSI FROM state_lookup sl WHERE sl.state = 'NEW JERSEY')

-- Find the total yogurt production for states in the year 2022 which also have cheese production data from 2023? (1,171,095,000) 
SELECT SUM(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM yogurt_production 
WHERE year = 2022 and state_ansi in (SELECT state_ansi FROM cheese_production WHERE year = 2023);

/*
List all states from state_lookup that are missing from milk_production in 2023.
How many states are there? */
SELECT COUNT((SELECT State_ANSI FROM state_lookup)) - COUNT(State_ANSI)
FROM milk_production
WHERE year = 2023

/*
List all states with their cheese production values, including states that didn't produce any cheese in April 2023.
Did Delaware produce any cheese in April 2023? (No) */
SELECT VALUE
FROM cheese_production 
WHERE period = 'APR' AND year = 2023 AND State_ANSI = (SELECT State_ANSI FROM state_lookup WHERE state = 'Delaware')

-- Find the average coffee production for all years where the honey production exceeded 1 million.
SELECT avg(CAST(REPLACE(Value, ',', '') AS BIGINT))
FROM coffee_production
WHERE year = (SELECT year FROM honey_production GROUP BY year HAVING SUM(CAST(REPLACE(Value, ',', '') AS BIGINT)) > 1000000 )

