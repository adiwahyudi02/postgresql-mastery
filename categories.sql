-- ====================================================
-- CATEGORIES TABLE & LINK TO PRODUCTS (PostgreSQL)
-- ====================================================

-- Create categories table
CREATE TABLE categories (
  id VARCHAR(10) NOT NULL,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Describe tables
-- PostgreSQL: use \d categories and \d products in psql, or:
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'categories';

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'products';

-- Add id_category column in products & foreign key constraint
ALTER TABLE products
  ADD COLUMN id_category VARCHAR(10),
  ADD CONSTRAINT fk_product_category
    FOREIGN KEY (id_category) REFERENCES categories (id);

-- Show table after changes
-- PostgreSQL: use \d products or pg_dump or:
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products';

-- Insert category data
INSERT INTO categories (id, name)
VALUES 
  ('C0001', 'Makanan'),
  ('C0002', 'Minuman'),
  ('C0003', 'Lain-lain');

-- View categories & products
SELECT * FROM categories;
SELECT * FROM products;

-- ====================================================
-- UPDATE PRODUCTS TO LINK TO CATEGORIES
-- ====================================================

-- Link 'Makanan' products to category C0001
UPDATE products
SET id_category = 'C0001'
WHERE id IN ('P0001', 'P0002', 'P0003', 'P0004', 'P0005', 'P0006', 'P0013', 'P0014', 'P0015');

-- Link 'Minuman' products to category C0002
UPDATE products
SET id_category = 'C0002'
WHERE id IN ('P0007', 'P0008', 'P0009');

-- Link 'Lain-lain' products to category C0003
UPDATE products
SET id_category = 'C0003'
WHERE id IN ('P0010', 'P0011', 'P0012', 'P0016');

-- ====================================================
-- JOIN PRODUCTS WITH CATEGORIES
-- ====================================================

SELECT products.id, products.name, categories.name AS category_name
FROM products
JOIN categories
  ON products.id_category = categories.id;
