-- ===========================================
-- ADMIN TABLE & DATA (PostgreSQL version)
-- ===========================================

-- Create admin table
CREATE TABLE admin (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

-- Check structure
-- PostgreSQL: use \d admin in psql or
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'admin';

-- Insert sample admins
INSERT INTO admin(first_name, last_name)
VALUES 
  ('dada', 'dadang'),
  ('didi', 'diding'),
  ('dodo', 'dodong');

-- Select all admins
SELECT * FROM admin;

-- Delete admin with id = 3
DELETE FROM admin WHERE id = 3;

-- Insert again and get last inserted ID
INSERT INTO admin(first_name, last_name)
VALUES ('dodo', 'dodong')
RETURNING id;
