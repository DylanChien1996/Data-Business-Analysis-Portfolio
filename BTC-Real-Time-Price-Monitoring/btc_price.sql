CREATE DATABASE market_data;
USE market_data;
CREATE TABLE btc_price (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10),
    price_usd DECIMAL(18,8),
    collected_at DATETIME
);
SHOW TABLES;
