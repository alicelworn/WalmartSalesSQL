CREATE DATABASE IF NOT EXISTS WalmartSales;

CREATE TABLE IF NOT EXISTS Sales(
	invoice_id varchar(30) NOT NULL PRIMARY KEY,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6, 4),
    total decimal (12, 4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar(15) not null,
    cogs decimal (10,2) not null,
    gross_margin_pct FLOAT(11, 9),
    gross_income decimal (12, 4) not null,
    rating FLOAT (2, 1)
);

-- ----------------------Feature Engineering----------------------------------------

-- time_of_day

Select
	time,
    (CASE
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
        end
        ) as time_of_date
From sales;
Alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (CASE
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
        end);
        
-- day name
select
	date,
    dayname(date) as day_name
    from sales;
alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- month name
select
	date,
    monthname(date)
    from sales;

alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);


-- ---------------------------------------------------------------
-- Generic --
-- How many cities does the data have?
select
	distinct city
    from sales;

select 
	distinct branch
    from sales;

-- in which city is each branch
select
	distinct city,
    branch
    from sales;

-- ----------------------------------------------------------------
-- product 

-- Number of unique product lines
select
	count(distinct product_line)
    from sales;
    
-- common payment method

select
	payment_method,
	count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

-- best selling product
select
	product_line,
	count(product_line) as cnt
    from sales
    group by product_line
    order by cnt desc;

-- monthly revenue
select
	month_name as month,
    sum(total) as total_revenue
    from sales
    group by month_name
    order by total_revenue desc;

-- most cogs in month
select
	month_name as month,
    sum(cogs) as total_cogs
    from sales
    group by month_name
    order by total_cogs desc;
    
-- product line with most revenue
select
	product_line,
	sum(total) as total_revenue
    from sales
    group by product_line
    order by total_revenue desc;
    
-- city with the most revenue
select
	branch,
	city,
    sum(total) as city_revenue
    from sales
    group by city, branch
    order by city_revenue desc;

-- product line with most VAT
select
	product_line,
    avg(vat) as avg_tax
    from sales
    group by product_line
    order by avg_tax desc;

-- Branch that sold more product than average
select
	branch,
    sum(quantity)
    from sales
    group by branch
    having sum(quantity) > (select avg(quantity) from sales);

-- most purchased product line by gender
select
	gender,
	product_line,
    count(gender) as cnt
    from sales
    group by gender, product_line
    order by cnt desc;
    
-- product with the best avg rating
select
	avg(rating) as avg_rating,
    product_line
    from sales
    group by product_line
    order by avg_rating desc;

-- ----------------------------------------------
-- sales

-- number of sales made each time of the day
select
	time_of_day,
    count(*) as total_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sales desc;

-- Customer type with most revenue
Select
	customer_type,
    sum(total) as total_rev
    from sales
    group by customer_type
    order by total_rev desc;



