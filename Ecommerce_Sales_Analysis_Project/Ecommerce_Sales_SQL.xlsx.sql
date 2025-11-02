USE olist_db;
-- 1
CREATE TABLE olist_customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
-- 2
CREATE TABLE olist_orders_dataset (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_delivered_customer_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);
-- 3
CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id)
);
-- 4
CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR(50),
    payment_type VARCHAR(50),
    payment_value DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);
-- 5
CREATE TABLE olist_order_reviews_dataset (
    order_id VARCHAR(50),
    review_score INT,
    review_comment_message TEXT,
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);
-- 6
CREATE TABLE olist_products_dataset (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100)
);
-- 7
CREATE TABLE olist_sellers_dataset (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
-- 8
CREATE TABLE product_category_name_translation (
    product_category_name_english VARCHAR(100)
);
SHOW VARIABLES LIKE 'secure_file_priv';
-- 1-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, @dummy, customer_city, customer_state);

-- 2-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @dummy, @order_purchase_timestamp, @dummy2, @dummy3, @order_delivered_customer_date)
SET
order_purchase_timestamp = STR_TO_DATE(NULLIF(@order_purchase_timestamp, ''), '%Y-%m-%d %H:%i:%s'),
order_delivered_customer_date = STR_TO_DATE(NULLIF(@order_delivered_customer_date, ''), '%Y-%m-%d %H:%i:%s');

-- 3-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, @dummy, product_id, seller_id, @dummy, price, freight_value);

-- 4-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, @dummy, payment_type, @dummy, payment_value);

-- 5-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, order_id, review_score, @dummy, review_comment_message, @dummy, @dummy);

-- 6-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, @dummy1, @dummy2, @dummy3, @dummy4, @dummy5, @dummy6, @dummy7, @dummy8);

-- 7-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id, @dummy, seller_city, seller_state);

-- 8-1
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data raw/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, product_category_name_english);

-- Checking foreign key consistency
-- Orders → Customers
SELECT o.order_id
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order_items → Orders
SELECT i.order_id
FROM olist_order_items_dataset i
LEFT JOIN olist_orders_dataset o ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order_items → Sellers
SELECT i.seller_id
FROM olist_order_items_dataset i
LEFT JOIN olist_sellers_dataset s ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- Order_items → Products
SELECT i.product_id
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Orders → Payments
SELECT p.order_id
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Orders → Reviews
SELECT r.order_id
FROM olist_order_reviews_dataset r
LEFT JOIN olist_orders_dataset o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Confirm the number of transactions
SELECT 'Customers' AS TableName, COUNT(*) AS RowCount FROM olist_customers_dataset
UNION ALL SELECT 'Orders', COUNT(*) FROM olist_orders_dataset
UNION ALL SELECT 'Order_Items', COUNT(*) FROM olist_order_items_dataset
UNION ALL SELECT 'Payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL SELECT 'Reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL SELECT 'Products', COUNT(*) FROM olist_products_dataset
UNION ALL SELECT 'Sellers', COUNT(*) FROM olist_sellers_dataset
UNION ALL SELECT 'Category_Translation', COUNT(*) FROM product_category_name_translation;

-- Revenue Performance Analysis
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(i.price + i.freight_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY order_year, order_month;

-- Customer distribution analysis
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_customers DESC;

-- Product Category Performance analysis
SELECT 
    p.product_category_name,
    COUNT(DISTINCT i.order_id) AS total_orders,
    ROUND(SUM(i.price), 2) AS total_sales
FROM olist_order_items_dataset i
JOIN olist_products_dataset p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;

-- Review Scores analysis
SELECT 
    r.review_score,
    COUNT(r.review_score) AS count_reviews,
    ROUND(AVG(p.payment_value), 2) AS avg_payment_value
FROM olist_order_reviews_dataset r
JOIN olist_order_payments_dataset p ON r.order_id = p.order_id
GROUP BY r.review_score
ORDER BY r.review_score DESC;

-- Delivery Performance analysis
SELECT 
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
    COUNT(o.order_id) AS total_delivered
FROM olist_orders_dataset o
WHERE o.order_status = 'delivered';

ALTER TABLE olist_orders_dataset ENGINE = InnoDB;
ALTER TABLE olist_order_items_dataset ENGINE = InnoDB;
ALTER TABLE olist_order_payments_dataset ENGINE = InnoDB;
ALTER TABLE olist_order_reviews_dataset ENGINE = InnoDB;
ALTER TABLE olist_products_dataset ENGINE = InnoDB;
ALTER TABLE olist_sellers_dataset ENGINE = InnoDB;
ALTER TABLE product_category_name_translation ENGINE = InnoDB;

-- Export integrated version
(
  SELECT 'order_id','customer_state','payment_type','payment_value','review_score','price','freight_value','order_purchase_timestamp','order_delivered_customer_date'
)
UNION ALL
(
  SELECT 
      o.order_id,
      c.customer_state,
      p.payment_type,
      p.payment_value,
      r.review_score,
      i.price,
      i.freight_value,
      o.order_purchase_timestamp,
      o.order_delivered_customer_date
  FROM olist_orders_dataset o
  LEFT JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
  LEFT JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
  LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
  LEFT JOIN olist_order_items_dataset i ON o.order_id = i.order_id
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_clean_full_orders.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- revenue_monthly.csv
(
  SELECT 'order_year','order_month','total_revenue'
)
UNION ALL
(
  SELECT 
      YEAR(o.order_purchase_timestamp) AS order_year,
      MONTH(o.order_purchase_timestamp) AS order_month,
      ROUND(SUM(i.price + i.freight_value), 2) AS total_revenue
  FROM olist_orders_dataset o
  JOIN olist_order_items_dataset i ON o.order_id = i.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY order_year, order_month
  ORDER BY order_year, order_month
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/revenue_monthly.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- customer_state.csv
(
  SELECT 'customer_state','total_customers','total_orders'
)
UNION ALL
(
  SELECT 
      c.customer_state,
      COUNT(DISTINCT c.customer_id) AS total_customers,
      COUNT(DISTINCT o.order_id) AS total_orders
  FROM olist_customers_dataset c
  JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
  GROUP BY c.customer_state
  ORDER BY total_customers DESC
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_state.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- product_sales.csv

(
  SELECT 'product_category_name','total_orders','total_sales'
)
UNION ALL
(
  SELECT 
      p.product_category_name,
      COUNT(DISTINCT i.order_id) AS total_orders,
      ROUND(SUM(i.price), 2) AS total_sales
  FROM olist_order_items_dataset i
  JOIN olist_products_dataset p ON i.product_id = p.product_id
  GROUP BY p.product_category_name
  ORDER BY total_sales DESC
  LIMIT 10
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_sales.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- review_score.csv
(
  SELECT 'review_score','review_count','avg_payment_value'
)
UNION ALL
(
  SELECT 
      r.review_score,
      COUNT(r.review_score) AS review_count,
      ROUND(AVG(p.payment_value), 2) AS avg_payment_value
  FROM olist_order_reviews_dataset r
  JOIN olist_order_payments_dataset p ON r.order_id = p.order_id
  GROUP BY r.review_score
  ORDER BY r.review_score DESC
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/review_score.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- delivery_performance.csv
(
  SELECT 'avg_delivery_days','total_delivered'
)
UNION ALL
(
  SELECT 
      ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
      COUNT(o.order_id) AS total_delivered
  FROM olist_orders_dataset o
  WHERE o.order_status = 'delivered'
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delivery_performance.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';