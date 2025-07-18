-- ===========================================
-- CUSTOMERS TABLE & DATA (PostgreSQL)
-- ===========================================

-- Create customers table
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  email VARCHAR(100) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

-- Check structure & show create
-- PostgreSQL doesn't have DESCRIBE or SHOW CREATE
-- Instead, use:
-- \d customers
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'customers';

-- Insert sample customer
INSERT INTO customers (email, first_name, last_name)
VALUES ('didi@gmail.com', 'didi', 'diding');

-- Select customers
SELECT * FROM customers;

-- Alter examples

-- Modify column type (here type stays the same, but this is the syntax)
ALTER TABLE customers ALTER COLUMN last_name TYPE VARCHAR(100);

-- Drop and add unique constraint
ALTER TABLE customers DROP CONSTRAINT email_unique;
ALTER TABLE customers ADD CONSTRAINT email_unique UNIQUE(email);

-- Drop column
ALTER TABLE customers DROP COLUMN email;

-- Add column again, at the *end* (PostgreSQL doesn't support AFTER)
ALTER TABLE customers 
  ADD COLUMN email VARCHAR(100) NOT NULL,
  ADD CONSTRAINT email_unique UNIQUE(email);
