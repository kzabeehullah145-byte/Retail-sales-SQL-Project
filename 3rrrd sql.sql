DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
			Customer_id VARCHAR(50) PRIMARY KEY,
			Customer_name VARCHAR(50),
			Gender VARCHAR(50),
			Age INT,
			Segment VARCHAR(50),
			State VARCHAR(50),
			City VARCHAR(50),
			CustomerSince DATE,
			PreferredChannel VARCHAR(50),
			IsActive BOOLEAN
);


SELECT * FROM customers;


DROP TABLE IF EXISTS Date;

CREATE TABLE Date(
		DateKey VARCHAR(50) PRIMARY KEY,
		Date DATE,
		Year INT,
		Quarter VARCHAR(50),
		MonthNumber INT,
		MonthName VARCHAR(50),
		YearMonth VARCHAR(50),
		WeekOfYear INT,
		DayOfWeekNumber INT,
		DayName VARCHAR(50),
		IsWeekend BOOLEAN,
		FiscalYear INT,
		FiscalMonthNumber INT,
		FiscalQuarter VARCHAR(50)
		
);

SELECT * FROM Date;

DROP TABLE IF EXISTS Products;

CREATE TABLE Products(
		ProductID VARCHAR(50) PRIMARY KEY,
		ProductName VARCHAR(50),
		Brand VARCHAR(50),
		Category VARCHAR(50),
		Subcategory VARCHAR(50),
		ListPrice INT,
		StandardCost INT,
		LaunchDate DATE,
		IsActive BOOLEAN
);

SELECT * FROM Products;

DROP TABLE IF EXISTS Stores;

CREATE TABLE Stores(
		StoreID VARCHAR(50) PRIMARY KEY,
		StoreName VARCHAR(50),
		Region VARCHAR(50),
		State VARCHAR(50),
		City VARCHAR(50),
		Channel VARCHAR(50),
		OpenDate DATE,
		StoreType VARCHAR(50)
);

SELECT * FROM Stores;

DROP TABLE IF EXISTS Sales_Fact;

CREATE TABLE Sales_Fact(
		Order_ID VARCHAR(50) PRIMARY KEY,
		OrderDate INT,
		CustomerID VARCHAR(50) REFERENCES Customers(Customer_id),
		ProductID VARCHAR(50) REFERENCES Products(ProductID),
		StoreID VARCHAR(50) REFERENCES Stores(StoreID),
		Quantity INT,
		UnitPrice INT,
		DiscountPct NUMERIC(5,4),
		GrossSales INT,
		NetRevenue INT,
		COGS INT,
		Profit INT,
		PaymentMethod TEXT,
		PromoCode VARCHAR(50),
		ShipDays INT,
		ShipMode TEXT,
		ReturnedFlag BOOLEAN
		
);

SELECT * FROM Sales_Fact;

SELECT * FROM customers;
SELECT * FROM Date;
SELECT * FROM Products;
SELECT * FROM Stores;



-- 1) Count the total number of sales transactions?
SELECT COUNT(*) AS total_transactions 
					FROM Sales_Fact;


-- 2) Count the total number of customers?
SELECT COUNT(*) AS total_customers
		FROM Customers;

-- 3) Count the total number of products?
SELECT COUNT(*) AS total_products
		FROM Products;



-- 4) Count the total number of stores?
SELECT COUNT(*) AS total_stores
		FROM Stores;

-- 5) Find the total quantity sold?
SELECT SUM(quantity) AS total_quantity_sold
		FROM sales_fact;

-- 6) Find the total gross sales?
SELECT SUM(grosssales) AS total_gross_sales
			FROM sales_fact;

-- 7) Find the total net revenue? 
SELECT SUM(netrevenue) AS total_net_revenue
		FROM sales_fact;

-- 8) Find the total profit?
SELECT SUM(profit) AS total_profit
		FROM sales_fact;

-- 9) Find the average unit price?
SELECT ROUND(AVG(unitprice),2) AS avg_unit_price
		FROM sales_fact;

-- 10) Find the average discount percentage?
SELECT ROUND(AVG(discountpct),2) AS avg_discount_percentage
		FROM sales_fact;

-- 11) Find the total sales by payment method?
SELECT paymentmethod, SUM(netrevenue) AS total_sales
		FROM sales_fact
		GROUP BY paymentmethod
		ORDER BY total_sales DESC;
		

-- 12) Count orders by shipping mode?
SELECT shipmode, COUNT(*) AS total_orders 
		FROM sales_fact
		GROUP BY shipmode;

-- 13) Count returned vs non-returned orders?
SELECT returnedflag, COUNT(*) AS total_orders
			FROM sales_fact
			GROUP BY returnedflag;
			
-- 14) Find the average shipping days by shipping mode?
SELECT shipmode, ROUND(AVG(shipdays),2) AS avg_shipdays
		FROM sales_fact
		GROUP BY shipmode;
-- 15) Find the total sales by store?		
SELECT storename, SUM(netrevenue) AS total_sales
FROM (SELECT s.storeid,s.storename, d.netrevenue
		FROM stores s
		JOIN
		sales_fact d
		ON s.storeid= d.storeid)
		GROUP BY storename
		ORDER BY total_sales DESC;
		
-- 16) Find the total sales by state?
SELECT c.state, SUM(sf.netrevenue) AS total_sales
    		FROM customers c
			JOIN
			sales_fact sf
			ON sf.customerid = c.customer_id
				GROUP BY c.state
				ORDER BY total_sales DESC;

-- 17) Find the total sales by city?
SELECT c.city, SUM(sf.netrevenue) AS total_sales
			FROM customers c
			JOIN
			sales_fact sf
			ON c.customer_id = sf.customerid
			GROUP BY c.city
			ORDER BY total_sales DESC;

-- 18) Find the total sales by sales channel?
SELECT c.preferredchannel, SUM(sf.netrevenue) AS total_sales
			FROM customers c
			JOIN
			sales_fact sf
			ON c.customer_id = sf.customerid
			GROUP BY c.preferredchannel
			ORDER BY total_sales DESC;

-- 19) Find the top 10 stores by revenue?
SELECT s.storeid, s.storename, SUM(netrevenue) AS total_sales
		FROM stores s
		JOIN
		sales_fact sf
		ON s.storeid = sf.storeid
		GROUP BY  s.storeid, s.storename
		ORDER BY  total_sales DESC
		LIMIT 10;

-- 20) Find the bottom 10 stores by revenue?
SELECT s.storeid, s.storename, SUM(netrevenue) AS total_sales
		FROM stores s
		JOIN
		sales_fact sf
		ON s.storeid = sf.storeid
		GROUP BY  s.storeid, s.storename
		ORDER BY  total_sales ASC
		LIMIT 10;


-- 21) Find the top 10 best selling products?
SELECT p.productname, SUM(sf.netrevenue) AS total_sales
			FROM products p
			JOIN
			sales_fact sf
			ON p.productid = sf.productid
			GROUP BY p.productname
			ORDER BY total_sales DESC
			LIMIT 10;
			
-- 22) Find the lowest selling products?
SELECT p.productid, p.productname, SUM(sf.netrevenue) AS total_sales
			FROM products p
			JOIN
			sales_fact sf
			ON p.productid = sf.productid
			GROUP BY p.productname, p.productid
			ORDER BY total_sales ASC
			LIMIT 1


-- 23) Find total revenue by category?	
SELECT p.category, SUM(sf.netrevenue) AS total_sales
		FROM products p
		JOIN
		sales_fact sf
		ON p.productid = sf.productid
		GROUP BY p.category
		ORDER BY total_sales DESC;

-- 24) Find total profit by category?
SELECT p.category, SUM(sf.profit) AS total_profit
		FROM products p
		JOIN 
		sales_fact sf
		ON p.productid = sf.productid
		GROUP BY p.category
		ORDER BY total_profit DESC;

-- 25) Find revenue by subcategory?
SELECT p.subcategory, SUM(sf.netrevenue) AS total_sales
		FROM products p
		JOIN
		sales_fact sf
		ON p.productid = sf.productid
		GROUP BY P.subcategory
		ORDER BY total_sales DESC;

-- 26) Find the most expensive products?
SELECT p.productid, p.productname, MAX(sf.unitprice) AS highest_price
			FROM products p
			JOIN 
			sales_fact sf
			ON p.productid = sf.productid
			GROUP BY  p.productid, p.productname
			ORDER BY highest_price DESC
			LIMIT 1;

-- 27) Find the cheapest products?		
SELECT p.productid, p.productname, MIN(sf.unitprice) AS lowest_price
			FROM products p
			JOIN 
			sales_fact sf
			ON p.productid = sf.productid
			GROUP BY  p.productid, p.productname
			HAVING MIN(sf.unitprice) = (SELECT MIN(sf.unitprice) 
										FROM sales_fact sf);
			
-- 28) Find inactive products?
SELECT p.productid, p.productname, p.category, p.subcategory, sf.netrevenue
		FROM products p
		LEFT JOIN
		sales_fact sf
		ON p.productid = sf.productid
		WHERE sf.productid is NULL;

-- 29) Find products that generated no sales?		
SELECT p.productid, p.productname, p.category, p.subcategory, sf.netrevenue
		FROM products p
		LEFT JOIN
		sales_fact sf
		ON p.productid = sf.productid
		WHERE sf.productid is NULL;

-- 30) Rank products by total revenue?
SELECT p.productid, p.productname, SUM(sf.netrevenue) AS total_sales,
		RANK() OVER(ORDER BY SUM(sf.netrevenue) DESC) AS ranking
		FROM products p
		JOIN
		sales_fact sf
		ON p.productid = sf.productid
		GROUP BY p.productid, p.productname;
		
-- 	31) Find the top 10 customers by revenue?	
SELECT c.customer_id, c.customer_name, SUM(sf.netrevenue) AS total_sales
			FROM customers c
			JOIN
			sales_fact sf
			ON c.customer_id = sf.customerid
			GROUP BY c.customer_id, c.customer_name
			ORDER BY total_sales DESC
			LIMIT 10;
			
-- 32) Find customers with the highest number of orders?
SELECT c.customer_id, c.customer_name, COUNT(DISTINCT sf.order_id) AS total_orders
			FROM customers c
			JOIN
			sales_fact sf
			ON sf.customerid = c.customer_id
			GROUP BY c.customer_id, c.customer_name
			ORDER BY total_orders DESC
			LIMIT 1;

			
-- 33) Find average customer age?
SELECT ROUND(AVG(age),2) AS avg_age
			FROM customers;

-- 34) Find revenue by gender?
SELECT c.gender, SUM(sf.netrevenue) AS total_revenue
			FROM customers c
			JOIN
			sales_fact sf
			ON c.customer_id = sf.customerid
			GROUP BY c.gender
			ORDER BY total_revenue DESC;
			
-- 35) Find revenue by customer segment?
SELECT c.segment, SUM(sf.netrevenue) AS total_revenue
				FROM customers c
				JOIN
				sales_fact sf
				ON c.customer_id = sf.customerid
				GROUP BY c.segment
				ORDER BY total_revenue DESC;
				
-- 36) Find active vs inactive customers?				
SELECT c.customer_id, c.customer_name, c.segment,
		CASE
			WHEN sf.customerid is NULL THEN 'INACTIVE'
			ELSE 'ACTIVE'
			END AS customer_status
			FROM customers c
			LEFT JOIN 
			sales_fact sf
			ON sf.customerid = c.customer_id
			GROUP BY c.customer_id, c.customer_name, c.segment sf.customer_name;
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM sales_fact sf
            WHERE sf.customerid = c.customer_id
        ) THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS customer_status
FROM customers c;

SELECT * FROM Sales_Fact;

SELECT * FROM customers;
SELECT * FROM Date;
SELECT * FROM Products;
SELECT * FROM Stores;



