-- Create TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id	INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id INT,	
	gender VARCHAR(15), 	
	age INT,	
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,	
	total_sale FLOAT
);

-- DATA CLEANING
SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT (*) FROM retail_sales

-- REMOVE NULL
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE age IS NULL

SELECT * FROM retail_sales
WHERE category IS NULL

SELECT * FROM retail_sales
WHERE quantiy IS NULL

SELECT * FROM retail_sales
WHERE price_per_unit IS NULL

SELECT * FROM retail_sales
WHERE cogs IS NULL

SELECT * FROM retail_sales
WHERE total_sale IS NULL

-- SHORT WAY
SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL 
OR
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR 
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

--DELETE NULL
DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL 
OR
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR 
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

--DATA EXPLORATION

-- How Many Sales we have?
SELECT COUNT (*) as total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales

-- How many unique category we have?
SELECT COUNT (DISTINCT category) as total_sale FROM retail_sales

-- What are the category names?
SELECT DISTINCT category FROM retail_sales

--DATA ANALYSIS / BUSINESS KEY PROBLEMS AND ANSWERS

-- Write an sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

--Write a query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov 2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy >= 4

--Write a query to calculate the total sales for each category
--Check all categories from retail sales
SELECT * FROM retail_sales
--Then
SELECT category,
SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY 1
--To get total orders as well 
SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Write a query to find the averge age of customers who purchased items from the 'Beauty' category
SELECT AGE FROM retail_sales
--To find the averge
SELECT 
ROUND(AVG(age), 2) as avg_age
FROM retail_sales WHERE category = 'Beauty'

--Write a query to find all the transactions where the total sale trasactions is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

--Write a query to find the total number of transactions id made by each gender in each category.
--First do a group by bt categories then a groupby by genders

SELECT
category, gender,
COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

--Write a query to find the averge sale for each month . find the best selling month in each year,

SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_total_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,3 DESC

--To get rank

SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_total_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2

--TO GET JUST RANK1

SELECT * FROM
(SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_total_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1 
WHERE rank = 1

--Write a sql query to create each shifts and number of orders(Morning <=12, Afternoon Between 12 and 17, Evening >17 )
SELECT *,
CASE
WHEN EXTRACT(HOUR from sale_time) <=12 THEN 'Morning'
WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales

--to get number of orders
WITH hourly_sale
AS (
SELECT *,
CASE
WHEN EXTRACT(HOUR from sale_time) <=12 THEN 'Morning'
WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales )
SELECT shift, 
COUNT (*) AS total_orders

--End of project
FROM hourly_sale
GROUP BY shift

