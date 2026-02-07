-- Drop The Table
Drop table is exists Blinkit;

-- Create a table Blinkit
create table Blinkit(
Item_No serial primary key,
Item_Identifier varchar(50),
Item_Fat_Content varchar(50),
Item_Type varchar(200),
Outlet_Establishment_Year integer,
Outlet_Identifier varchar(100),
Outlet_Location_Type varchar(50),
Outlet_Size text ,
Outlet_Type varchar(200),
Item_Weight integer,
Sales integer
)
-- Show the table
select * from Blinkit;


-- Clean the messy data as well and check the null values as well
select * from Blinkit
where item_identifier is null
or
item_fat_content is null
or
item_type is null
or
outlet_establishment_year is null
or
outlet_identifier is null
or
outlet_location_type is null
or
outlet_size is null 
or
outlet_type is null
or
item_weight is null
or
sales is null;


-- Total sales of the company
select sum(sales) as total_sales 
from Blinkit;

-- Total no. of items sold
select count(*) as total_item
from Blinkit;

-- Average sales per item
select round(avg(sales),2) as average_sales
from Blinkit;

-- Distinct Item types
select distinct item_type from Blinkit;

-- Sales by item type
select item_type , sum(sales) as total_sales
from Blinkit
group by item_type
order by total_sales desc;

-- Top 5 highest selling item types
select item_type , sum(sales) as highest_selling
from Blinkit
group by item_type
order by highest_selling desc limit 5;

-- Sales by fat content
select item_fat_content , sum(sales) as total_sales
from Blinkit
group by item_fat_content;

-- Sales Outlet type
select outlet_type, sum(sales) as total_sales
from Blinkit
group by outlet_type
order by total_sales desc;

-- Sales by outlet size
select outlet_size , sum(sales) as total_sales
from Blinkit
group by outlet_size 
order by total_sales desc;

-- sales by location Tier
select outlet_location_type , sum(sales) as total_sales
from blinkit
group by outlet_location_type;

-- Best performing outlet
select outlet_identifier, sum(sales) as total_sales
from Blinkit
group by outlet_identifier
order by total_sales desc;

-- Average sales per outlet
select outlet_identifier , round(avg(sales),2) as average_sales
from Blinkit
group by outlet_identifier
order by average_sales desc;

-- Sales by establishment year
select outlet_establishment_year , sum(sales) as total_sales
from Blinkit
group by outlet_establishment_year
order by total_sales desc;

-- Correlation between  heavier weight,  which item sales more
select 
round(avg(item_weight),2) as avg_weight,
round(avg(sales),2) as avg_sales
from Blinkit;

-- Sales by weight range
select 
	case 
		when item_weight < 10 then 'Light'
		when item_weight between 10 and 15 then 'Medium'
		else 'Heavy'
		end as weight_category, 
sum(sales) as total_sales
from Blinkit
group by weight_category;

-- Top selling item in each outlet
select * 
from (
select outlet_identifier,
		item_identifier,
		sales,
		rank() over (partition by outlet_identifier order by sales desc) as rnk
		from Blinkit
) t
where rnk = 1;

-- Top item type in each location tier

select * 
from(
select 
outlet_location_type,
item_type,
sum(sales) as total_sales,
rank() over (partition by outlet_location_type order by sum(sales) desc) as rnk
from Blinkit
group by outlet_location_type , item_type
) x
where rnk = 2;


-- Contribution % of each item typenin total sales
select
item_type,
sum(sales) as total_sales, 
round(100.0 * sum(sales) / sum(sum(sales)) over() ,2)  as contribution_percentage
from Blinkit
group by item_type
order by contribution_percentage desc;

-- Outlet which sells maximum low fat products
select outlet_identifier, sum(sales) as total_sales
from Blinkit
where item_fat_content = 'Low Fat'
group by outlet_identifier
order by total_sales desc;
