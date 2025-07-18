-- ====================================================
-- GUESTBOOK TABLE & BASIC OPERATIONS
-- ====================================================

-- Create guestbooks table
CREATE TABLE guestbooks (
  id SERIAL PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT
);

-- Describe table structure
-- PostgreSQL: use \d guestbooks
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'guestbooks';

-- Insert sample data
INSERT INTO guestbooks (email, title, content)
VALUES 
  ('guest1@gmail.com', 'Hello', 'Hello'),
  ('guest2@gmail.com', 'Hello', 'Hello'),
  ('guest3@gmail.com', 'Hello', 'Hello'),
  ('dada@gmail.com', 'Hello', 'Hello'),
  ('dada@gmail.com', 'Hello', 'Hello'),
  ('dada@gmail.com', 'Hello', 'Hello');

-- View data
SELECT * FROM guestbooks;

-- Remove all rows (reset table)
TRUNCATE guestbooks;

-- ====================================================
-- SELECT & UNION EXAMPLES WITH CUSTOMERS
-- ====================================================

-- View distinct emails from customers and guestbooks
SELECT DISTINCT email FROM customers;
SELECT DISTINCT email FROM guestbooks;

-- Union: distinct emails from both tables
SELECT DISTINCT email FROM customers
UNION
SELECT DISTINCT email FROM guestbooks;

-- Union (without distinct explicitly, still distinct by default)
SELECT email FROM customers
UNION
SELECT email FROM guestbooks;

-- Union all: include duplicates
SELECT email FROM customers
UNION ALL
SELECT email FROM guestbooks;

-- Count number of occurrences per email across both tables
SELECT emails.email, COUNT(emails.email)
FROM (
  SELECT email FROM customers
  UNION ALL
  SELECT email FROM guestbooks
) AS emails
GROUP BY emails.email;

-- ====================================================
-- JOIN EXAMPLES: INTERSECT & EXCEPT-LIKE QUERIES
-- ====================================================

-- Emails that appear in both customers and guestbooks (intersect)
SELECT DISTINCT email FROM customers
WHERE email IN (SELECT DISTINCT email FROM guestbooks);

-- Same as above using INNER JOIN
SELECT DISTINCT customers.email 
FROM customers
INNER JOIN guestbooks
  ON customers.email = guestbooks.email;

-- Emails in customers not found in guestbooks (except)
SELECT DISTINCT customers.email
FROM customers
LEFT JOIN guestbooks
  ON customers.email = guestbooks.email
WHERE guestbooks.email IS NULL;

-- ====================================================
-- TRANSACTION EXAMPLES
-- ====================================================

-- Start transaction and insert sample data
BEGIN;

INSERT INTO guestbooks (email, title, content)
VALUES 
  ('contoh@gmail.com', 'Hello', 'Hello'),
  ('contoh2@gmail.com', 'Hello', 'Hello'),
  ('contoh3@gmail.com', 'Hello', 'Hello');

-- View inserted data
SELECT * FROM guestbooks;

-- Commit changes
COMMIT;

-- Start another transaction to delete all rows
BEGIN;

DELETE FROM guestbooks;

-- Rollback to undo deletion
ROLLBACK;
