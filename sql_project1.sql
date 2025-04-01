-- SQL Retail Sales Analysis - P1
Create database sql_project1;

-- Create TABLE
Drop table if exists retail_sales;
Create table retail_sales
           (
                transaction_id INT primary key,	
                sale_date date,	 
                sale_time time,	
                customer_id	int,
                gender	varchar(15),
                age	INT,
                category varchar(30),	
                quantity int,
                price_per_unit float,	
                cogs float,
                total_sale float
            );

select * from retail_sales limit 10;

select count(*)from retail_sales;

-- Data Cleaning
select * from retail_sales
where transaction_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
Where sale_time is null;

select * from retail_sales
where
    transaction_id is null
    OR
    sale_date is null
    OR 
    sale_time is null
    OR
    gender is null
    OR
    category is null
    OR
    quantity is null
    OR
    cogs is null
    OR
    total_sale is null;
    
-- 
Delete from retail_sales
Where
    transaction_id is null
    OR
    sale_date is null
    OR 
    sale_time is null
    OR
    gender is null
    OR
    category is null
    OR
    quantity is null
    OR
    cogs is null
    OR
    total_sale is null;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many uniuque customers we have ?
select count(distinct customer_id) as total_sale from retail_sales;


select distinct category from retail_sales;


-- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

select * from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales
Where
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,
    sum(total_sale) as Total_sales
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'	

or

SELECT ROUND(AVG(age)) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
Where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select category, gender,
count(*) as total_trans
from retail_sales
group by category, gender
order by 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?

select year, month, avg_sale
from 
(    
select 
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,
    sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,    
count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
    case
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as shift
from retail_sales
)
select 
    shift,
    count(*) as total_orders    
from hourly_sale
group by shift

-- End of project