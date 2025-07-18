-- ===========================================
-- WISHLIST TABLE & RELATIONS
-- ===========================================

-- Create wishlist table with FK to products
CREATE TABLE wishlist (
  id SERIAL PRIMARY KEY,
  id_product VARCHAR(10) NOT NULL,
  description TEXT,
  CONSTRAINT fk_wishlist_product FOREIGN KEY (id_product) REFERENCES products(id)
);

-- Check structure
\d wishlist

-- PostgreSQL doesn’t have SHOW CREATE TABLE, but use:
-- \d+ wishlist

-- Insert wishlist item linked to products
INSERT INTO wishlist (id_product, description)
VALUES ('P0001', 'Makan Kesukaan');

-- Insert invalid wishlist (product not exists)
-- This will fail due to FK constraint
INSERT INTO wishlist (id_product, description)
VALUES ('P0001111', 'Makan Kesukaan');

-- Add id_customer column and FK to customers
ALTER TABLE wishlist ADD COLUMN id_customer INTEGER;

ALTER TABLE wishlist 
  ADD CONSTRAINT fk_wishlist_customer FOREIGN KEY(id_customer) REFERENCES customers(id);

-- Example update: set customer
UPDATE wishlist SET id_customer = 1 WHERE id = 1;

-- Drop FK & column if needed
ALTER TABLE wishlist 
  DROP CONSTRAINT fk_wishlist_customer;

ALTER TABLE wishlist 
  DROP COLUMN id_customer;

-- Re-add FK with cascade behavior
ALTER TABLE wishlist DROP CONSTRAINT fk_wishlist_product;

ALTER TABLE wishlist ADD CONSTRAINT fk_wishlist_product
  FOREIGN KEY (id_product) REFERENCES products(id)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- ===========================================
-- JOINS WITH PRODUCTS & CUSTOMERS
-- ===========================================

-- Wishlist with product names
SELECT * FROM wishlist
JOIN products ON wishlist.id_product = products.id;

-- Selected columns with alias
SELECT w.id AS id_wishlist, p.id AS id_product, p.name, w.description
FROM wishlist AS w
JOIN products AS p ON w.id_product = p.id;

-- Wishlist with customer emails
SELECT customers.email, products.id, products.name, wishlist.description
FROM wishlist
JOIN customers ON wishlist.id_customer = customers.id
JOIN products ON wishlist.id_product = products.id;

-- Check tables and describe
-- View all tables in current schema
\dt

-- Describe tables
\d wishlist
\d customers
