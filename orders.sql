-- ====================================================
-- ORDERS & ORDER DETAILS TABLES
-- ====================================================

-- Create orders table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  total INTEGER NOT NULL,
  order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Show structure
\d orders

-- Create orders_detail table to store order items
CREATE TABLE orders_detail (
  id_order INTEGER NOT NULL,
  id_product VARCHAR(10) NOT NULL,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  PRIMARY KEY (id_order, id_product)
);

-- Show structure
\d orders_detail

-- Add foreign key constraints
ALTER TABLE orders_detail
  ADD CONSTRAINT fk_orders_detail_order
    FOREIGN KEY (id_order) REFERENCES orders(id),
  ADD CONSTRAINT fk_orders_detail_product
    FOREIGN KEY (id_product) REFERENCES products(id);

-- View table definition
-- PostgreSQL doesn’t have SHOW CREATE TABLE; use:
\d+ orders_detail

-- ====================================================
-- INSERT DATA & SAMPLE TRANSACTIONS
-- ====================================================

-- Insert sample order
INSERT INTO orders (total)
VALUES (50000);

-- View data
SELECT * FROM orders;
SELECT * FROM products;

-- Insert order details
INSERT INTO orders_detail (id_order, id_product, price, quantity)
VALUES 
  (1, 'P0001', 15000, 1),
  (1, 'P0002', 25000, 1);

INSERT INTO orders_detail (id_order, id_product, price, quantity)
VALUES 
  (2, 'P0003', 15000, 1),
  (3, 'P0004', 25000, 1);

INSERT INTO orders_detail (id_order, id_product, price, quantity)
VALUES 
  (2, 'P0001', 15000, 1),
  (3, 'P0003', 25000, 1);

-- ====================================================
-- JOIN ORDERS & PRODUCTS
-- ====================================================

SELECT orders.id, products.id, products.name, orders_detail.quantity, orders_detail.price
FROM orders
JOIN orders_detail
  ON orders.id = orders_detail.id_order
JOIN products
  ON products.id = orders_detail.id_product;

SELECT * FROM orders_detail;
SELECT * FROM orders;

-- ====================================================
-- ADDITIONAL EXAMPLES & JOINS
-- ====================================================

-- Insert new categories
INSERT INTO categories (id, name)
VALUES ('C0004', 'Oleh-oleh'),
       ('C0005', 'Sovenir');

-- Insert new test products (without linking to categories yet)
INSERT INTO products (id, name, price, quantity)
VALUES 
  ('Pxxxx1', 'test product 1', 10000, 100),
  ('Pxxxx2', 'test product 2', 10000, 100),
  ('Pxxxx3', 'test product 3', 10000, 100);

-- INNER JOIN categories and products
SELECT * FROM categories
INNER JOIN products
  ON categories.id = products.id_category;

-- LEFT JOIN
SELECT * FROM categories
LEFT JOIN products
  ON categories.id = products.id_category;

-- RIGHT JOIN
SELECT * FROM categories
RIGHT JOIN products
  ON categories.id = products.id_category;

-- CROSS JOIN
SELECT * FROM categories
CROSS JOIN products;

-- ====================================================
-- NUMBERS TABLE & CROSS JOIN EXAMPLE
-- ====================================================

-- Create numbers table
CREATE TABLE numbers (
  id INTEGER PRIMARY KEY
);

-- Insert sample numbers
INSERT INTO numbers (id)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Generate multiplication table
SELECT numbers1.id, numbers2.id, (numbers1.id * numbers2.id)
FROM numbers AS numbers1
CROSS JOIN numbers AS numbers2
ORDER BY numbers1.id, numbers2.id;

-- ====================================================
-- SUBQUERY & AGGREGATE EXAMPLES
-- ====================================================

-- Products priced above average
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Get max price from products
SELECT MAX(price) FROM products;

-- Update product price
UPDATE products
SET price = 1000000
WHERE id = 'Pxxxx3';

-- Max price again after update
SELECT MAX(price) FROM products;

-- Max price via subquery join with categories
SELECT MAX(cp.price)
FROM (
  SELECT price FROM categories
  INNER JOIN products
    ON categories.id = products.id_category
) AS cp;
