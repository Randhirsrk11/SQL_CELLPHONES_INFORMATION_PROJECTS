USE CellPhones_Information;

SELECT * FROM (
SELECT  'DIM_MANUFACTURER' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM DIM_MANUFACTURER UNION ALL
SELECT 'DIM_MODEL' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM DIM_MODEL UNION ALL
SELECT 'DIM_CUSTOMER' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM DIM_CUSTOMER UNION ALL
SELECT 'DIM_LOCATION' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM DIM_LOCATION UNION ALL
SELECT 'DIM_DATE' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM DIM_DATE UNION ALL
SELECT 'FACT_TRANSACTIONS' AS TABLE_NAME, COUNT(*) AS NO_OF_RECORDS FROM FACT_TRANSACTIONS
) TBL

SELECT TOP 10 * FROM DIM_MANUFACTURER
SELECT TOP 10 * FROM DIM_MODEL
SELECT TOP 10 * FROM DIM_CUSTOMER
SELECT TOP 10 * FROM DIM_LOCATION
SELECT TOP 10 * FROM DIM_DATE
SELECT TOP 10 * FROM FACT_TRANSACTIONS


--1. List all the states in which we have customers who have bought CellPhones from 2005 till today.

SELECT State FROM DIM_LOCATION T1
INNER JOIN FACT_TRANSACTIONS T2 ON T1.IDLocation = T2.IDLocation
INNER JOIN DIM_DATE T3 ON T2.Date = T3.DATE
WHERE YEAR > 2005
GROUP BY STATE



--2. what state in the US is buying more'samsung' cell phones?

SELECT TOP 1 T1.STATE, T4.Manufacturer_Name, SUM(T2.Quantity) AS TotalQuantity FROM DIM_LOCATION T1
INNER JOIN FACT_TRANSACTIONS T2 ON T1.IDLocation = T2.IDLocation
INNER JOIN DIM_MODEL T3 ON T2.IDModel = T3.IDModel
INNER JOIN DIM_MANUFACTURER T4 ON T3.IDManufacturer = T4.IDManufacturer
WHERE T1.Country = 'US' AND T4.Manufacturer_Name= 'SAMSUNG'
GROUP BY T1.STATE, T4.Manufacturer_Name
ORDER BY TotalQuantity DESC


--3. show the number of transaction for each model per zip code per state.

SELECT T3.IDModel, T3.Model_Name, T2.ZipCode, T2.State, COUNT(T1.IDCustomer) AS CountOfTransactions FROM FACT_TRANSACTIONS T1
JOIN DIM_LOCATION T2 ON T1.IDLocation = T2.IDLocation
JOIN DIM_MODEL T3 ON T1.IDModel = T3.IDModel
GROUP BY T3.IDModel, T3.Model_Name, T2.ZipCode, T2.State
ORDER BY CountOfTransactions DESC


--4. show the cheapest cellphone

SELECT TOP 2 IDModel, Model_Name, Unit_price  FROM DIM_MODEL
ORDER BY Unit_price ASC

SELECT MIN(Unit_Price) AS MIN_Unit_price FROM DIM_MODEL

Select * from DIM_MODEL
where Unit_price = (Select MIN(Unit_price) AS MIN_Unit_price from DIM_MODEL)

Select DIM_MANUFACTURER.Manufacturer_Name,DIM_MODEL.IDModel,DIM_MODEL.Model_Name,DIM_MODEL.Unit_price  from DIM_MODEL
JOIN DIM_MANUFACTURER ON DIM_MODEL.IDManufacturer = DIM_MANUFACTURER.IDManufacturer
where Unit_price = (Select MIN(Unit_price) AS MIN_Unit_price from DIM_MODEL)


-----------2ND Lowest (Subquery)


SELECT TOP 1 Unit_Price FROM 
(SELECT TOP 5 Unit_Price FROM DIM_MODEL
ORDER BY Unit_price ASC) Result
ORDER BY Unit_Price Desc


        -----(CTE)
		GO

WITH Result AS
(SELECT *, DENSE_RANK() OVER( ORDER BY Unit_Price ASC) AS Second_Lowest FROM DIM_MODEL
)
SELECT * FROM Result
WHERE Second_Lowest = 5



 --5. find out the average price for each model in the top 5 manufacturer in terms of sales quantity +and order by average price


SELECT  TOP 5 T1.Manufacturer_Name, T2.Model_Name, SUM(T3.Quantity), AVG(T3.TotalPrice) FROM DIM_MANUFACTURER T1
 JOIN DIM_MODEL T2 ON T1.IDManufacturer = T2.IDManufacturer
 JOIN FACT_TRANSACTIONS T3 ON T2.IDModel = T3.IDModel
 GROUP BY  T1.Manufacturer_Name, T2.Model_Name
 ORDER BY AVG(T3.TotalPrice) DESC

--6. list the names of the customer and the average amount spent in 2009, where the average is higher than 500

SELECT T1.Customer_Name, AVG(T2.TotalPrice) AS Average_Spend, YEAR(T2.Date) AS Year FROM DIM_CUSTOMER T1
JOIN FACT_TRANSACTIONS T2 ON T1.IDCustomer = T2.IDCustomer
WHERE YEAR(T2.Date) = 2009
GROUP BY T1.Customer_Name, YEAR(T2.Date)
HAVING AVG(T2.TotalPrice)>500
ORDER BY Average_Spend DESC


--7. list if there is any model that was in the top 5 in termss of quantity , simultaneously in 2008,2009 and 2010

SELECT TOP 5 T2.IDModel,T2.Model_Name , SUM(T1.QUANTITY) as TOTAL_Quenty FROM FACT_TRANSACTIONS T1
JOIN DIM_MODEL T2 ON T1.IDModel = T2.IDModel
WHERE YEAR(T1.DATE) = 2009
GROUP BY T2.Model_Name,T2.IDModel
ORDER BY SUM(T1.QUANTITY) DESC


SELECT TOP 5 T2.IDModel,T2.Model_Name , SUM(T1.QUANTITY) as TOTAL_Quenty FROM FACT_TRANSACTIONS T1
JOIN DIM_MODEL T2 ON T1.IDModel = T2.IDModel
WHERE YEAR(T1.DATE) = 2008
GROUP BY T2.Model_Name,T2.IDModel
ORDER BY SUM(T1.QUANTITY) DESC


SELECT TOP 5 T2.IDModel,T2.Model_Name , SUM(T1.QUANTITY) as TOTAL_Quenty FROM FACT_TRANSACTIONS T1
JOIN DIM_MODEL T2 ON T1.IDModel = T2.IDModel
WHERE YEAR(T1.DATE) = 2007
GROUP BY T2.Model_Name,T2.IDModel
ORDER BY SUM(T1.QUANTITY) DESC






