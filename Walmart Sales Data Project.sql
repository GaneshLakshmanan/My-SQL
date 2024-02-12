------------------------------------------------------------------------ Walmart Sales Data ------------------------------------------------------------------------------------

-- Creating Table

create database walmart_sales_data;
use walmart_sales_data;
create table sales(invoice_id varchar(50) not null primary key,
				   branch varchar(10) not null,
                   city varchar(30) not null,
                   customer_type varchar(50) not null,
                   gender varchar(30) not null,
                   product_line varchar(100) not null,
                   unit_price decimal(10,2) not null,
                   quantity int not null,
                   vat float(6,4) not null,
                   total decimal(12,4) not null,
                   date datetime not null,
                   time time not null,
                   payment_method varchar(15) not null,
                   cogs decimal(10,2) not null,
                   gross_margin_per float(11,9),
                   gross_income decimal(12,4) not null,
                   rating float(2,1));

select * from sales;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------- Feature Engineering ------------------------------------------------------------------------------------
-- time_of_day

select time,
			(case
				when `time` between "00:00:00" and "12:00:00" then "Morning"
                when `time` between "12:01:00" and "16:00:00" then "Afternoon"
                else "Evening"
			end
            ) as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);
update sales
set time_of_day = (
		case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
			when `time` between "12:01:00" and "16:00:00" then "Afternoon"
			else "Evening"
		end
);

-- day_name

select date,dayname(date) as day_name from sales;
alter table sales add column day_name varchar(20);
update sales
set day_name = dayname(date);


-- month_name
select date,monthname(date) as month_name from sales;
alter table sales add column month_name varchar(20);
update sales
set month_name = monthname(date);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from sales;
alter table sales modify column day_name varchar(20) after date;
alter table sales modify column time_of_day varchar(20) after time;
alter table sales modify column month_name varchar(20) after day_name;


-- Business Questions

-- how many unique cities does the data have?
select distinct city from sales;

-- in which city is each branch?
select distinct city,branch from sales;

-- how many unique product lines does the data have?
select distinct product_line from sales;

-- what is the most common payment method?
select payment_method,count(payment_method) as cnt from sales group by payment_method order by cnt desc;

-- what is the most selling product line?
select product_line,count(product_line) as cnt from sales group by product_line order by cnt desc;

-- what is the total revenue by month?
select month_name as month,sum(total) as total_revenue from sales group by month_name order by total_revenue desc;

-- what month has the largest COGS?
select month_name as month,sum(cogs) as largest_cogs from sales group by month_name order by largest_cogs desc;

-- what product line had the largest revenue?
select product_line as product,sum(total) as total_revenue from sales group by product_line order by total_revenue desc;

-- what is the city with largest revenue?
select city,sum(total) as largest_revenue from sales group by city order by largest_revenue desc;

-- what product line had the largest VAT?
select product_line as product,avg(vat) as largest_vat from sales group by product_line order by largest_vat desc;

-- which branch sold more products than average product sold?
select branch,sum(quantity) as qty from sales group by branch having sum(quantity) > (select avg(quantity) as average from sales);

-- what is the most common product line by gender?
select gender,product_line,count(gender) as total_cnt from sales group by gender,product_line order by total_cnt desc;

-- what is the average rating for each product line?
select product_line,round(avg(rating), 2) as average from sales group by product_line order by average desc;



-- Sales related queries

-- Number of sales made in each time of the day per weekday?
select time_of_day,count(*) as total_count from sales where day_name = "Monday" group by time_of_day order by total_count desc;

-- which of the customer types brings the most revenue?
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

-- which city has the largest tax percent/VAT(Value Added Tax)?
select city,avg(vat) as tax_percent from sales group by city order by tax_percent desc;

-- which customer type pays the most in VAT?
select customer_type,avg(vat) as vat from sales group by customer_type order by vat desc;


-- Customer related queries

-- how many unique customer types does the data have?
select distinct customer_type,count(customer_type) as total_count from sales group by customer_type order by total_count desc;

-- how many unique payment methods does the data have?
select distinct payment_method,count(payment_method) as total_count from sales group by payment_method order by total_count desc;

-- what is the most common customer type?
Select customer_type, count(*) as total_customers from sales group by customer_type order by total_customers desc limit 1;

-- what is the gender of most of the customers?
select gender,count(*) as gender_count from sales group by gender order by gender_count desc;

-- which time of the day do customers give more ratings?
select time_of_day,avg(rating) as average_ratings from sales group by time_of_day order by average_ratings desc;

-- which time of the day do customers give more ratings per branch?
select time_of_day,avg(rating) as average_ratings from sales where branch = "C" group by time_of_day order by average_ratings desc;








                    