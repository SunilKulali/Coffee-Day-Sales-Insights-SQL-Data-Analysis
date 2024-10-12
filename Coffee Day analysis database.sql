Create database Coffee;
USE COFFEE;
drop database coffee;

create table Product (
product_id int primary key,
product_name varchar(50),
price int
);

select * from product;

create table City (
city_id int primary key,
city_name varchar(25),
Population int,
Estimated_rent int,
city_rank int
);

select * from city;

create table customers (
customer_id int primary key,
customer_name varchar(25),
city_id int,
foreign key(city_id) references city(city_id)
);

select * from customers;

create table sales (
sales_id int primary key,
sales_date date,
product_id int,
customer_id int,
total int,
rating int,
foreign key (product_id) references product (product_id),
foreign key (customer_id) references customers (customer_id)
);

select * from product;
select * from city;
select * from customers;
select * from sales;