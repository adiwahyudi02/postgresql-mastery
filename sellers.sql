-- ===========================================
-- SELLERS TABLE & INDEXES
-- ===========================================

-- Create sellers table with unique constraint and index
CREATE TABLE sellers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

-- Add index on name column
CREATE INDEX name_index ON sellers(name);

-- Check structure
-- PostgreSQL equivalent to DESCRIBE:
\d sellers

-- PostgreSQL doesn’t have SHOW CREATE TABLE,
-- but you can see table definition with:
-- \d+ sellers
-- or query information_schema:
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'sellers';
