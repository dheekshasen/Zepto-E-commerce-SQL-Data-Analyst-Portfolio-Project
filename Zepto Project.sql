drop table if exists zepto;

Create table zepto(sku_id Serial Primary key,
Category VARCHAR(120), 
Name VARCHAR(150) not NULL,
mrp NUMERIC(8,2),
DiscountPercentage NUMERIC(5,2), 
Availablequantity integer, 
"Discounted Selling Price" numeric(8,2),
WeightinGrams Integer, 
outofstock Boolean, 
quantity integer);

-- data exploration

--count of rows 
Select Count(*) From zepto;

--sample data
Select * From zepto
limit 10;

-- Null values
select * from zepto 
where name is null
or Category is null
or mrp is null
or discountpercentage is null
or "Discounted Selling Price" is null
or WeightinGrams is null
or availablequantity is null
or Outofstock is null
or quantity is null;

--different product categories
Select distinct category from zepto
order by category;

-- products in stock vs out of stock
Select Outofstock, count(sku_id) 
from zepto
group by Outofstock;

--product names present multiple times
Select Name, count(sku_id)
From zepto
Group by Name
having count(sku_id)>1
order by count(sku_id) DESC;

--data cleaning
select *
from zepto
where mrp=0 or "Discounted Selling Price"=0 ;

Delete from zepto
where mrp=0;

--converting paise into rupees 
Update zepto
set mrp =mrp/100.0, 
"Discounted Selling Price"= "Discounted Selling Price"/100.0;

Select mrp, "Discounted Selling Price"
from zepto;

-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp, discountpercentage
from zepto
order by discountpercentage Desc
Limit 10;

-- Q2.What are the Products with High MRP but Out of Stock
Select distinct name, mrp
from zepto 
Where outofstock= True and mrp>300
Order by mrp desc;

-- Q3.Calculate Estimated Revenue for each category
Select Category, Sum(availablequantity * "Discounted Selling Price") as Estimated_Revenue
From Zepto
Group by category
Order by Estimated_Revenue;

-- Q4. Find all products where MRP is greater than <500 and discount is less than 10%.
Select distinct name, mrp, DiscountPercentage
from zepto
Where mrp > 500 and DiscountPercentage < 10 
Order by mrp desc, DiscountPercentage desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
Select Category, 
round(Avg(DiscountPercentage),2) AS Avg_Dis
From zepto
Group by Category 
Order by Avg(DiscountPercentage) Desc
Limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
Select distinct name,weightingrams, "Discounted Selling Price", Round("Discounted Selling Price"/weightingrams,2) as Pricepergram
From Zepto
Where weightingrams >=100
Order by Pricepergram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
Select distinct name, weightingrams, 
Case when weightingrams < 1000 then 'low' 
when weightingrams < 5000 then 'medium'
Else 'Bulk'
End as weight_cat
From zepto;

-- Q8.What is the Total Inventory Weight Per Category
SELECT category,
SUM(weightInGrams * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;