-- Portfolio 4: NoSQL Document Model (JSONB) for MulePay

-- 1. Create a table to store flexible device and session metadata
CREATE TABLE IF NOT EXISTS user_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(user_id),
    session_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Insert unstructured NoSQL document data
-- Using the user_id '33333333-3333-3333-3333-333333333333' we seeded earlier
INSERT INTO user_sessions (user_id, session_data) 
VALUES (
    '33333333-3333-3333-3333-333333333333'::uuid,
    '{
        "device": {
            "type": "smartphone",
            "os": "iOS 16.4",
            "app_version": "2.1.0"
        },
        "location": {
            "ip_address": "192.168.1.100",
            "country": "Nigeria",
            "city": "Abuja"
        },
        "preferences": {
            "dark_mode": true,
            "notifications": ["email", "push"]
        }
    }'::jsonb
);

-- 3. Query the NoSQL JSONB data (Extracting specific fields)
-- This shows we can query deep inside the JSON document
SELECT 
    user_id,
    session_data -> 'device' ->> 'os' AS operating_system,
    session_data -> 'location' ->> 'city' AS login_city,
    session_data -> 'preferences' -> 'dark_mode' AS uses_dark_mode
FROM user_sessions;
