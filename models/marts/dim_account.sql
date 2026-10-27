
SELECT
     account_id,
     account_name,
    country,
    employee_count
FROM {{ ref('stg_accounts') }}
