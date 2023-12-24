--Creating database 
create database Automobile;
use Automobile;

--The total number of records in the "automobile" dataset
SELECT COUNT(*) AS TOTAL_RECORDS
FROM automobile;

--The unique car makes available in the dataset
SELECT DISTINCT make
FROM automobile;

--Number of cars for each make
SELECT make, COUNT(*) AS NUM_CARS
FROM automobile
GROUP BY make;

--The average curb weight of cars by body style, ordered in descending order of weight
SELECT body_style, AVG(curb_weight) AS AVG_WEIGHT
FROM automobile
GROUP BY body_style
ORDER BY AVG_WEIGHT DESC;

--The maximum engine size (engine-size) for each number of cylinders (num-of-cylinders)
SELECT num_of_cylinders, MAX(engine_size) AS MAX_ENGINE_SIZE
FROM automobile
GROUP BY num_of_cylinders;

--What is the average highway MPG (highway-mpg) for cars with different fuel types, ordered by fuel type?

SELECT fuel_type, AVG(highway_mpg) AS AVG_HIGHWAY_MPG
FROM automobile
GROUP BY fuel_type
ORDER BY fuel_type;

--Which car has the lowest price (price) and what is its make and model?

SELECT make, SUM(price) AS TOTAL_REVENUE
FROM automobile
GROUP BY make
ORDER BY TOTAL_REVENUE ASC
LIMIT 1;

--The different types of fuel systems in the dataset, and how many cars use each type

SELECT fuel_system, COUNT(*) AS num_cars
FROM automobile
GROUP BY fuel_system;

--What is the average horsepower (horsepower) for cars with different aspiration types, ordered by aspiration type?

SELECT aspiration, AVG(horsepower) AS AVG_HORSEPOWER
FROM automobile
GROUP BY aspiration
ORDER BY aspiration;

--What is the average price for cars with different drive wheel types (drive-wheels), ordered by price in ascending order?

SELECT drive_wheels, AVG(price) AS AVG_PRICE
FROM automobile
GROUP BY drive_wheels
ORDER BY AVG_PRICE;

--What is the average length, width, and height of cars by body style, ordered by body style?

SELECT body_style, AVG(length) AS AVG_LENGTH, AVG(width) AS AVG_WIDTH, AVG(height) AS AVG_HEIGHT
FROM automobile
GROUP BY body_style
ORDER BY body_style;

--What is the total number of cars for each make and body style combination?

SELECT make, body_style, COUNT(*) AS NUM_CARS
FROM automobile
GROUP BY make, body_style;

--Which cars have a compression ratio (compression-ratio) greater than 10 and a city MPG (city-mpg) less than 20?

SELECT make
FROM automobile
WHERE compression_ratio > 10 AND city_mpg < 20;

--Which cars have the highest horsepower-to-curb-weight ratio (horsepower divided by curb-weight), and what is that ratio?

SELECT make, (horsepower / curb_weight) AS hp_to_curb_weight_ratio
FROM automobile
ORDER BY hp_to_curb_weight_ratio DESC
LIMIT 1;

--  What is the average price for each body_style and which car has a price that is higher than the average price of its respective body style?
WITH AvgPrices AS (
    SELECT body_style, AVG(price) AS avg_price_by_body
    FROM automobile
    GROUP BY body_style
)
SELECT 
    A.body_style,
    A.avg_price_by_body AS average_price,
    C.make,
    C.price
FROM AvgPrices A
JOIN automobile C ON A.body_style = C.body_style
WHERE C.price > A.avg_price_by_body
ORDER BY A.body_style, C.price DESC;

-- For each combination of fuel_type and engine_type, determine the average price of cars. 
--Additionally, identify cars that have a price greater than the average price of their respective fuel_type and engine_type combination.

WITH AvgPriceByFuelAndEngine AS (
    SELECT fuel_type,engine_type,AVG(price) OVER(PARTITION BY fuel_type, engine_type) AS avg_price_by_type
    FROM automobile
)
SELECT 
    A.fuel_type,
    A.engine_type,
    A.avg_price_by_type AS average_price,
    C.make,
    C.price
FROM AvgPriceByFuelAndEngine A
JOIN automobile C ON A.fuel_type = C.fuel_type AND A.engine_type = C.engine_type
WHERE C.price > A.avg_price_by_type
ORDER BY A.fuel_type, A.engine_type, C.price DESC;
