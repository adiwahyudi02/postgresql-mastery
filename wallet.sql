-- ====================================================
-- WALLET TABLE & DATA
-- ====================================================

-- Create table `wallet` linked to `customers`
CREATE TABLE wallet (
  id SERIAL PRIMARY KEY,
  id_customer INTEGER NOT NULL UNIQUE,
  balance INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT fk_wallet_customer FOREIGN KEY (id_customer) REFERENCES customers(id)
);

-- Show table structure (PostgreSQL equivalent)
\d+ wallet

-- Insert wallets for customer id=1 and id=3
INSERT INTO wallet (id_customer)
VALUES (1);

-- View all wallets
SELECT * FROM wallet;

-- Join wallets with customer emails
SELECT customers.email, wallet.balance
FROM wallet
JOIN customers
  ON wallet.id_customer = customers.id;
