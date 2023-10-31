/* Northwind data analysis */

/* Total sales by the company*/

SELECT ROUND(CAST(SUM(unitprice * quantity) AS NUMERIC), 0) AS Total_sales
FROM order_details;

/* Total quantity sold by the company*/

SELECT SUM(quantity) AS total_quantity
FROM order_details;

/* Total sales by each country of exports*/
/* Total sales of top 5 country */

SELECT o.shipcountry, ROUND(CAST(SUM(od.unitprice * od.quantity) AS NUMERIC), 0) AS Total_sales
FROM order_details AS od
INNER JOIN orders AS o
ON od.orderid = o.orderid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

/* Total quantity sold by each country of exports*/

SELECT o.shipcountry, ROUND(CAST(SUM(od.quantity) AS NUMERIC), 0) AS Total_quantity_sold
FROM order_details AS od
INNER JOIN orders AS o
ON od.orderid = o.orderid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

/* Name and price of the cheapest product */

SELECT productname, unitprice
FROM products 
ORDER BY unitprice ASC

/* Highest total quantity supplied by each supplier */

SELECT s.companyname, s.country, SUM(p.unitsinstock) AS suppliers_quantity
FROM suppliers s
INNER JOIN products p
ON s.supplierid = p.supplierid
GROUP BY 1,2
ORDER BY 3 DESC

/* Name and price of the expensive product */

SELECT productname, unitprice
FROM products 
ORDER BY unitprice 

/* Top 5 ordered product */

SELECT productname, SUM(quantity) AS total_quantity_ordered
FROM products p
INNER JOIN order_details od
ON p.productid = od.productid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

/* Bottom 5 ordered product */

SELECT productname, SUM(quantity) AS total_quantity_ordered
FROM products p
INNER JOIN order_details od
ON p.productid = od.productid
GROUP BY 1
ORDER BY 2 asc
LIMIT 5

/* Most supplied categories */

SELECT c.categoryname, SUM(p.unitsinstock) AS total_quantity
FROM categories c
INNER JOIN products p
ON c.categoryid = p.categoryid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* Least supplied categories */

SELECT c.categoryname, SUM(p.unitsinstock) AS total_quantity
FROM categories c
INNER JOIN products p
ON c.categoryid = p.categoryid
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;

/* Total sales by each year */

SELECT EXTRACT(YEAR FROM o.orderdate) AS year, 
	ROUND(CAST(SUM((od.unitprice * od.quantity) - (od.unitprice * od.quantity * od.discount)) AS NUMERIC), 0) AS total_sales
FROM orders o
INNER JOIN order_details od
ON o.orderid = od.orderid
GROUP BY 1 

/* Total quantity sold per year */

SELECT EXTRACT(YEAR FROM o.orderdate) AS year, SUM(od.quantity) AS total_quantity
FROM orders o
INNER JOIN order_details od
ON o.orderid = od.orderid
GROUP BY 1

/* Total quantity supplied by suppliers*/
 
SELECT s.companyname, p.unitsinstock
FROM products p
INNER JOIN suppliers s
ON p.supplierid = s.supplierid
GROUP BY 1,2
ORDER BY 2 

/* Total sales for each month */

SELECT 
	TO_CHAR(o.orderdate, 'month') AS "month", 
ROUND(CAST(SUM((od.unitprice * od.quantity) - (od.unitprice * od.quantity * od.discount)) AS NUMERIC), 0) AS total_sales
	FROM orders o
INNER JOIN order_details od
ON o.orderid = od.orderid
GROUP BY 1
ORDER BY 2 DESC

/* Total quantity sold for each month */

SELECT TO_CHAR(o.orderdate, 'month') AS "month", SUM(od.quantity) AS total_quantity 
FROM orders o
INNER JOIN order_details od
ON o.orderid = od.orderid
GROUP BY 1
ORDER BY 2 DESC
