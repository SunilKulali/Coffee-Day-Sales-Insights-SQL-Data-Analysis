-- QUESTION AND ANSWER

select * from product;
select * from city;
select * from customers;
select * from sales;

-- 1) Display total sales for each product along with the product name?
select sum(s.total) as total_sales, p.product_name from sales as s
join product as p on p.product_id=s.product_id
group by product_name;

-- 2) Find the top 3 cities with the highest estimated rent?
select city_name, estimated_rent as highest_estimated_rent from city
order by highest_estimated_rent desc limit 3;

-- 3) Find customers who have made a purchase greater than 1000?
select c.customer_name, s.total from customers as c
join sales as s on s.customer_id=c.customer_id
where s.total>1000; 

-- 4)Find the total number of sales for each customer?
select c.customer_name, count(s.sales_id) as total_sales, sum(total) over(partition by customer_name ) as total_amountspent from customers as c
join sales as s on s.customer_id = c.customer_id
group by c.customer_name;

-- 5)Calculate total sales, maximum sales, and average sales by city and product?
select c.city_name, p.product_name, sum(s.total) as total_sales, avg(s.total) as avg_sales, max(s.total) as max_sales from city as c
join customers as cu on cu.city_id=c.city_id
join sales as s on s.customer_id=cu.customer_id
join product as p on p.product_id=s.product_id
group by c.city_name, p.product_name ;


-- Advanced
-- 1) Find customers who have purchased more than 3 different products?
select c.customer_name, count(distinct s.product_id) as product_count from customers as c
join sales as s on s.customer_id= c.customer_id
 group by c.customer_name
 having product_count >3;
 
  -- 2)Display the total sales by each city and find cities where total sales exceed 4,00,000?
  with totalsalespercity as (select c.city_name, sum(s.total) as total_sales from city as c
  join customers as cu on cu.city_id=c.city_id 
  join sales as s on s.customer_id =cu.customer_id
  group by city_name)
  
  select city_name, total_sales from totalsalespercity
  where total_sales> 400000;
  
  -- 3) Find the average product price for each city and list cities where the average price is above 500?
with averagepricepercity as (select c.city_name, avg(p.price) as Avg_product_price from product as p
join sales as s on s.product_id=p.product_id
join customers as cu on cu.customer_id=s.customer_id
join city as c on c.city_id= c.city_id
group by c.city_name)

select city_name, Avg_product_price from  averagepricepercity
where Avg_product_price > 500;

-- 4)Running Total (Cumulative Sum) of Sales for Each Customer
select c.customer_name, sum(s.total) over (partition by c.customer_name order by s.sales_date) as Running_total from customers as c
join sales as s on s.customer_id = c.customer_id;

-- 5) Rank products based on total sales
select p.product_name, sum(s.total) as total_sales, rank() over (order by sum(s.total) desc) as Rank_sales from product as p
join sales as s on s.product_id = p.product_id
group by p.product_name;

-- 6) Find the best-selling product in each city?
select city_name, product_name, total_sales from  (
select c.city_name, p.product_name, sum(s.total) as total_sales, rank() over (partition by c.city_name order by sum(s.total) desc) as product_rank  from city as c
join customers as cu on cu.city_id=c.city_id
join sales as s on s.customer_id=cu.customer_id
join product as p on p.product_id=s.product_id
group by c.city_name, p.product_name) as rank_product
where product_rank=1;

-- 7) Cumulative Average Sales per Product by Date
select p.product_name, s.sales_date, s.total,  avg(s.total) over (partition by p.product_name order by s.sales_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_avgsales from product as p
join sales as s on s.product_id=p.product_id;

-- 8) Get the last purchase made by each customer
select c.customer_name, s.sales_date, s.total from customers as c
join sales as s on s.customer_id=c.customer_id
where s.sales_date = (select max(s2.sales_date) from sales as s2 
where s2.customer_id=c.customer_id);
