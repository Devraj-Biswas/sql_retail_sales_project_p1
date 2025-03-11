--SQl Retail Sales Analysis - P1

-- Creating Database sql_project_p1
create database sql_project_p1;

-- Creating Table retail_sales
drop table if exists retail_sales;
Create table retail_sales 
			(
				transactions_id int primary key,
				sale_date date,
				sale_time time,
				customer_id int,
				gender varchar(15),
				age int,
				category varchar(15),
				quantiy int,
				price_per_unit float,
				cogs float,
				total_sale float
			);

-- Importing SQL - Retail Sales Analysis_utf .csv dataset to TABLE retail_sales
BULK INSERT retail_sales
FROM 'D:\Study Zone\Desktop Project Notes and dataset files\Retail Sales Analysis SQL Project\Retail-Sales-Analysis-SQL-Project--P1-main\Retail-Sales-Analysis-SQL-Project--P1-main\SQL - Retail Sales Analysis_utf .csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


select * from retail_sales;

select top 10 * from retail_sales;

select count(*) from retail_sales;

-- Data Cleaning
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_date is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null
	;

delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_date is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null
	;

-- Data Exploration 

-- How many sales we have?
select count(*) as total_sale from retail_sales

-- How many unique customers we have?
select count(distinct customer_id) as total_unique_customers from retail_sales;

-- How many unique Category we have?
select count(distinct category) as total_unique_category from retail_sales;

select Distinct category as unique_category_Name from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
--Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:
--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
--Q8.**Write a SQL query to find the top 5 customers based on the highest total sales **:
--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:
--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):


--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * from retail_sales
where sale_date = '2022-11-05';

--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where
category = 'clothing'
and
sale_date between '2022-11-01' and '2022-11-30'
and 
quantiy >= 4 ;


--Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:

select 
	category, 
	SUM(total_sale) as Net_Sales,
	count(*) as Total_Orders
from retail_sales
group by category;


--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select category, avg(age) Average_Age 
from retail_sales
where category = 'Beauty'
group by category ;


--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale >1000 ;


--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

Select category, gender, COUNT(*) as Total_Transactions
from retail_sales
group by category, gender;


--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

with cte as 
(
	select 
		year(sale_date) as Year, 
		MONTH(sale_date) as Month,
		round(avg(total_sale),2) as Avg_sale,
		RANK() over(partition by year(sale_date) order by avg(total_sale) desc) as Rank
	from retail_sales
	group by year(sale_date),MONTH(sale_date)
)
select year, month, Avg_sale from cte
where rank = 1 ;


--Q8.**Write a SQL query to find the top 5 customers based on the highest total sales **:

select top 5 customer_id, SUM(total_sale) as Total_Sales
from retail_sales
group by customer_id
order by Total_Sales desc ;


--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:

select category, count(distinct customer_id) as Count_of_Unique_Customers
from retail_sales
group by category ;


--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

With Hourly_Sales as
(
select *,
	Case
		when datepart(hour,sale_time) < 12 then 'Morning'
		when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	End as shift
from retail_sales
)

Select 
	shift,
	COUNT(*) as Total_Orders
from Hourly_Sales
group by shift ;


--END of Project--


