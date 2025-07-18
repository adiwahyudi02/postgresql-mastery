-- ====================================================
-- CREATE & MODIFY TABLE
-- ====================================================

-- Create table `product` with fields and constraints
CREATE TABLE product (
  id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price INTEGER NOT NULL CHECK (price >= 1000),
  quantity INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  category TEXT
);

-- Rename table from `product` to `products`
ALTER TABLE product RENAME TO products;

-- PostgreSQL doesn't support ENUM easily; better to use CHECK constraint or TEXT.
-- Add category column (already added above), or use:
-- ALTER TABLE products ADD COLUMN category TEXT;

-- Add fulltext index (PostgreSQL uses GIN index on tsvector)
CREATE INDEX product_fulltext_idx
  ON products USING GIN (
    to_tsvector('simple', coalesce(name,'') || ' ' || coalesce(description,''))
  );

-- ====================================================
-- TABLE INFO & STRUCTURE
-- ====================================================

-- Show all tables
\dt

-- Describe table structure
\d products
-- or query catalog:
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'products';

-- No direct equivalent of SHOW CREATE TABLE;
-- Use: \d+ products or pg_dump --schema-only

-- ====================================================
-- INSERT DATA
-- ====================================================

INSERT INTO products (id, name, price, quantity, category)
VALUES ('P0001', 'Mie Ayam Original', 15000, 100, 'Makanan');

INSERT INTO products (id, name, description, price, quantity, category)
VALUES ('P0002', 'Mie Ayam Bakso', 'Mie Ayam + Bakso', 20000, 100, 'Makanan');

INSERT INTO products (id, name, price, quantity, category)
VALUES 
  ('P0003', 'Mie Ayam Ceker', 20000, 100, 'Makanan'),
  ('P0004', 'Mie Ayam Spesial', 25000, 100, 'Makanan'),
  ('P0005', 'Mie Ayam Yamin', 15000, 100, 'Makanan');

INSERT INTO products (id, category, name, price, quantity)
VALUES
  ('P0006', 'Makanan', 'Bakso Rusuk', 25000, 200),
  ('P0007', 'Minuman', 'Es Jeruk', 10000, 300),
  ('P0008', 'Minuman', 'Es Campur', 15000, 500),
  ('P0009', 'Minuman', 'Es Teh Manis', 5000, 400),
  ('P0010', 'Lain-lain', 'Kerupuk', 2500, 1000),
  ('P0011', 'Lain-lain', 'Keripik Udang', 10000, 300),
  ('P0012', 'Lain-lain', 'Es Krim', 5000, 200),
  ('P0013', 'Makanan', 'Mie Ayam Jamur', 20000, 50),
  ('P0014', 'Makanan', 'Bakso Telor', 20000, 150),
  ('P0015', 'Makanan', 'Bakso Jando', 25000, 300);

-- Insert & delete temporary product
INSERT INTO products (id, name, price, quantity)
VALUES ('P0006', 'Mie Ayam 6', 15000, 100);

DELETE FROM products WHERE id = 'P0006';

-- ====================================================
-- UPDATE DATA
-- ====================================================

UPDATE products SET category = 'Makanan' WHERE id = 'P0005';

UPDATE products
  SET category = 'Makanan',
      description = 'Mie Ayam Original + Ceker'
WHERE id = 'P0003';

UPDATE products SET price = price + 5000 WHERE id = 'P0005';

UPDATE products SET price = 1000 WHERE id = 'P0016';

-- ====================================================
-- BASIC SELECT & FILTERS
-- ====================================================

SELECT * FROM products;

SELECT id, name FROM products;

SELECT id AS "Kode", name AS "Nama", category AS "Kategori", price AS "Harga", quantity AS "Jumlah"
FROM products;

SELECT p.id AS "Kode", p.name AS "Nama", p.category AS "Kategori", p.price AS "Harga", p.quantity AS "Jumlah"
FROM products AS p;

SELECT * FROM products WHERE quantity = 100;
SELECT * FROM products WHERE price = 15000;

SELECT * FROM products WHERE quantity > 100 AND price > 20000;
SELECT * FROM products WHERE quantity > 100 OR price > 20000;

SELECT * FROM products
WHERE (category = 'Makanan' OR quantity > 500) AND price > 20000;

SELECT * FROM products WHERE name ILIKE '%mie%';

SELECT * FROM products WHERE description IS NOT NULL;

SELECT * FROM products WHERE price BETWEEN 10000 AND 20000;

SELECT * FROM products WHERE category IN ('Makanan', 'Minuman');

SELECT * FROM products ORDER BY category, price DESC;

SELECT * FROM products OFFSET 10 LIMIT 5;

SELECT DISTINCT category FROM products;

-- ====================================================
-- CALCULATIONS & FUNCTIONS
-- ====================================================

SELECT 10 * 10 AS hasil;

SELECT id, name, price / 1000 AS "price in k" FROM products;

SELECT id, SIN(price), COS(price) FROM products;

SELECT id, LOWER(name) AS "Lower Name", LENGTH(name) AS "Length Name" FROM products;

SELECT id, name, EXTRACT(MONTH FROM created_at) AS month, EXTRACT(YEAR FROM created_at) AS year FROM products;

SELECT id, name,
  CASE category
    WHEN 'Makanan' THEN 'Foods'
    WHEN 'Minuman' THEN 'Drinks'
    ELSE 'Others'
  END AS "Category"
FROM products;

SELECT id, name, price,
  CASE
    WHEN price <= 15000 THEN 'Cheap'
    WHEN price <= 20000 THEN 'Expensive'
    ELSE 'Very Expensive'
  END AS "Bargain"
FROM products;

SELECT id, name, price, COALESCE(description, 'No Description') AS "Description" FROM products;

-- ====================================================
-- AGGREGATIONS
-- ====================================================

SELECT COUNT(id) AS "Total Product" FROM products;
SELECT AVG(price) AS "Average Price" FROM products;
SELECT MIN(price) AS "Min Price" FROM products;
SELECT MAX(price) AS "Max Price" FROM products;
SELECT SUM(quantity) AS "Total Stock" FROM products;

SELECT category, COUNT(id) AS "Total Product" FROM products GROUP BY category;
SELECT category, AVG(price) AS "Average Price" FROM products GROUP BY category;
SELECT category, MIN(price) AS "Min Price" FROM products GROUP BY category;
SELECT category, MAX(price) AS "Max Price" FROM products GROUP BY category;
SELECT category, SUM(quantity) AS "Total Stock" FROM products GROUP BY category;

SELECT category, COUNT(id) AS total FROM products GROUP BY category HAVING COUNT(id) > 3;

-- ====================================================
-- FULLTEXT SEARCH
-- ====================================================

-- Search by LIKE
SELECT * FROM products WHERE name ILIKE '%ayam%' OR description ILIKE '%ayam%';

-- Fulltext search using to_tsvector and to_tsquery
SELECT * FROM products
WHERE to_tsvector('simple', coalesce(name,'') || ' ' || coalesce(description,''))
      @@ plainto_tsquery('ayam');

-- Boolean mode equivalent
SELECT * FROM products
WHERE to_tsvector('simple', coalesce(name,'') || ' ' || coalesce(description,''))
      @@ to_tsquery('ayam & !bakso');

-- Query expansion: not built-in; need custom logic; usually just another query
