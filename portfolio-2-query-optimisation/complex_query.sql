EXPLAIN ANALYZE 
SELECT u.email, w.balance, t.amount, t.status
FROM users u
JOIN wallets w ON u.user_id = w.user_id
JOIN transactions t ON w.wallet_id = t.sender_wallet_id
WHERE u.email = 'investor@mulepay.com';
