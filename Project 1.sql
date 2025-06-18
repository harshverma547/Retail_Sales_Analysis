-- SQL Retail Sales Analysis
Create DATABASE sql_project1;

CREATE TABLE retail_sales( 
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(20), 
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
)

-- Data Cleaning

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(*) FROM retail_sales
WHERE transactions_id IS NULL

SELECT COUNT(*) FROM retail_sales
WHERE sale_date IS NULL


SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL

--

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL



-- Data Explore
-- Q: How many sales we have?

SELECT COUNT(*) as total_sales FROM reatil_sales

-- Q: How many customers we have?

SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales

SELECT DISTINCT category FROM retail_sales



-- Data Analysis
-- Q1: Query to retrieve all columns for sales made on 2023-09-10
SELECT * FROM retail_sales where sale_date = '2023-09-10'


-- Q2: Query to retrieve all transactions where the category is clothing and quantity sold is more than 4 in month of sept-2023
SELECT 
	*
FROM retail_sales
where 
	category = 'Clothing'
	and 
	TO_CHAR(sale_date, 'YYYY-MM') = '2023-09'
	and 
	quantity >= 4


-- Q3 : Query to calculate total sales for each category
SELECT 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
FROM retail_sales
group by 1


-- Q4 : Query to find average age of customers who purchased items from beauty category
SELECT
	Round(Avg(age), 2) as avg_age
FROM retail_sales
where category = 'Beauty'


-- Q5 : Query to find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
where total_sale > 1000


-- Q6 : Query to find total number of transactions made by each gender in each category
SELECT 
	category,
	gender,
	count(*) as total_trans
FROM retail_sales
group
	by 
	category,
	gender
order by 1


-- Q7 : Query to calculate average sale for each month, find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT
		extract(YEAR FROM sale_date) as year,
		extract(MONTH FROM sale_date) as month,
		avg(total_sale) as avg_sale,
		RANK() over(partition by extract(YEAR FROM sale_date) order by avg(total_sale) desc) as rank
	FROM retail_sales
	group by 1,2
) as t1
WHERE rank = 1


-- Q8 : Query to find the to 5 customers based on highest total sales
SELECT 
	customer_id,
	sum(total_sale) as total_sales
FROM retail_sales
group by 1
order by 2 desc
limit 5


-- Q9 : Query to find number of unique customers who purchased items from each category
SELECT 
	category,
	count(distinct customer_id) as count_unique_cs
FROM retail_sales
group by category


-- Q10 : Query to create each shift and number of order (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)
with hourly_sale
as
(
SELECT *,
	case 
		when extract(hour FROM sale_time) < 12 then 'Morning'
		when extract(hour FROM sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
FROM retail_sales
)
SELECT 
	shift,
	count(*) as total_orders
FROM hourly_sale
group by shift
