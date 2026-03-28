

  SELECT *
  FROM workspace.default.bright_coffee_sales
  LIMIT 10;

  ------------------------------------------------------------------------
  --1. Date Range

  --The first transaction is on 2023-01-01
  SELECT MIN(transaction_date) AS First_Transaction
  FROM workspace.default.bright_coffee_sales;

  --The last transaction is on 2023-06-30
  SELECT MAX(transaction_date) AS Last_Transaction
  FROM workspace.default.bright_coffee_sales;
  --The data was colledcted for 6 months
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

 --2. Store Check

  --Bright Coffee is operates is 3 locations Lower Manhattan,Hell's Kitchen and Astoria
  SELECT DISTINCT(store_location)
  FROM workspace.default.bright_coffee_sales;

  --Number of stores are 3
  SELECT COUNT(DISTINCT store_id) AS Number_Of_Stores
  FROM workspace.default.bright_coffee_sales;

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

--3 Product sold in store

--Number of product categories are 9
SELECT COUNT(DISTINCT product_category) AS Number_Of_Product_Category
FROM workspace.default.bright_coffee_sales;

--Product categories in a store 
SELECT DISTINCT(product_category) AS Product_Category_In_Store
FROM workspace.default.bright_coffee_sales;

--Number of product types are 29
SELECT COUNT(DISTINCT product_type) AS Number_Of_Product_Types
FROM workspace.default.bright_coffee_sales;

--Product type sold
SELECT DISTINCT(product_type) AS Product_Type
FROM workspace.default.bright_coffee_sales;

--Product details
SELECT DISTINCT(product_detail) AS Product_Details
FROM workspace.default.bright_coffee_sales;

--Store Products Overview (Category • Type • Details)
SELECT (product_category) AS Product_Group,
      (product_type) AS Item_Type,
      (product_detail) AS Product_Description
FROM workspace.default.bright_coffee_sales;

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

--4 Product Prices

--Cheapest Item is 0.8 , CODE to specify which item?
SELECT MIN(unit_price) As Cheapest_Price
FROM workspace.default.bright_coffee_sales;

--Expensive item is 45
SELECT MAX(unit_price) As Highest_Price
FROM workspace.default.bright_coffee_sales;
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--5 Bright Coffee Shop Transaction & Sales Overview
--Count ID's
SELECT COUNT(*) AS Number_of_Transactions,
      COUNT(DISTINCT transaction_id) AS Number_of_Sales,
      COUNT(DISTINCT product_id) AS Number_of_products_sold,
      COUNT(DISTINCT store_id) AS Number_of_stores
FROM workspace.default.bright_coffee_sales;

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--6 Calculates Revenue Sales
SELECT transaction_id As Transaction_ID,
      transaction_date AS Transaction_Date,
      Dayname(transaction_date) AS Day,
      Monthname(transaction_date) AS Month,
      product_type AS Item,
      transaction_qty*unit_price AS Revenue_Sales
FROM workspace.default.bright_coffee_sales;

----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

--7 Calculates Revenue per day
SELECT 
      transaction_date As Transaction_Date,
      Dayname(transaction_date) AS Day,
      Monthname(transaction_date) AS Month,
      COUNT(DISTINCT transaction_id) AS Number_of_Sales,
      SUM(transaction_qty*unit_price) AS Revenue_Sales_Per_Day
FROM workspace.default.bright_coffee_sales
GROUP BY Transaction_Date,
         Day,
         Month;

--8

SELECT 
--Time
      transaction_date As Transaction_Date,
      Dayname(transaction_date) AS Day_Name, 
      Monthname(transaction_date) AS Month,

--Day of the month
      dayofmonth(transaction_date) AS Day_of_month,
CASE 
      WHEN Day_Name IN ('Sun' , 'Sat') THEN 'Weekend'
      ELSE 'Weekday'
END AS Day_Classification,

--Purchase time bucket
--we want to extract Time
     date_format(transaction_time,'HH:mm:ss') AS Purchase_Time,
 CASE 
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN '1. Mid-night'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '05:00:00' AND '11:59:59' THEN '2. Morning'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '3. Afternoon'
        WHEN date_format(transaction_time,'HH:mm:ss') >= '18:00:00' THEN '4. Evening'
END AS Time_bucket,

--ID
      COUNT(transaction_id) AS Number_of_Sales,
      COUNT(DISTINCT store_id) AS Number_of_stores,
      COUNT(DISTINCT product_id) AS Number_of_Product,

--Rev per day
      SUM(transaction_qty*unit_price) AS Revenue_Sales_Per_Day,

CASE 
      WHEN Revenue_Sales_Per_Day >= 6 THEN '1. High-Spend'
      WHEN Revenue_Sales_Per_Day BETWEEN 5 AND 3 THEN '2. Med-Spend'
      ELSE '3. Low-Spend'
END Spend_bucket,

--Categorical
       store_location,
         product_category,
         product_type
FROM workspace.default.bright_coffee_sales
GROUP BY Transaction_Date,
         Day_Name,
         Purchase_Time,
         time_bucket,
         store_location,
         product_category,
         product_type;

     
