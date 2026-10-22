-- MulePay Relational Schema DDL
-- Student: Erighe Oghale (301922842)
-- Database Engine: PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    kyc_status VARCHAR(20) NOT NULL DEFAULT 'PENDING' 
        CHECK (kyc_status IN ('PENDING', 'VERIFIED', 'REJECTED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Wallets Table
CREATE TABLE wallets (
    wallet_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    balance NUMERIC(18, 4) NOT NULL DEFAULT 0.0000 
        CONSTRAINT check_positive_balance CHECK (balance >= 0.0000),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' 
        CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_currency UNIQUE (user_id, currency)
);

-- 3. Transactions Table
CREATE TABLE transactions (
    transaction_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_wallet_id UUID REFERENCES wallets(wallet_id),
    receiver_wallet_id UUID REFERENCES wallets(wallet_id),
    amount NUMERIC(18, 4) NOT NULL CHECK (amount > 0),
    transaction_type VARCHAR(20) NOT NULL 
        CHECK (transaction_type IN ('P2P_TRANSFER', 'DEPOSIT', 'WITHDRAWAL', 'MERCHANT_PAYMENT')),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' 
        CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED', 'REVERSED')),
    reference_id VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_different_wallets CHECK (sender_wallet_id <> receiver_wallet_id)
);

-- 4. Ledger Entries Table (Double-Entry Accounting)
CREATE TABLE ledger_entries (
    entry_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    wallet_id UUID NOT NULL REFERENCES wallets(wallet_id),
    entry_type VARCHAR(6) NOT NULL CHECK (entry_type IN ('DEBIT', 'CREDIT')),
    amount NUMERIC(18, 4) NOT NULL CHECK (amount > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);