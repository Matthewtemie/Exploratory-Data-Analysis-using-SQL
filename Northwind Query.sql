SELECT * FROM  customers

-- Removing Duplicates from the customer table
WITH Duplicated AS (
	SELECT DISTINCT ON (customer_id) *
	FROM customers
	ORDER BY customer_id
)

DELETE FROM  customers
WHERE customers.customer_id NOT IN (SELECT customer_id FROM Duplicated)

--- Checking for Null rows
SELECT * 
FROM customers
WHERE region IS NULL

-- Set Null Values to be Unknown
SELECT customer_id, contact_name, COALESCE(Region, 'Unknown') AS Region
FROM customers;

-- Analyze the Impact of NULLS
SELECT country, COUNT(*) AS TotalCustomers, COUNT(region) AS CustomersWithRegion, COUNT(*)-COUNT(region) AS CustomersWithoutRegion
FROM customers
GROUP BY country;

-- Exploratory Data Analysis
-- Get Products by Category
SELECT c.category_name,p.product_name
FROM products p
JOIN categories c
ON p.category_id = c.category_id
ORDER BY c.category_name

-- Get Most Expensive Product and Least Expensive Product List
(SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 1)

UNION ALL

(SELECT product_name, unit_price
FROM products
ORDER BY unit_price ASC
LIMIT 1);

-- Count the Current and Discontinued Products
SELECT 
	SUM(CASE WHEN discontinued = 0 THEN 1 ELSE 0 END) AS current_products,
	SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS discontinued_products
FROM products;


-- Get the Sales Amount for Each Employee
SELECT 
	e.employee_id,
	e.first_name || ' ' || e.last_name employee_name,
	SUM(od.Quantity*od.Unit_price*(1-od.discount)) Total_Sales
FROM employees e
JOIN orders o
ON e.employee_id = o.employee_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY e.employee_id, employee_name
ORDER BY Total_Sales DESC;


-- Show Sales data by categories for the year 1997 ONLY
SELECT c.category_name, 
	   SUM(od.Quantity*od.Unit_price*(1-od.discount)) Total_Sales
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY c.category_name;

-- For each category, get the list of products sold and total amount per product
SELECT c.category_name, 
	   p.product_name,
	   SUM(od.Quantity*od.Unit_price*(1-od.discount)) Total_Sales
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY c.category_name, p.product_name;
















