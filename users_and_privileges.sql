-- ====================================================
-- Create new users (roles)
-- ====================================================
CREATE ROLE adi LOGIN;
CREATE ROLE wahyudi LOGIN;

-- ====================================================
-- Drop users if needed
-- ====================================================
DROP ROLE adi;
DROP ROLE wahyudi;

-- ====================================================
-- Grant privileges
-- ====================================================

-- Grant read-only access (SELECT) on schema public (typical) or on specific tables
GRANT CONNECT ON DATABASE learn_postgres TO adi;
GRANT USAGE ON SCHEMA public TO adi;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO adi;

-- Make future tables also selectable by adi
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO adi;

-- Grant full DML access (select, insert, update, delete) to wahyudi
GRANT CONNECT ON DATABASE learn_postgres TO wahyudi;
GRANT USAGE ON SCHEMA public TO wahyudi;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO wahyudi;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO wahyudi;

-- ====================================================
-- Show granted privileges
-- ====================================================
-- In psql CLI:
-- \du adi
-- \du wahyudi

-- Or query from system catalog:
SELECT grantee, table_catalog, privilege_type
FROM information_schema.table_privileges
WHERE grantee IN ('adi', 'wahyudi');

-- ====================================================
-- Set passwords
-- ====================================================
ALTER ROLE adi WITH PASSWORD 'password';
ALTER ROLE wahyudi WITH PASSWORD 'password';

-- ====================================================
-- Insert example data (if user has insert privilege)
-- (Run as the user: e.g., \c - adi or \c - wahyudi)
INSERT INTO guestbooks (email, title, content)
VALUES ('contoh4@gmail.com', 'Hello', 'Hello');
