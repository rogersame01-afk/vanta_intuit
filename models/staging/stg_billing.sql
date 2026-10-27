    SELECT
        CAST(billing_id AS VARCHAR) AS billing_id,
        CAST(account_id AS VARCHAR) AS account_id,
        CAST(usage_date AS DATE) AS usage_date,
        CAST(net_revenue_usd AS NUMBER(18, 2)) AS net_revenue_usd,
        CAST(loaded_date AS DATE) AS loaded_date,
        CAST(version AS INTEGER) AS version

    FROM {{ source('billing', 'BILLING') }}