USE org;
/*1.	Basic Queries:
1.1.	List all customers.
1.2.	Show all products in the 'Electronics' category.
1.3.	Find the total number of orders placed.
1.4.	Display the details of the most recent order.

2.	Joins and Relationships:
2.1.	List all products along with the names of the customers who ordered them.
2.2.	Show orders that include more than one product.
2.3.	Find the total sales amount for each customer.

3.	Aggregation and Grouping:
3.1.	Calculate the total revenue generated by each product category.
3.2.	Determine the average order value.
3.3.	Find the month with the highest number of orders.

4.	Subqueries and Nested Queries:
4.1.	Identify customers who have not placed any orders.
4.2.	Find products that have never been ordered.
4.3.	Show the top 3 best-selling products.

5.	Date and Time Functions:
5.1.	List orders placed in the last month.
5.2.	Determine the oldest customer in terms of membership duration.

6.	Advanced Queries:
6.1.	Rank customers based on their total spending.
6.2.	Identify the most popular product category.
6.3.	Calculate the month-over-month growth rate in sales.

7.	Data Manipulation and Updates:
7.1.	Add a new customer to the Customers table.
7.2.	Update the price of a specific product.*/


/*1.	Basic Queries:
1.1.	List all customers.*/
SELECT * FROM customers;

/*1.2.	Show all products in the 'Electronics' category.*/
SELECT * 
FROM products
WHERE category = 'Electronics';

/*1.3.	Find the total number of orders placed.*/
SELECT COUNT(orderid) AS 'total_orders_num'
FROM orders; /* I have not taken distinct in account as every customer will have unique orderid/* 

/*1.4.	Display the details of the most recent order.*/
SELECT *
FROM orders
ORDER BY orderdate DESC
LIMIT 1;


/*2.	Joins and Relationships:
2.1.	List all products along with the names of the customers who ordered them.*/
SELECT od.productid, c.customerid, p.name, c.name
FROM   orderdetails od
JOIN   products p
ON     od.productid = p.productid
JOIN   orders o
ON     od.orderid = o.orderid
JOIN   customers c 
ON     O.customerid = c.customerid;

/*2.2.	Show orders that include more than one product.*/
SELECT o.orderid, od.productid, p.name, od.quantity
FROM orders o
JOIN orderdetails od
ON o.orderid = od.orderid
JOIN products p
ON od.productid = p.productid
WHERE od.quantity > 1;

/*2.3.	Find the total sales amount for each customer.*/
SELECT c.customerid, c.name, o.totalamount
FROM customers c
JOIN orders o
ON c.customerid = o.customerid
ORDER BY c.customerid;


/*3.	Aggregation and Grouping:
3.1.	Calculate the total revenue generated by each product category.*/
SELECT p.category, SUM(o.totalamount) AS 'total_revenue'
FROM products p
JOIN orderdetails od
ON p.productid = od.productid
JOIN orders o
ON od.orderid = o.orderid
GROUP BY p.category;

/*3.2.	Determine the average order value.*/
SELECT AVG(totalamount) AS 'avg_order_value'
FROM orders;

/*3.3.	Find the month with the highest number of orders.*/
SELECT DATE_FORMAT(o.orderdate, '%Y-%m') AS 'month_of_order', SUM(od.quantity) AS 'total_order_quantity'
FROM orders o 
JOIN orderdetails od
ON o.orderid = od.orderid
GROUP BY month_of_order
ORDER BY total_order_quantity DESC
LIMIT 1;



/*4.	Subqueries and Nested Queries:
4.1.	Identify customers who have not placed any orders.*/
SELECT customerid, name
FROM customers
WHERE customerid NOT IN (
    SELECT customerid
    FROM orders);

/*4.2.	Find products that have never been ordered.*/
SELECT productid, name
FROM products
WHERE productid NOT IN (
    SELECT DISTINCT productid
    FROM orderdetails
);

/*4.3.	Show the top 3 best-selling products.*/
SELECT productid, name, total_order_quantity
FROM (
    SELECT  p.productid, p.name, SUM(od.quantity) AS 'total_order_quantity'
    FROM    products p
    JOIN    orderdetails od
	ON      p.productid = od.productid
    GROUP BY p.productid, p.name
) AS sales
ORDER BY total_order_quantity DESC
LIMIT 3;


/*5.	Date and Time Functions:
5.1.	List orders placed in the last month.*/
SELECT orderid, DATE_FORMAT(orderdate, '%Y-%m') AS 'order_month'
FROM orders
ORDER BY order_month DESC; /*considering dec as the last month*/

/*5.2.	Determine the oldest customer in terms of membership duration.*/
SELECT customerid, name, joindate
FROM customers
ORDER BY joindate ASC
LIMIT 1;



/*6.	Advanced Queries:
6.1.	Rank customers based on their total spending.*/
SELECT c.customerid, c.name, SUM(o.totalamount) AS 'total_spending',
       RANK() OVER (ORDER BY totalamount DESC) AS 'customer_rank'
FROM customers c
JOIN orders o 
ON c.customerid = o.customerid
GROUP BY c.customerid
ORDER BY customer_rank;

/*6.2.	Identify the most popular product category.*/
SELECT p.category, SUM(od.quantity) AS 'total_order'
FROM products p
JOIN orderdetails od
ON p.productid = od.productid
GROUP BY p.category
ORDER BY total_order DESC
LIMIT 1;

/*6.3.	Calculate the month-over-month growth rate in sales.*/
WITH cum_month_sales AS
(
	SELECT DATE_FORMAT(orderdate, '%m') AS 'order_month', SUM(totalamount) AS 'total_sales'
	FROM orders
	GROUP BY order_month
)
SELECT s.order_month, s.total_sales, s.total_sales-LAG(s.total_sales,1)  OVER(ORDER BY s.order_month) AS 'total_sales_growth'
FROM cum_month_sales s;



/*7.	Data Manipulation and Updates:
7.1.	Add a new customer to the Customers table.*/
INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES 
(11, 'Swagatika Samal', 'piscian_beauty@yahoo.com', '2023-12-12');

SELECT * FROM customers;

/*7.2.	Update the price of a specific product.*/
UPDATE products
SET price = 484.18
WHERE productid = 110;

SELECT * FROM products
WHERE productid = 110;




