-- ====================================================
-- DEMO: Transactions, Locks, and Deadlock (User 1)
-- ====================================================

-- Start transaction
BEGIN;

-- View current guestbook rows
SELECT * FROM guestbooks;

-- Update title on guestbook entry with id=9
UPDATE guestbooks
  SET title = 'Hello from user 1'
WHERE id = 9;

-- Commit transaction
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
-- Simulate potential deadlock: lock order P0001 then P0002
-- ====================================================

BEGIN;

SELECT * FROM products
WHERE id = 'P0001'
FOR UPDATE;

SELECT * FROM products
WHERE id = 'P0002'
FOR UPDATE;

-- Do your updates or keep transaction open to simulate deadlock
-- COMMIT; or ROLLBACK;

-- ====================================================
-- LOCK TABLE: SHARE LOCK (like READ LOCK)
-- ====================================================

BEGIN;

LOCK TABLE products IN SHARE MODE; -- allows other reads, blocks writes

UPDATE products
  SET quantity = 100
WHERE id = 'P0001';

COMMIT;

-- ====================================================
-- LOCK TABLE: EXCLUSIVE LOCK (like WRITE LOCK)
-- ====================================================

BEGIN;

LOCK TABLE products IN EXCLUSIVE MODE; -- blocks reads and writes from other transactions

UPDATE products
  SET quantity = 100
WHERE id = 'P0001';

SELECT * FROM products;

COMMIT;
