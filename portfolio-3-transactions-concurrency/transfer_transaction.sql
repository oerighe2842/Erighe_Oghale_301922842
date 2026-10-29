-- Portfolio 3: MulePay Concurrent Transfer with Row-Level Locking

BEGIN;

-- Set explicit isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 1. Lock sender wallet row to prevent concurrent overdrafts
SELECT wallet_id, balance 
FROM wallets 
WHERE wallet_id = '11111111-1111-1111-1111-111111111111'::uuid 
FOR UPDATE;

-- 2. Deduct funds from sender
UPDATE wallets 
SET balance = balance - 100.00 
WHERE wallet_id = '11111111-1111-1111-1111-111111111111'::uuid;

-- 3. Add funds to receiver
UPDATE wallets 
SET balance = balance + 100.00 
WHERE wallet_id = '22222222-2222-2222-2222-222222222222'::uuid;

-- 4. Record transaction log & double-entry ledger in one atomic batch using CTE
WITH new_tx AS (
  INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, transaction_type, reference_id, status)
  VALUES ('11111111-1111-1111-1111-111111111111'::uuid, '22222222-2222-2222-2222-222222222222'::uuid, 100.00, 'P2P_TRANSFER', 'TXN-99001', 'COMPLETED')
  RETURNING transaction_id
)
INSERT INTO ledger_entries (transaction_id, wallet_id, entry_type, amount)
SELECT transaction_id, '11111111-1111-1111-1111-111111111111'::uuid, 'DEBIT', 100.00 FROM new_tx
UNION ALL
SELECT transaction_id, '22222222-2222-2222-2222-222222222222'::uuid, 'CREDIT', 100.00 FROM new_tx;

COMMIT;