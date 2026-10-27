-- 1. Create B-Tree index on email to optimize user lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- 2. Create B-Tree index on sender_wallet_id to optimize wallet transaction JOINs
CREATE INDEX IF NOT EXISTS idx_transactions_sender ON transactions(sender_wallet_id);

-- 3. Re-run execution plan to verify optimization performance
EXPLAIN ANALYZE 
SELECT u.email, w.balance, t.amount, t.status
FROM users u
JOIN wallets w ON u.user_id = w.user_id
JOIN transactions t ON w.wallet_id = t.sender_wallet_id
WHERE u.email = 'investor@mulepay.com';