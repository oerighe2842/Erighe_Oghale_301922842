-- Portfolio 5: MulePay Database Sharding Setup (Partitioning)

-- 1. Create a parent partitioned table for distributed transactions
CREATE TABLE transactions_distributed (
    transaction_id UUID NOT NULL,
    sender_wallet_id UUID NOT NULL,
    amount NUMERIC(18,4) NOT NULL,
    region VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
) PARTITION BY LIST (region);

-- 2. Create geographic shards (Simulating distributed cloud nodes)
CREATE TABLE transactions_africa 
    PARTITION OF transactions_distributed FOR VALUES IN ('AFRICA');

CREATE TABLE transactions_namerica 
    PARTITION OF transactions_distributed FOR VALUES IN ('NORTH_AMERICA');

CREATE TABLE transactions_europe 
    PARTITION OF transactions_distributed FOR VALUES IN ('EUROPE');

-- 3. Insert data to demonstrate automatic shard routing
INSERT INTO transactions_distributed (transaction_id, sender_wallet_id, amount, region)
VALUES 
(uuid_generate_v4(), '11111111-1111-1111-1111-111111111111'::uuid, 250.00, 'AFRICA'),
(uuid_generate_v4(), '22222222-2222-2222-2222-222222222222'::uuid, 900.00, 'NORTH_AMERICA');