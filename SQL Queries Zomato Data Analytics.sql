CREATE DATABASE IF NOT EXISTS zomato_db;
USE zomato_db;

CREATE TABLE zomato_table (
    RestaurantID        BIGINT,
    RestaurantName      VARCHAR(255),
    CountryCode         INT,
    City         VARCHAR(100),
	CountryName            VARCHAR(100),
    Locality            VARCHAR(255),
    Longitude           VARCHAR(50),
    Latitude            VARCHAR(50),
    Cuisines            VARCHAR(255),
    Currency            VARCHAR(100),
    Has_Table_booking   VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now   VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range         INT,
    Votes               INT,
    Average_Cost_for_two DECIMAL(10,2),
    Rating              DECIMAL(3,1),
    Year_and_Date VARCHAR(20),
    Year_Opening            INT,
    Month_Opening               INT,
    Day_Opening                 INT,
    Month_Name          VARCHAR(20),
    Quater              VARCHAR(10),
    Week_of_Year        INT,
    Day_Name            VARCHAR(15),
    Financial_Quater    VARCHAR(10),
    USD_Price           DECIMAL(10,2),
    Indian_Currency   DECIMAL(10,2),
    Price_Bucket_INR  VARCHAR(50),
    Price_Bucket_USD  VARCHAR(50)
);

select * 
from zomato_table;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato CSV.csv'
INTO TABLE zomato_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';


#Queries#
-- 1) Number of Restaurants based on City and Country
select CountryName,City,COUNT(RestaurantID) AS Number_of_Restaurants
FROM Zomato_table
GROUP BY CountryName, City
ORDER BY Number_of_Restaurants DESC;


-- 2) Number of Restaurants Opening based on Year, Quarter, Month
SELECT YEAR_Opening AS Opening_Year,COUNT(RestaurantID) AS Total_Restaurants
FROM Zomato_table
GROUP BY YEAR_Opening
ORDER BY Opening_Year;

SELECT YEAR_Opening AS Opening_Year,
QUATER AS Opening_Quater,
COUNT(RestaurantID) AS Total_Restaurants
FROM Zomato_table
GROUP BY YEAR_Opening, QUATER
ORDER BY Opening_Year, Opening_Quater;

SELECT year_opening AS Opening_Year,
Month_Name AS Opening_Month,
COUNT(RestaurantID) AS Total_Restaurants
FROM Zomato_table
GROUP BY year_opening, Month_Name
ORDER BY Opening_Year, Opening_Month;


-- 3) Count of Restaurants based on average rating
SELECT Rating,
COUNT(RestaurantID) AS Number_of_Restaurants
FROM Zomato_table
GROUP BY Rating
ORDER BY Rating DESC;


-- 4) Number of Restaurants based on Buckets Average Price
SELECT CASE 
WHEN Average_Cost_for_two BETWEEN 0 AND 500 THEN '0-500'
WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN '501-1000'
WHEN Average_Cost_for_two BETWEEN 1001 AND 2000 THEN '1001-2000'
WHEN Average_Cost_for_two BETWEEN 2001 AND 5000 THEN '2001-5000'
ELSE '5000+'
END AS Price_Bucket,
COUNT(RestaurantID) AS Number_of_Restaurants
FROM Zomato_table
GROUP BY Price_Bucket
ORDER BY Number_of_Restaurants DESC;


-- 5) Percentage of Resturants based on "Table booking"
SELECT Has_Table_booking,
COUNT(*) AS Restaurant_Count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Zomato_table), 2) AS Percentage
FROM Zomato_table
GROUP BY Has_Table_booking;


-- 6) Percentage of Resturants based on "Online Dellivery"
SELECT Has_Online_delivery,
COUNT(*) AS Restaurant_Count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Zomato_table), 2) AS Percentage
FROM Zomato_table
GROUP BY Has_Online_delivery;


-- 7) Top 10 Cuisines by Number of Restaurants
SELECT Cuisines,
COUNT(*) AS Restaurant_Count
FROM Zomato_table
WHERE Cuisines IS NOT NULL
GROUP BY Cuisines
ORDER BY Restaurant_Count DESC
LIMIT 10;


-- 8) Top 10 Most Voted Restaurants
SELECT RestaurantName, City, CountryName, Votes,Rating
FROM zomato_table
ORDER BY Votes DESC
LIMIT 10;


-- 9) Average Rating by Country
SELECT CountryName,
ROUND(AVG(Rating), 2) AS Avg_Rating,
COUNT(RestaurantID)   AS Total_Restaurants
FROM zomato_table
GROUP BY CountryName
ORDER BY Avg_Rating DESC;


-- 10) Top 10 localities by count & rating
SELECT Locality,
COUNT(*) AS Restaurant_Count,
ROUND(AVG(CASE WHEN Rating > 0 THEN Rating END), 2) AS Avg_Rating
FROM zomato_table
GROUP BY Locality
ORDER BY Restaurant_Count DESC
LIMIT 10;


-- 11) Restaurants with High Votes but Low Rating (Overhyped)
SELECT RestaurantName, City, CountryName, Votes, Rating
FROM zomato_table
WHERE Votes > (SELECT AVG(Votes) FROM zomato_table)
  AND Rating < 3.5
  AND Rating > 0
ORDER BY Votes DESC
LIMIT 10;


-- 12) Day-wise restaurant openings
SELECT Day_Name, COUNT(*) AS Restaurants_Opened
FROM Zomato_table
WHERE Year_Opening BETWEEN 2010 AND 2018
GROUP BY Day_Name
ORDER BY FIELD(Day_Name,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');