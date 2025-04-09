-- MSc in DMDS - 2023-24
-- 7CPSQL / EMLYON Business School
-- FINAL GROUP PROJECT


-- For the FINAL PROJECT you will use the 'Divvy' database. 
-- It is part of a dataset derived from a bycicle sharing service in the city of Chicago, IL (USA) 
-- The service is similar to Lyon's "Velo'v". 
-- The database has two tables: 
-- (i) Trips, containing all the trips from the year 2018
-- (ii) Stations, which contains some data on each of the stations.

-- The data has been made available by Motivate International Inc. under this license:
-- https://ride.divvybikes.com/data-license-agreement and the full dataset as originally provided can be found here:
-- https://divvy-tripdata.s3.amazonaws.com/index.html
-- To give you a feeling for the data, we plotted the stations from the Stations table here:
-- https://www.google.com/maps/d/edit?mid=1o8GHKNl2UdNlCEVGWqzjTWxOoyB-EEg&usp=sharing
-- More about Divvy here: https://divvybikes.com/system-data

-- When completing this project as a group, remember to make your SQL code clear and comment on all queries.
-- Marks are provided for attempts made, so it's better to make an attempt than to completly leave a question out.

-- Marking scheme:
-- Part1 /4 ; Part2 /5 ; Part3 /7 (4+3) ; Quality of comments and presentations /4

USE Divvy;
-- Exploration 
DESCRIBE Stations;-- The data type are : int, text, double, date, datime 
DESCRIBE Trips; -- The data type are : int, text,date

SELECT *
FROM Stations; --  The “text” data type for the dcapacity column is inappropriate, as it contains only integer digits. It should therefore be “int”. (ALTER TABLE Stations MODIFY COLUMN dpcapacity INT;) 

SELECT *
FROM Trips; -- the DATE format in the start_time & end_time columns only manages the day, month and year, and does not take time into account, so it should be replaced by the DATETIME type. 

-- PART 1 [4 marks]
-- Explore the database and its tables, then discuss your findings. Consider all the usual aspects in database exploration:
-- (e.g., are the data types assigned to each field correct? Are there any duplicates?)
-- Answer this question: What is the common key between the two tables?
-- Remember to take into account where the data comes from.

-- 1 )  Looking for duplicates 
SELECT id, COUNT(*) 
FROM Stations
GROUP BY id
HAVING COUNT(*) > 1;
-- no duplicates id column (Stations table) 

SELECT name, COUNT(*)
FROM Stations
GROUP BY name
HAVING COUNT(*) > 1;
-- no duplicates name column (Stations table) 

SELECT trip_id, COUNT(*) 
FROM Trips
GROUP BY trip_id
HAVING COUNT(*) > 1;
-- no duplicates trip_ip column (Trips table) 

-- 2)  Missing values 
SELECT *
FROM Stations
WHERE id IS NULL OR name IS NULL OR latitude IS NULL OR longitude IS NULL OR dpcapacity IS NULL OR landmark IS NULL OR onlinedate IS NULL OR converted_date IS NULL;
-- There are 300 rows with missing values in the converted_date column from the Stations table

SELECT *
FROM Trips
WHERE trip_id IS NULL OR start_time IS NULL OR end_time IS NULL OR bikeid IS NULL OR tripduration IS NULL OR from_station_id IS NULL OR to_station_id IS NULL OR usertype IS NULL OR gender IS NULL OR birthyear IS NULL;
-- There is not any missing values in the Tips table 

SELECT DISTINCT birthyear
FROM Trips;
-- There is one outlier in the column birthyear because one value is 0 

SELECT * 
FROM Trips 
WHERE birthyear = 0;
-- There are 1000 rows with 0 values in the birthyear column 

SELECT * FROM Trips 
WHERE gender LIKE "";
-- There are 1000 rows with empty values in the gender column 

SELECT trip_id,start_time,end_time,bikeid,tripduration,from_station_id,to_station_id,usertype,gender,birthyear FROM Trips 
WHERE trip_id LIKE "" OR start_time LIKE "" OR end_time LIKE "" OR bikeid LIKE "" OR tripduration LIKE "" OR from_station_id LIKE "" OR to_station_id LIKE "" OR usertype LIKE "" OR gender LIKE "" OR birthyear LIKE "";

-- 3 ) Database analysis 
-- 3 ) Database analysis 

SELECT DISTINCT usertype
FROM Trips; -- There are 2 kind of users : subscriber & customer 

SELECT 
    CONCAT(FLOOR(MIN(tripduration) / 60), ':', LPAD(MOD(MIN(tripduration), 60), 2, '0')) AS min_duration,
    CONCAT(FLOOR(MAX(tripduration) / 60), ':', LPAD(MOD(MAX(tripduration), 60), 2, '0')) AS max_duration,
    CONCAT(FLOOR(AVG(tripduration) / 60), ':', LPAD(MOD(AVG(tripduration), 60), 2, '0')) AS avg_duration
FROM Trips;
-- The average journey time : 5 min 44 sec. The maximum journey time : 16 min 39 sec. The minimum journey time : 01 seconds.

SELECT 
    from_station_id, 
    COUNT(*) AS trips_count
FROM Trips
GROUP BY from_station_id
ORDER BY trips_count DESC
LIMIT 10;
-- The most popular departure stations is the number 35 ; 
-- In the top 5 we found the stations : 35, 192, 77, 91, 43

SELECT 
    to_station_id, 
    COUNT(*) AS trips_count
FROM Trips
GROUP BY to_station_id
ORDER BY trips_count DESC
LIMIT 10;
-- The most popular arrival stations are the same as the most popular departure stations (35, 192, 77, 91, 43) 
 
SELECT 
    usertype, 
    COUNT(*) AS count 
FROM Trips 
GROUP BY usertype;
-- There are more subscribers (292416) than customer (67892)

SELECT 
    usertype,
    COUNT(*) AS user_count,
    ROUND((COUNT(*) * 100 / (SELECT COUNT(*) FROM Trips)), 2) AS percentage
FROM Trips
GROUP BY usertype;
-- There are 81 % of subscibers and 19% of customers 

SELECT 
    bikeid, 
    COUNT(*) AS trips_count
FROM Trips
GROUP BY bikeid
ORDER BY trips_count DESC
LIMIT 10;
-- The bikeid the most used is the number 162

-- 4 ) Demographic analysis 

SELECT 
    gender, 
    COUNT(*) AS count 
FROM Trips 
GROUP BY gender;

SELECT 
    gender,
    COUNT(*) AS user_count,
    ROUND((COUNT(*) * 100 / (SELECT COUNT(*) FROM Trips)), 2) AS percentage
FROM Trips
GROUP BY gender;
-- 56399 users don't have any registered genres 
-- 63% are male
-- 21 % are female 

SELECT 
    birthyear, 
    COUNT(*) AS user_count
FROM Trips
WHERE birthyear IS NOT NULL
GROUP BY birthyear
ORDER BY birthyear DESC;
-- There are 55706 users whose year of birth is represented by a 0 in the database
-- The oldest registered user was born in 1899
-- Youngest registered user was born in 2003

SELECT birthyear, COUNT(*) AS frequency
FROM Trips
WHERE birthyear IS NOT NULL
  AND birthyear != 0
GROUP BY birthyear
ORDER BY frequency DESC
LIMIT 1;
-- The most frequent birthyear is 1989.
-- What is the common key between the two tables?
-- The common key between the tables is id in the table Stations and from_station_id / to_station_id in the table Trips

-- PART 2 [5 marks]
-- Imagine your database administrator is a slacker, and hasn't updated the Stations table since 2013.
-- (We uploaded the 2013 stations on purpose here of course!).
-- How many unique stations are in the Trips but not in the Stations? 
-- TIPS: 
-- Include stations "from_station_id" as well as stations "to_station_id".
-- You will need to use the keyword UNION, which combines the results from two queries into one column, dropping any duplicates
-- You can do a mini-practice here to understand the keyword before applying it: https://www.w3schools.com/sql/sql_union.asp
-- Remember to also display your results as a percentage of the total number of stations and not only as a absolute number.
-- We are suggesting a four-step plan to help you. You don't have to follow it, but it would be very helpful.
-- Don't forget to make your reasoning clear and to comment each of your steps.

-- Step 1: Write a query to know which station IDs in the "from_station_id" field are not in the Stations table.
-- Then do the same for the column "to_station_id".

#Retrieves unique values from the column from_station_id in the Trips table
SELECT DISTINCT from_station_id AS station_id
#Filters the results to include only those station IDs in the from_station_id column that are not present in the id column of the Stations table.
FROM Trips
WHERE from_station_id NOT IN (
    SELECT id FROM Stations
);

-- Find station IDs in the "to_station_id" field that are not in the Stations table
#Retrieves unique values from the column to_station_id in the Trips table.
SELECT DISTINCT to_station_id AS station_id
FROM Trips
#Filters the results to include only those station IDs in the to_station_id column that are not present in the id column of the Stations table.
WHERE to_station_id NOT IN (
    SELECT id FROM Stations
);

-- Step 2: Now, combine your two tables in STEP 1, using the keyword UNION.
-- A UNION will drop any duplicates, so you just need to count everything in the combined table
-- This will essentially represent the number of all missing stations.

SELECT DISTINCT station_id
FROM (
    SELECT from_station_id AS station_id
    FROM Trips
    WHERE from_station_id NOT IN (
        SELECT id FROM Stations
    )
    UNION ALL
    SELECT to_station_id AS station_id
    FROM Trips
    WHERE to_station_id NOT IN (
        SELECT id FROM Stations
    )
) AS combined_missing_stations;

-- this code will also show the information of source so we use "UNION ALL" to both union station id and source

SELECT DISTINCT station_id, source
FROM (
    SELECT from_station_id AS station_id, 'from_station_id' AS source # we can also see which station id came from which source
    FROM Trips
    WHERE from_station_id NOT IN (
        SELECT id FROM Stations
    )
    UNION ALL
    SELECT to_station_id AS station_id, 'to_station_id' AS source 
    FROM Trips
    WHERE to_station_id NOT IN (
        SELECT id FROM Stations
    )
) AS combined_missing_stations;

-- Step 3: Using the same UNION keyword, count the total number of different stations in the two columns of the Trips table
-- (i.e., from_station_id and to_station_id).
-- TIP: Remember that a UNION will drop any duplicates and 
-- Note that in this case you are using UNION to combine data in two columns of the same table

SELECT COUNT(DISTINCT station_id) AS total_stations # will count the combined columns 
FROM (
    SELECT from_station_id AS station_id
    FROM Trips
    UNION # combine columns
    SELECT to_station_id AS station_id
    FROM Trips
) AS all_stations; #615


-- Step 4: Finally, write a query that displays the percentage of missing stations from the Stations table.

SELECT 
    (COUNT(DISTINCT station_id) * 100.0 / (SELECT COUNT(DISTINCT station_id) FROM (
        SELECT from_station_id AS station_id
        FROM Trips
        UNION
        SELECT to_station_id AS station_id
        FROM Trips
    ) AS all_stations)) AS percentage_missing
FROM (
    SELECT from_station_id AS station_id
    FROM Trips
    WHERE from_station_id NOT IN (
        SELECT id FROM Stations
    )
    UNION
    SELECT to_station_id AS station_id
    FROM Trips
    WHERE to_station_id NOT IN (
        SELECT id FROM Stations
    )
) AS missing_stations; #51.2

-- PART 3 [7 marks (4+3)]
-- The marketing department wants to know the age distribution of our users, and how their usage differs (in terms of trip durations). 
-- Give them a plot of age (on the X-axis), and average tripduration on the y-axis. 

-- PART 3.1
-- To achieve this, this, write a query that returns both age and average tripduration data from the Divvy Database
SELECT (2018 - birthyear) AS age, AVG(tripduration) AS average_trip_duration
FROM Trips
WHERE birthyear IS NOT NULL 
	AND birthyear != 0
    AND (2018 - birthyear) BETWEEN 10 AND 90 -- in order to prevent from unreasonable ages.
GROUP BY age
ORDER BY age;

-- You need to extract the age from the birthyear field in the Trips table, given that this data contains all the trips from the year 2018
-- Make sure to not include missing values, and and order results by age. 
-- Now, export your data into a CSV file, then convert into Excel, and make the plot in Excel.
-- Explain your steps and discuss your findings. Please hand in your excel file, plus a discussion of what you did 
-- and what your conclusions are (Excel or SQL script comments). 
-- There appears to be a difference between the way the plot behaves before and after an age of about 65. 
-- Discuss what you think the reason is for the shape of the plot overall, and this difference as well.


-- PART 3.2
-- Change your query in 3.1 by using FLOOR([your data]/10)*10 AS age_bin in a query that counts the number of trips 
-- grouped per age ranges (represented by age_bin, e.g., 10,20,30,40,50 etc.) instead of absolute values of age. 
-- This is a histogram in tabular form, which can then be exported to Excel in order to plot it.
-- Make the plot, then compare it to the one from your Query in 3.1. 
-- If you had done only this query (and not Query 3.1), would you have arrived at a different conclusion? 
-- Would it have been valid? Why yes or why not?
SELECT 
    FLOOR((2018 - birthyear) / 10) * 10 AS age_bin, 
    -- AVG(tripduration) AS average_trip_duration,
    COUNT(*) AS trip_count
FROM Trips
WHERE birthyear IS NOT NULL 
    AND birthyear != 0
    AND (2018 - birthyear) BETWEEN 10 AND 90 
GROUP BY age_bin
ORDER BY age_bin;

-- Part 2: 5 Modeling codes

-- How many bikes have broken down since 2018 ?
SELECT COUNT(DISTINCT concerned_bike) AS broken_bikes_count
FROM Events
WHERE event_description = 'breakdown'  
  AND date >= '2018-01-01';

-- What is the busiest time of day for trips, and how does it vary by station?
SELECT HOUR(start_time) AS hour_of_day, from_station_id AS station_id, COUNT(trip_id) AS total_trips
FROM Trips
GROUP BY
HOUR(start_time), from_station_id
ORDER BY total_trips DESC;

-- What is the maximum total kilometers a bike in normal condition can travel?
SELECT 
    MAX(total_kilometers_travelled) AS max_kilometers
FROM 
    Bikes
WHERE 
    bike_condition = 'Normal';

-- Which stations are most frequently used by users? Are there specific travel trends?
SELECT
	form_station, 
	COUNT(trip_id) AS total_trips
FROM Trips
GROUP BY form_station
ORDER BY total_trips DESC;

-- What is the average trip duration for each user type, and how does it vary by gender?
SELECT 
    usertype, 
    gender, 
    AVG(tripduration) AS average_trip_duration
FROM 
    Trips
WHERE 
    gender IS NOT NULL -- Exclude the ones with missing gender data
GROUP BY 
    usertype, 
    gender
ORDER BY 
    usertype, 
    average_trip_duration DESC;



