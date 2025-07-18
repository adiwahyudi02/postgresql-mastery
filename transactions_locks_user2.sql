-- ====================================================
-- DEMO: Transactions, Locks, and Deadlock (User 2)
-- ====================================================

-- Start transaction
BEGIN;

-- View current guestbook rows
SELECT * FROM guestbooks;

-- Update title on guestbook entry with id=9
UPDATE guestbooks
  SET title = 'Update from user 2'
WHERE id = 9;

COMMIT;

-- View products
SELECT * FROM products;

-- Lock product P0001 for update and deduct quantity
BEGIN;

SELECT * FROM products
WHERE id = 'P0001'
FOR UPDATE;

UPDATE products
  SET quantity = quantity - 10
WHERE id = 'P0001';

COMMIT;

-- ====================================================
-- Simulate deadlock: lock order P0002 then P0001
-- ====================================================

BEGIN;

SELECT * FROM products
WHERE id = 'P0002'
FOR UPDATE;

SELECT * FROM products
WHERE id = 'P0001'
FOR UPDATE;

-- Do your updates or keep transaction open to simulate deadlock
-- COMMIT; or ROLLBACK;

-- ====================================================
-- LOCK TABLE: SHARE LOCK (blocks writes, allows reads)
-- ====================================================

BEGIN;

LOCK TABLE products IN SHARE MODE;

UPDATE products
  SET quantity = 100
WHERE id = 'P0001';

COMMIT;

-- ====================================================
-- LOCK TABLE: EXCLUSIVE LOCK (blocks reads & writes)
-- ====================================================

BEGIN;

LOCK TABLE products IN EXCLUSIVE MODE;

-- This SELECT from other sessions would now be blocked
SELECT * FROM products;

COMMIT;

-- ====================================================
-- LOCK INSTANCE: simulate metadata operation
-- (In PostgreSQL, no LOCK INSTANCE; instead, DDL is transactional)
-- For example, add a column
ALTER TABLE products
  ADD COLUMN sample VARCHAR(100);
